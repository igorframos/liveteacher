require 'spec_helper'

describe SearchController do

    before :each do
        LessonMaterial.create!({ :title => 'Search test', :file_name => '1.txt'}).save!
        LessonMaterial.create!({ :title => 'Testing search', :file_name => '2.txt'}).save!
        LessonMaterial.create!({ :title => 'Not a hit', :file_name => '3.txt'}).save!
        LessonMaterial.create!({ :title => 'Also not a hit', :file_name => '4.txt'}).save!
    end

    it 'should load the results page when searching by title' do
        post 'searchByTitle', {:query => 'test'}
        response.should be_success
    end

    it 'should load the results page when searching by discipline' do
        post 'searchByDiscipline', {:queryD => 'MAT'}
        response.should be_success
    end

    it 'should render the correct page when searching by title' do
        post 'searchByTitle', { :query => 'test' }
        response.should render_template('search_results')
    end

    it 'should render the correct page when searching by discipline' do
        post 'searchByDiscipline', { :queryD => 'MAT' }
        response.should render_template('search_results')
    end

end
