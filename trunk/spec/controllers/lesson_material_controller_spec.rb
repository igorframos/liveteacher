require 'spec_helper'

describe LessonMaterialController do

    before :each do
        @mock_file = mock(File)
        @mock_file.stub!(:original_filename).and_return('blah.txt', 'a.txt', 'b.txt')
        @mock_file.stub!(:read).and_return(65, 10, 20)
        @material = LessonMaterial.create!(:title => 'arquivo 1', :file_name => '1.txt', :discipline => 'MAT')
    end

    after :each do
        begin
          File.delete('public/data/id-1-blah.txt')
          File.delete('public/data/id-2-a.txt')
          File.delete('public/data/id-3-b.txt')
          LessonMaterial.delete(@material.id)
        rescue
        end
    end    


    it 'should flash an error message when there is no file to upload' do
        post 'uploadFile', {:title => 'Teste', :discipline => 'MAT'}
        flash[:notice].should eql('Choose a file to upload')
    end

    it 'should flash an error message when there is no title to the upload' do
        post 'uploadFile', {:title => '', :upload => @mock_file, :discipline => 'MAT'}
        flash[:notice].should eql('Choose a title to your upload')
    end

    it 'should flash an error message when there is no discipline to the upload' do
        post 'uploadFile', {:title => 'Teste', :upload => @mock_file}
        flash[:notice].should eql('Choose a discipline to your upload')
    end

    it 'should flash an error message when discipline is EMPTY' do
        post 'uploadFile', {:title => 'Teste', :upload => @mock_file, :discipline => 'EMPTY'}
        flash[:notice].should eql('Choose a discipline to your upload')
    end


    it 'should load the page correctly when an upload is requested' do
        post 'uploadFile', { :title => 'Teste', :upload => @mock_file, :discipline => 'MAT' }
        response.should be_success
    end

    it 'should render the correct page when an upload is made' do
        post 'uploadFile', { :title => 'Teste', :upload => @mock_file, :discipline => 'MAT' }
        response.should render_template('index')
    end

    it 'should save a file correctly and display a message' do
        post 'uploadFile', {:title => 'Teste', :upload => @mock_file, :discipline => 'MAT'}
        flash[:notice].should eql('Lesson added')
        File.open('public/data/id-1-blah.txt', "rb") { |f| f.read.should eql("65") }
    end

    it 'should find all the files uploaded' do
        post 'uploadFile', {:title => 'arquivo 1', :upload => @mock_file, :discipline => 'MAT'}
        post 'uploadFile', {:title => 'arquivo 2', :upload => @mock_file, :discipline => 'MAT'}
        post 'uploadFile', {:title => 'arquivo 3', :upload => @mock_file, :discipline => 'MAT'}

        @files = LessonMaterial.find :all
        @files.size.should eql(4)
    end

    it 'should find the correct file when asked for its details' do
        get 'details', {:id => @material.id}
        assigns[:material].id.should eql(@material.id)
    end

    it 'should create a comment correctly' do
        post 'comment', {:id => @material.id, :name => 'tester', :email => 'tester', :text => 'blah'}

        @comments = Comments.find :all
        @comments.size.should eql(1)
    end

    it 'should not create a comment with no author name' do
        post 'comment', {:id => @material.id, :name => '', :email => 'tester', :text => 'blah'}

        @comments = Comments.find :all
        @comments.size.should eql(0)
    end

    it 'should not create a comment with no author email' do
      post 'comment', {:id => @material.id, :name => 'tester', :email => '', :text => 'blah'}

      @comments = Comments.find :all
      @comments.size.should eql(0)
    end

    it 'should not create a comment with no text' do
      post 'comment', {:id => @material.id, :name => 'tester', :email => 'tester', :text => ''}

      @comments = Comments.find :all
      @comments.size.should eql(0)
    end

    it 'should not create a comment linked to no material' do
      post 'comment', {:name => 'tester', :email => 'tester', :text => 'blah'}

      @comments = Comments.find :all
      @comments.size.should eql(0)
    end

    it 'should not create a comment linked to a material that does not exist' do
      post 'comment', {:id => -1, :name => 'tester', :email => 'tester', :text => 'blah'}

      @comments = Comments.find :all
      @comments.size.should eql(0)
    end

end
