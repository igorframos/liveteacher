class AddDownloadsCountToLessonMaterial < ActiveRecord::Migration
  def self.up
    add_column :lesson_materials, :downloads_count, :integer
  end

  def self.down
    remove_column :lesson_materials, :downloads_count
  end
end
