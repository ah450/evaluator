=begin
Model representing result of a suite_case when run against a submission.
=end

class TestCase < ActiveRecord::Base
  belongs_to :result
end
