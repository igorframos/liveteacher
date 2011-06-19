class LessonMaterialController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index
    @files = LessonMaterial.find :all
    render :file => 'app/views/lesson_material/index.rhtml'
  end

  def uploadFile
    LessonMaterial.save(params[:upload], params[:title])
    flash[:notice] = 'Lesson added'
    self.index
  end

end
