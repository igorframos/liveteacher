class SearchController < ApplicationController
   
   skip_before_filter :verify_authenticity_token

  def index
      render :file => 'app/views/search/search_home.rhtml'
  end 

  def searchByTitle
      @query = params[:query]
      @files = LessonMaterial.where("title LIKE '%#{@query}%'")
      render :file => 'app/views/search/search_results.rhtml'
  end

  def searchByDiscipline
      @query = params[:queryD]
      @files = LessonMaterial.where("discipline = '#{@query}'")
      render :file => 'app/views/search/search_results.rhtml'
  end

end
