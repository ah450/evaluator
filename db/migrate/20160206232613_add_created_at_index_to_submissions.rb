class AddCreatedAtIndexToSubmissions < ActiveRecord::Migration
  def change
    add_index 'submissions', ['created_at']
  end
end
