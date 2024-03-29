class LessonMaterial < ActiveRecord::Base

  has_many :comments
  has_many :rating

  def self.save(upload, title, discipline, comment="")
      name =  'id-' + LessonMaterial.count.to_s + '-' + upload.original_filename
      name = name.gsub(' ', '_')
      name = name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'')
      directory = "public/data"
      # create the file path
      path = File.join(directory, name)
      # write the file
      File.open(path, "wb") { |f| f.write(upload.read) }

      lessonMaterial = LessonMaterial.new
      lessonMaterial.file_name = name
      lessonMaterial.title = title
      lessonMaterial.discipline = discipline
      lessonMaterial.downloads_count = 0
      lessonMaterial.comment = comment
      lessonMaterial.save!
      lessonMaterial
  end

end

