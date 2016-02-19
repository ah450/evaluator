# == Schema Information
#
# Table name: reset_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reset_tokens_on_created_at         (created_at)
#  index_reset_tokens_on_user_id            (user_id) UNIQUE
#  index_reset_tokens_on_user_id_and_token  (user_id,token)
#
# Foreign Keys
#
#  fk_rails_0164532167  (user_id => users.id)
#

class ResetToken < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true, uniqueness: true
  validates :token, presence: true
end
