require 'spec_helper'

describe LessonMaterialController do

    before :each do
        @mock_file = mock(File)
        @mock_file.stub!(:original_filename).and_return('blah.txt')
        @mock_file.stub!(:read).and_return(65)
    end

    after :each do
        begin
          File.delete('public/data/blah.txt')
        rescue
        end
    end    

    it 'should flash an error message when there is no file to upload' do
        post 'uploadFile', {:title => 'Teste'}
        flash[:notice].should eql('Choose a file to upload')
    end

    it 'should flash an error message when there is no title to the upload' do
        post 'uploadFile', {:title => '', :upload => @mock_file}
        flash[:notice].should eql('Choose a title to your upload')
    end

    it 'should save a file correctly and display a message' do
        post 'uploadFile', {:title => 'Teste', :upload => @mock_file}
        flash[:notice].should eql('Lesson added')
        File.open('public/data/blah.txt', "rb") { |f| f.read.should eql("65") }
    end

    it 'should find all the files uploaded' do
        mock_file = mock(File)
        mock_file.stub!(:original_filename).and_return('a.txt', 'b.txt', 'c.txt')
        mock_file.stub!(:read).and_return(10, 20, 30)

        post 'uploadFile', {:title => 'arquivo 1', :upload => mock_file}
        post 'uploadFile', {:title => 'arquivo 2', :upload => mock_file}
        post 'uploadFile', {:title => 'arquivo 3', :upload => mock_file}

        @files = LessonMaterial.find :all
        @files.size.should eql(3)

        File.delete('public/data/a.txt')
        File.delete('public/data/b.txt')
        File.delete('public/data/c.txt')
    end

end
