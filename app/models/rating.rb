class Rating < ActiveRecord::Base
    belongs_to :lessonMaterial

    def self.save(id, grade)
        rating = Rating.new

        rating.lesson_material_id = id
        rating.rating = grade.to_i

        rating.save!
    end
end
