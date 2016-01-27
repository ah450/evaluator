require 'open3'
class SubmissionEvaluationJob < ActiveJob::Base
  queue_as :default

  def perform(submission)
    submission.with_lock('FOR UPDATE') do
      submission.project.test_suites.each do |suite|
        @old_working_directory = Dir.pwd
        @working_directory = Dir.mktmpdir
        @selinux_directory = Dir.mktmpdir
        begin
          dir.chdir @working_directory
          test_suite submission, suite
        ensure
          Dir.chdir @old_working_directory
          FileUtils.remove_entry_secure @working_directory
          FileUtils.remove_entry_secure @selinux_directory
        end
      end
    end
  end

  def test_suite(submission, suite)
    setup_directory(submission, suite)
    @result = Result.new submission: submission, suite: suite,
      project: submission.project, grade: 0, max_grade: suite.max_grade
    run_sandbox
  end

  def run_sandbox(suite)
    command =  "sandbox -M -H #{@working_directory} #{@selinux_directory} bash"
    compile_command = command + " #{config[:ant_compile_file_name]}"
    test_command = command + " #{config[:ant_test_file_name]}"
    # Compile
    Open3.popen3 compile_command do |stdin, stdout, stderr, thread|
      exit_status = thread.value
      @result.compiler_stderr = stderr
      @result.compiler_stdout = stdout
      @result.compiled = exit_status == 0
    end
    @result.save!
    # Test
    if @result.compiled
      Open3.popen3 test_command do |stdin, stdout, stderr, thread|
        exit_status = thread.value
        results_directory = File.join(@build_directory, 'tests')
        Dir.glob "#{results_directory}/**/*.xml" do |file_name|
          document = File.open file_name {|f| Nokogiri::XML(f)}
          parse_result document, suite
        end
      end
    end
    @result.save!
  end

  def parse_result(document, suite)
    document.css('testcase').each do |test_case_node|
      test_case = TestCase.new result: @result
      test_case.java_klass_name = test_case_node['classname']
      test_case.passed = true
      test_case.name = test_case_node['name']
      test_case.detail = ''
      test_case.max_grade = suite.suite_cases.where(name: test_case.name).first
      test_case.grade = test_case.max_grade
      test_case_node.css('failure').each do |failure|
        test_case.passed = false
        test_case.grade = 0
        test_case.detail += failure.content + '\n'
      end
      test_case_node.css('error').each do |error|
        test_case.passed = false
        test_case.grade = 0
        test_case.detail += failure.content + '\n'
      end
      @result.grade += test_case.grade
      test_case.save!
    end
  end

  def setup_directory(submission, suite)
    extract_tests(suite)
    in_use_names = Dir.entries Dir.pwd
    @tests_directory = File.base_name(suite.suite_code.file_name,
      File.extname(suite.suite_code.file_name))
    in_use_names << config[:ant_build_file_name] << config[:ant_compile_file_name]
    in_use_names << config[:ant_build_dir_name] << config[:ant_test_file_name]
    @enumerator = LowerCaseEnumerator.new in_use_names
    # Check if submission name would overwrite
    no_extension_name = File.basename(submission.solution.file_name,
      File.extname(submission.solution.file_name)
      )
    if in_use_names.include? no_extension_name
      @submission_code_name = @enumerator.get_token
      @submission_code_name_ext = "#{submission_code_name}.zip"
    else
      @submission_code_name = no_extension_name
      @submission_code_name_ext = submission.solution.file_name
    end
    extract_source(submission)
    generate_ant_scripts(suite)
  end

  def generate_ant_scripts(suite)
    # Generate build script
    @build_directory = config[:ant_build_dir_name]
    @src_directory = @submission_code_name
    @build_template = ERB.new(File.read(File.join(
      Rails.root, 'app', 'views', 'runner', 'build.xml.erb')))
    result = @build_template.result(binding)
    IO.write(config[:ant_build_file_name], result)
    # Generate compile script
    @buildfile_name = config[:ant_build_file_name]
    @compile_template = ERB.new(File.read(File.join(
      Rails.root, 'app', 'views', 'runner', 'compile.sh.erb')))
    result = @compile_template.result(binding)
    IO.write(config[:ant_compile_file_name], result)
    # Generate test script
    @test_timeout = suite.timeout
    @test_template = ERB.new(File.read(File.join(
      Rails.root, 'app', 'views', 'runner', 'test.sh.erb'
      )))
    result = @test_template.result(binding)
    IO.write(config[:ant_test_file_name], result)
  end

  def extract_source(submission)
    IO.binwrite(@submission_code_name_ext, submission.solution.code)
    `unzip #{@submission_code_name_ext}`
    raise UnzipError, "submission #{submission.id}" if $?.exitstatus != 0
    FileUtils.remove @submission_code_name_ext
  end

  def extract_tests(suite)
    IO.binwrite(suite.suite_code.file_name, suite.suite_code.code)
    `unzip #{suite.suite_code.file_name}`
    raise UnzipError, "suite #{suite.id}" if $?.exitstatus != 0
    FileUtils.remove suite.suite_code.file_name
  end


  def config
    Rails.application.config.runner
  end

end
