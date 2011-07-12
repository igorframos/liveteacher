require 'spec_helper'

describe LessonMaterialController do

    before :each do
        @mock_file = mock(File)
        @mock_file.stub!(:original_filename).and_return('blah.txt', 'a.txt', 'b.txt')
        @mock_file.stub!(:read).and_return(65, 10, 20)
    end

    after :each do
        begin
          File.delete('public/data/blah.txt')
          File.delete('public/data/a.txt')
          File.delete('public/data/b.txt')
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
        File.open('public/data/blah.txt', "rb") { |f| f.read.should eql("65") }
    end

    it 'should find all the files uploaded' do
        post 'uploadFile', {:title => 'arquivo 1', :upload => @mock_file, :discipline => 'MAT'}
        post 'uploadFile', {:title => 'arquivo 2', :upload => @mock_file, :discipline => 'MAT'}
        post 'uploadFile', {:title => 'arquivo 3', :upload => @mock_file, :discipline => 'MAT'}

        @files = LessonMaterial.find :all
        @files.size.should eql(3)
    end

end
