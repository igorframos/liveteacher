require 'spec_helper'

describe LessonMaterialController do

    it 'should do nothing without a file to upload' do
        post 'uploadFile', {:title => "Teste"}
        flash[:notice].should == "Escolha um arquivo"
    end

end
