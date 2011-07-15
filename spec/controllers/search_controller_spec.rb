require 'spec_helper'

describe SearchController do

    render_views

    before :each do
        LessonMaterial.create!({ :title => 'Search test', :file_name => '1.txt', :discipline => 'MAT'}).save!
        LessonMaterial.create!({ :title => 'Testing search', :file_name => '2.txt', :discipline => 'MAT'}).save!
        LessonMaterial.create!({ :title => 'Not a hit', :file_name => '3.txt', :discipline => 'POR'}).save!
        LessonMaterial.create!({ :title => 'Also not a hit', :file_name => '4.txt', :discipline => 'POR'}).save!
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

    it 'should find the correct files when searching by title' do
        post 'searchByTitle', { :query => 'test' }
        response.should contain('Search test')
        response.should contain('Testing search')
    end

    it 'should not find wrong files when searching by title' do
        post 'searchByTitle', { :query => 'test' }
        response.should_not contain('Not a hit')
        response.should_not contain('Also not a hit')
    end

    it 'should find the correct files when searching by title with more than one word' do
        post 'searchByTitle', { :query => 'test search' }
        response.should contain('Search test')
        response.should contain('Testing search')
    end

    it 'should not find wrong files when searching by title with more than one word' do
        post 'searchByTitle', { :query => 'test search' }
        response.should_not contain('Not a hit')
        response.should_not contain('Also not a hit')
    end

    it 'should find the correct files when searching by discipline' do
        post 'searchByDiscipline', { :queryD => 'MAT' }
        response.should contain('Search test')
        response.should contain('Testing search')
    end

    it 'should not find the wrong files when searching by discipline' do
        post 'searchByDiscipline', { :queryD => 'MAT' }
        response.should_not contain('Not a hit')
        response.should_not contain('Also not a hit')
    end

end
