require 'spec_helper'

describe UploadsController do
  render_views

  before(:each) do
    sign_in FactoryGirl.create(:user)
  end

  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Upload Log")
    end
  end

  describe "POST 'create'" do

    before :each do
      @attr = { :project_name => "Project",
                :log_file => fixture_file_upload('/files/simple_log.xml', 'text/xml') }
    end
    
    describe "success" do
    
      it "should render the projects page" do
        post :create, :upload => @attr
        response.should redirect_to(projects_path)
      end
      
      it "should create a new project" do
        lambda do
          post :create, :upload => @attr
        end.should change(Project, :count).by(1)
      end

      it "should create a new import worker and queue the import job" do
        lambda do
          post :create, :upload => @attr
        end.should change(ImportWorker.jobs, :size).by(1)
      end
    end
  end
end
