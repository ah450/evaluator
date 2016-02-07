require 'open3'
class SubmissionEvaluationJob < ActiveJob::Base
  queue_as :default

  rescue_from(UnzipError) do |ex|
    submission = arguments[0]
    submission.with_lock('FOR UPDATE') do
      submission.results.destroy_all
      submission.project.test_suites.each do |suite|
        result = Result.new submission: submission, test_suite: suite,
        project: submission.project, grade: 0, max_grade: suite.max_grade
        result.compiler_stderr = 'Unzip Error.'
        result.compiler_stdout = 'Unzip error.'
        result.compiled = false
        result.success = false
        # Ignore exceptions
        result.save
      end
    end
  end

  def perform(submission)
    @newResults = []
    submission.with_lock('FOR UPDATE') do
        suites = submission.project.test_suites.to_a
        @old_working_directory = Dir.pwd
        @working_directory = Dir.mktmpdir "submit"
        @selinux_directory = Dir.mktmpdir "submit"
        @command =  "sandbox -M -H #{@working_directory} -T #{@selinux_directory} bash"
        @compile_command = @command + " #{config[:ant_compile_file_name]} 2>&1"
        @compile_test_command = @command + " #{config[:ant_compile_tests_file_name]} 2>&1"
        @test_command = @command + " #{config[:ant_test_file_name]} 2>&1"
        Dir.chdir @working_directory
        `chmod -R +x #{@working_directory}`
        `chmod -R +x #{@selinux_directory}`
        fetch_dependencies
        prepare_src(submission)
        begin
          suites.each do |suite|
            remove_old_tests
            test_suite submission, suite
            @newResults.push @result
            if submission.submitter.student?
              create_team_grade(suite)
            end
          end
        ensure
          Dir.chdir @old_working_directory
          FileUtils.remove_entry_secure @working_directory
          FileUtils.remove_entry_secure @selinux_directory
        end
    end
    @newResults.each { |result| submission.send_new_result_notification(result) }
  end

  def test_suite(submission, suite)
    @result = Result.new submission: submission, test_suite: suite,
      project: submission.project, grade: 0, max_grade: suite.max_grade
    @result.success = @compiled
    @result.compiled = @compiled
    @result.compiler_stderr = @compiler_stderr
    @result.compiler_stdout = @compiler_stdout
    @result.save!
    if @result.compiled
      # Run tests
      prepare_suite(suite)
      generate_test_script(suite)
      # Compile tests
      test_compile_out = `#{@compile_test_command}`
      if $?.exitstatus != 0
        # Test compilation failed
        @result.compiled = false
        @result.compiler_stdout = test_compile_out
        @result.success = false
        @result.save!
        return
      end
      # Run tests
      out = `#{@test_command}`
      results_directory = File.join(@build_directory, 'tests')
      Dir.glob "#{results_directory}/**/*.xml" do |file_name|
        document = File.open(file_name) {|f| Nokogiri::XML(f)}
        parse_result document, suite
      end
      @result.save!
    end
  end

  def create_team_grade(suite)
    grades = TeamGrade.where(project: @result.project,
      name: @result.submission.submitter.team).joins(:result).where(results: {
        test_suite_id: @result.test_suite.id
      }).order(created_at: :desc).delete_all
    @team_grade = TeamGrade.create(project: @result.project,
      result: @result, name: @result.submission.submitter.team
    )
  end

  def parse_result(document, suite)
    document.css('testcase').each do |test_case_node|
      test_case = TestCase.new result: @result
      test_case.java_klass_name = test_case_node['classname']
      test_case.passed = true
      test_case.name = test_case_node['name']
      test_case.max_grade = 0
      test_case.detail = ''
      suite_case = suite.suite_cases.where(name: test_case.name).first
      test_case.max_grade = suite_case.grade if !suite_case.nil?
      test_case.grade = test_case.max_grade
      test_case_node.css('failure').each do |failure|
        test_case.passed = false
        test_case.grade = 0
        test_case.detail += ' ' + failure['type'] + ' ' + failure.content
        @result.success &= false
      end
      test_case_node.css('error').each do |error|
        test_case.passed = false
        @result.success &=  false
        test_case.grade = 0
        test_case.detail += error.content + ' '
      end
      @result.grade += test_case.grade
      test_case.save!
    end
  end

  def extract_source(submission)
    old = Dir.entries Dir.pwd
    IO.binwrite(@submission_code_name_ext, submission.solution.code)
    `unzip -u #{@submission_code_name_ext}`
    raise UnzipError, "submission #{submission.id}" if $?.exitstatus != 0
    FileUtils.remove @submission_code_name_ext
    newEntries = Dir.entries Dir.pwd
    newEntries.each do |entry|
      if File.directory?(entry) && !old.include?(entry)
        @src_directory = entry
      end
    end
  end

  def extract_tests(suite)
    IO.binwrite(suite.suite_code.file_name, suite.suite_code.code)
    `unzip -u #{suite.suite_code.file_name}`
    raise UnzipError, "suite #{suite.id}" if $?.exitstatus != 0
    FileUtils.remove suite.suite_code.file_name
  end

  def fetch_dependencies
    lib_src = File.join(Rails.root, 'app', 'views', 'runner', 'lib')
    `cp -r #{lib_src} #{@working_directory}`
  end

  def prepare_suite(suite)
    extract_tests(suite)
    @buildfile_name = config[:ant_build_tests_file_name]
    @tests_directory = File.basename(suite.suite_code.file_name,
      File.extname(suite.suite_code.file_name))
    @test_build_template = ERB.new(File.read(File.join(
      Rails.root, 'app', 'views', 'runner', 'build_test.xml.erb')))
    result = @test_build_template.result(binding)
    IO.write(@buildfile_name, result)
    `chmod +x #{@buildfile_name}`

  end
  def generate_test_script(suite)
    # Run tests scripts
    @test_timeout = suite.timeout
    @test_script_name = config[:ant_test_file_name]
    @test_template = ERB.new(File.read(File.join(
      Rails.root, 'app', 'views', 'runner', 'test.sh.erb'
    )))
    result = @test_template.result(binding)
    IO.write(@test_script_name, result)
    `chmod +x #{@test_script_name}`
    # Compile tests scripts
    @compile_tests_script_name = config[:ant_compile_tests_file_name]
    @compile_test_template = ERB.new(File.read(File.join(
      Rails.root, 'app', 'views', 'runner', 'compile_test.sh.erb'
      )))
    result = @compile_test_template.result(binding)
    IO.write(@compile_tests_script_name, result)
    `chmod +x #{@compile_tests_script_name}`
  end

  def prepare_src(submission)
    in_use_names = Dir.entries Dir.pwd
    in_use_names << config[:ant_build_tests_file_name]
    in_use_names << config[:ant_build_src_file_name] << config[:ant_compile_file_name]
    in_use_names << config[:ant_build_dir_name] << config[:ant_test_file_name]
    in_use_names << config[:ant_compile_tests_file_name]
    @enumerator = LowerCaseEnumerator.new in_use_names
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
    compile_src
  end


  def generate_compile_script
    @compile_script_name = config[:ant_compile_file_name]
    @compile_template = ERB.new(File.read(File.join(
      Rails.root, 'app', 'views', 'runner', 'compile.sh.erb'
    )))
    result = @compile_template.result(binding)
    IO.write(@compile_script_name, result)
    `chmod +x #{@compile_script_name}`
  end

  def compile_src
    @build_directory = config[:ant_build_dir_name]
    @build_template = ERB.new(File.read(File.join(
      Rails.root, 'app', 'views', 'runner', 'build_src.xml.erb')))
    @buildfile_name = config[:ant_build_src_file_name]
    result = @build_template.result(binding)
    IO.write(@buildfile_name, result)
    `chmod +x #{@buildfile_name}`
    generate_compile_script
    @compiler_stdout = `#{@compile_command}`
    @compiled = $?.exitstatus == 0
    @compiler_stderr = '-'
    @compiler_stdout = '-' if @compiler_stdout.size == 0
  end

  def remove_old_tests
    Dir.glob  "#{@build_directory}/**/*Test.class" do |file_name|
      File.delete file_name
    end
  end

  def config
    Rails.application.config.runner
  end

end
