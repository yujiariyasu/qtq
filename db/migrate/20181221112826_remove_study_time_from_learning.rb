class RemoveStudyTimeFromLearning < ActiveRecord::Migration[5.0]
  def change
    remove_column :learnings, :study_time, :integer
  end
end
