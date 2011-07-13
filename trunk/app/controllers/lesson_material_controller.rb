class LessonMaterialController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index
    @files = LessonMaterial.find :all
    render :file => 'app/views/lesson_material/index.rhtml'
  end

  def uploadFile
    unless params[:upload]
        flash[:notice] = 'Choose a file to upload'
        self.index
        return
    end

    unless params[:title] and params[:title] != ''
        flash[:notice] = 'Choose a title to your upload'
        self.index
        return
    end

    unless params[:discipline] and params[:discipline] != '' and params[:discipline] != 'EMPTY'
      flash[:notice] = 'Choose a discipline to your upload'
      self.index
      return
    end

    LessonMaterial.save(params[:upload], params[:title], params[:discipline])
    flash[:notice] = 'Lesson added'
    self.index
  end

  def details
      @material = LessonMaterial.find_by_id params[:id]
      @comments = Comments.find_all_by_lesson_material_id @material.id
      render :file => 'app/views/lesson_material/details.rhtml'
  end

  def comment
  end

end