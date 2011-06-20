require 'spec_helper'

describe LessonMaterial do
    
    it 'should not accept an upload with no title' do
        lm = LessonMaterial.new
        lm.valid?().should == false
    end

end
