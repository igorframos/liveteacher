class LessonMaterial < ActiveRecord::Base

  has_many :comments
  def self.save(upload, title, discipline)

      name =  upload.original_filename
      directory = "public/data"
      # create the file path
      path = File.join(directory, name)
      # write the file
      File.open(path, "wb") { |f| f.write(upload.read) }

      lessonMaterial = LessonMaterial.new
      lessonMaterial.file_name = name   
      lessonMaterial.title = title 
      lessonMaterial.discipline = discipline
      lessonMaterial.save!
  end
end