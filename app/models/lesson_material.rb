class LessonMaterial < ActiveRecord::Base
  def self.save(upload, title)
    
    name =  upload.original_filename
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload.read) }
    
    lessonMaterial = LessonMaterial.new
    lessonMaterial.file_name = name   
    lessonMaterial.title = title 
    lessonMaterial.save!
  end
end
