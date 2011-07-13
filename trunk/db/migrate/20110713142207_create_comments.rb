class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :email
      t.string :name
      t.string :text
      t.integer :lesson_material_id

      t.timestamps :date
    end
  end

  def self.down
    drop_table :comments
  end
end
