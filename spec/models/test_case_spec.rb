require 'rails_helper'

RSpec.describe TestCase, type: :model do
  it { should belong_to :result }
end
