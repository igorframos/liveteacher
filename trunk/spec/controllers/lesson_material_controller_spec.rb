require 'spec_helper'

describe LessonMaterialController do

    it 'should flash an error message when there is no file to upload' do
        post 'uploadFile', {:title => 'Teste'}
        flash[:notice].should eql('Choose a file to upload')
    end

    it 'should flash an error message when there is no title to the upload' do
        mock_file = mock(File)
        post 'uploadFile', {:title => '', :upload => mock_file}
        flash[:notice].should eql('Choose a title to your upload')
    end

    it 'should save a file correctly' do
        mock_file = mock(File)
        mock_file.stub!(:original_filename).and_return('blah.txt')
        mock_file.stub!(:read).and_return(65)
        post 'uploadFile', {:title => 'Teste', :upload =>mock_file}
        flash[:notice].should eql('Lesson added')
        File.open('public/data/blah.txt', "rb") { |f| f.read.should eql("65") }
        File.delete('public/data/blah.txt')
    end

end
