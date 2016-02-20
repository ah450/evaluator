# == Schema Information
#
# Table name: contacts
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  text        :text             not null
#  title       :string           not null
#  reported_at :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_contacts_on_reported_at  (reported_at)
#  index_contacts_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_8d2134e55e  (user_id => users.id)
#

class Contact < ActiveRecord::Base
  belongs_to :user
  validates :text, :title, :reported_at, presence: true
  after_create :send_email


  private
  def send_email
    UserMailer.contact_report(self).deliver_later
  end
end
