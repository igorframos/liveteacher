class CreateLessonMaterials < ActiveRecord::Migration
  def self.up
    create_table :lesson_materials do |t|
      t.string :title
      t.string :file_name
      t.string :discipline
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :lesson_materials
  end
end
