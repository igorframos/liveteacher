class SearchController < ApplicationController
   
   skip_before_filter :verify_authenticity_token

  def index
      render :file => 'app/views/search/search_home.rhtml'
  end 

  def searchByTitle
      @str = params[:query]

      if @str == '' then
          self.index
          return
      end

      @query = @str.split

      @files = LessonMaterial.find :all
      for q in @query do
          @files = @files & LessonMaterial.where("title LIKE '%#{q}%'")
      end

      render :file => 'app/views/search/search_results.rhtml'
  end

  def searchByDiscipline
      @query = params[:queryD]

      if @query == 'EMPTY' then
          self.index
          return
      end

      @str = @query

      @files = LessonMaterial.where("discipline = '#{@query}'")
      render :file => 'app/views/search/search_results.rhtml'
  end

end
