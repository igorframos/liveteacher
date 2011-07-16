require 'spec_helper'

describe LessonMaterialController do

    render_views

    before :each do
        @mock_file = mock(File)
        @mock_file.stub!(:original_filename).and_return('blah.txt', 'a.txt', 'b.txt')
        @mock_file.stub!(:read).and_return(65, 10, 20)
        @material = LessonMaterial.create!(:title => 'arquivo 4', :file_name => '1.txt', :discipline => 'MAT', :comment => 'peculiar')
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
        response.should contain('Choose a file to upload')
    end

    it 'should flash an error message when there is no title to the upload' do
        post 'uploadFile', {:title => '', :upload => @mock_file, :discipline => 'MAT'}
        response.should contain('Choose a title to your upload')
    end

    it 'should flash an error message when there is no discipline to the upload' do
        post 'uploadFile', {:title => 'Teste', :upload => @mock_file}
        response.should contain('Choose a discipline to your upload')
    end

    it 'should flash an error message when discipline is EMPTY' do
        post 'uploadFile', {:title => 'Teste', :upload => @mock_file, :discipline => 'EMPTY'}
        response.should contain('Choose a discipline to your upload')
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
        response.should contain('Lesson added')
        File.open('public/data/id-1-blah.txt', "rb") { |f| f.read.should eql("65") }
    end

    it 'should display the upload in the upload list after an upload is made' do
        post 'uploadFile', {:title => 'arquivo 1', :upload => @mock_file, :discipline => 'MAT'}
        response.should contain('arquivo 1')
    end

    it 'should find all the files uploaded' do
        post 'uploadFile', {:title => 'arquivo 1', :upload => @mock_file, :discipline => 'MAT'}
        post 'uploadFile', {:title => 'arquivo 2', :upload => @mock_file, :discipline => 'MAT'}
        post 'uploadFile', {:title => 'arquivo 3', :upload => @mock_file, :discipline => 'MAT'}

        @files = LessonMaterial.find :all
        @files.size.should eql(4)
    end

    it 'should show the all the files correctly' do
        post 'uploadFile', {:title => 'arquivo 1', :upload => @mock_file, :discipline => 'MAT'}
        post 'uploadFile', {:title => 'arquivo 2', :upload => @mock_file, :discipline => 'MAT'}
        post 'uploadFile', {:title => 'arquivo 3', :upload => @mock_file, :discipline => 'MAT'}

        response.should contain('arquivo 1')
        response.should contain('arquivo 2')
        response.should contain('arquivo 3')
    end
    
    it 'should save the authors comment correctly' do        
        post 'uploadFile', {:title => 'arquivo 1', :upload => @mock_file, :discipline => 'MAT', :comment => 'authors comment'}
        
        @file = LessonMaterial.find_by_comment('authors comment')
        @file.title.should eql('arquivo 1')
        #@file.instance_of ? LessonMaterial
    end
    
    it 'should display the authors comment correctly' do
        get 'details', {:id => @material.id}
        response.should contain('peculiar')
    end

    it 'should find the correct file when asked for its details' do
        get 'details', {:id => @material.id}
        assigns[:material].id.should eql(@material.id)
    end

    it 'should create a comment correctly' do
        post 'comment', {:id => @material.id, :name => 'tester', :email => 'tester@test.com', :text => 'blah'}

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
      post 'comment', {:id => 100000, :name => 'tester', :email => 'tester', :text => 'blah'}

      @comments = Comments.find :all
      @comments.size.should eql(0)
    end

    it 'should show the comment posted' do
      post 'comment', {:id => @material.id, :name => 'Author', :email => 'tester@liveteacher.com', :text => 'Nice'}

      response.should contain('Author')
      response.should contain('Nice')
    end

    it 'should not show a person\'s email' do
      post 'comment', {:id => @material.id, :name => 'Author', :email => 'tester@liveteacher.com', :text => 'Nice'}

      response.should_not contain('tester@liveteacher.com')
    end

    it 'should display an error message if the email address on a comment has no @' do
      post 'comment', {:id => @material.id, :name => 'Author', :email => 'liveteacher.com', :text => 'Nice'}

      response.should contain('Please, enter a valid email address')
    end

    it 'should display an error message if the email does not have a dot after the @' do
      post 'comment', {:id => @material.id, :name => 'Author', :email => 'teacher@liveteacher', :text => 'Nice'}

      response.should contain('Please, enter a valid email address')
    end

    it 'should accept correctly an email with a dot before the @ and more than one dot after the @' do
      post 'comment', {:id => @material.id, :name => 'Author', :email => 'l.i.v.e@teacher.com.br', :text => 'Nice'}

      @comments = Comments.find :all
      @comments.size.should eql(1)
    end

    it 'should display an error message if there is no comment author' do
      post 'comment', {:id => @material.id, :name => '', :email => 'tester@liveteacher.com', :text => 'Nice'}

      response.should contain('Please, enter the author name to comment')
    end

    it 'should display an error message if there is no email address on a comment' do
      post 'comment', {:id => @material.id, :name => 'Author', :email => '', :text => 'Nice'}

      response.should contain('Please, enter a valid email address')
    end

    it 'should display an error message if there is no text on a comment' do
      post 'comment', {:id => @material.id, :name => 'Author', :email => 'tester@liveteacher.com', :text => ''}

      response.should contain('There must be some text on your comment')
    end

    it "should redirect to file url" do
      material = LessonMaterial.save @mock_file, "Titulo", "MAT"

      get 'download', {:id => material.id}

      response.should redirect_to('/public/data/'+material.file_name)
    end

    it "should increase download_count to the selected material" do
      material = LessonMaterial.save @mock_file, "Titulo", "MAT"
      get 'download', {:id => material.id}
      
      LessonMaterial.find_by_id(material.id).downloads_count.should == 1
    end

    it 'should start the downloads count with 0' do
        post 'uploadFile', { :title => 'Teste', :upload => @mock_file, :discipline => 'MAT' }
        materials = LessonMaterial.find :all
        materials.last.downloads_count.should == 0
    end

end
