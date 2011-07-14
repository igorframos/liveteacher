class Comments < ActiveRecord::Base
    belongs_to :lessonMaterial
    def self.save(materialId, name, email, text)
        comment = Comments.new
        comment.lesson_material_id = materialId
        comment.name = name
        comment.email = email
        comment.text = text
        comment.save!
    end
end
