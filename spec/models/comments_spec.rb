require 'spec_helper'

describe Comments do
    it "should belong to a lesson material" do
        lessonMaterial = LessonMaterial.create! :title => 'title', :file_name => 'file_name', :discipline => 'discipline'
        comment = Comments.create! :lesson_material_id => lessonMaterial.id, :email => 'email', :text => 'blah' 
        comment.lesson_material_id.should eql(lessonMaterial.id)
    end

end
