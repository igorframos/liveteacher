class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :rating
      t.integer :lesson_material_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
