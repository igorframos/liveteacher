class LessonMaterialController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index
    @files = LessonMaterial.find :all
    render :file => 'app/views/lesson_material/index.rhtml'
    flash[:notice] = ''
  end

  def uploadFile
    unless params[:upload]
        flash[:notice] = 'Escolha um arquivo para enviar'
        self.index
        return
    end

    unless params[:title] and params[:title] != ''
        flash[:notice] = 'Escolha um titulo para o seu upload'
        self.index
        return
    end

    unless params[:discipline] and params[:discipline] != '' and params[:discipline] != 'EMPTY'
      flash[:notice] = 'Escolha uma disciplina para o seu upload'
      self.index
      return
    end

    LessonMaterial.save(params[:upload], params[:title], params[:discipline], params[:comment])
    flash[:notice] = 'Material enviado'
    self.index
  end

  def details
      @material = LessonMaterial.find_by_id params[:id]
      @comments = Comments.find_all_by_lesson_material_id @material.id
      render :file => 'app/views/lesson_material/details.rhtml'
      flash[:notice] = ''
  end

  def comment
      unless params[:id] and params[:id].to_i >= 0 and params[:id].to_i <= LessonMaterial.count
          params[:id] = 1
          flash[:notice] = 'Algo errado aconteceu e estamos investigando'
          self.details
          return
      end

      unless params[:name] and params[:name] != ''
          flash[:notice] = 'Por favor, entre com o nome do autor para comentar'
          self.details
          return
      end

      unless params[:email] and params[:email] != '' and params[:email] =~ /((\d|\w|\.)+)@(\d|\w)+\.(\d|\w|\.)+/
          flash[:notice] = 'Por favor, entre com um email valido'
          self.details
          return
      end

      unless params[:text] and params[:text] != ''
          flash[:notice] = 'Seu comentario precisa ter algum texto'
          self.details
          return
      end

      materialId = params[:id]
      name = params[:name]
      email = params[:email]
      text = params[:text]

      Comments.save(materialId, name, email, text)

      flash[:notice] = 'Comentario adicionado corretamente!'
      self.details
  end

  def download
    material = LessonMaterial.find_by_id params[:id]
    material.downloads_count += 1
    material.save!
    redirect_to "/data/"+material.file_name
  end

  def rate
      Rating.save(params[:id], params[:grade])

      render :text => 'Sucesso'
  end

end
