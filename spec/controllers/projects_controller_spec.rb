require 'spec_helper'

describe ProjectsController do
  render_views
  
  describe "GET 'index'" do
    
    before(:each) do
      @project = FactoryGirl.create(:project, :user => FactoryGirl.create(:user, :roles => %w[project_owner]))
      sign_in @project.user
      30.times { FactoryGirl.create(:project, :name => FactoryGirl.generate(:project_id)) }
    end

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "All projects")
    end
    
    it "should have an element for each project" do
      get :index
      Project.all.paginate(:page => 1).each do |project|
        response.should have_selector("li", :content => project.name)
      end
    end
    
    it "should paginate projects" do
      get :index
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a",  :href => "/projects?page=2",
                                          :content => "2")
      response.should have_selector("a",  :href => "/projects?page=2",
                                          :content => "Next")
    end
  end
  
  describe "GET 'show'" do
    
    before(:each) do
      @project = FactoryGirl.create(:project, :user => FactoryGirl.create(:user, :roles => %w[project_owner]))
      sign_in @project.user
    end
    
    it "should be successful" do
      get :show, :id => @project.id
      response.should be_success
    end
    
    it "should find the right project" do
      get :show, :id => @project.id
      assigns(:project).should == @project
    end
    
    it "should have the right title" do
      get :show, :id => @project.id
      response.should have_selector("title", :content => @project.name)
    end
    
    it "should have the project's name" do
      get :show, :id => @project.id
      response.should have_selector("h1", :content => @project.name)
    end
    
    it "should have the project's committers" do
      @project.committers.create!(:name => "test committer")
                           
      get :show, :id => @project.id
      response.should have_selector("li", :content => @project.committers.find_first.name)
    end
  end
  
  describe "GET 'new'" do

    before(:each) do
      sign_in FactoryGirl.create(:user)
    end

    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Create project")
    end
  end
  
  describe "POST 'create'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "failure" do
      
      before(:each) do
        @attr = { :name => "", :user_id => "" }
      end
      
      it "should have the right title" do
        post :create, :project => @attr
        response.should have_selector("title", :content => "Create project")
      end
      
      it "should render the 'new' page" do
        post :create, :project => @attr
        response.should render_template("new")
      end
      
      it "should not create a project" do
        lambda do 
          post :create, :project => @attr
        end.should_not change(Project, :count)
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :name => "Test Project", :user_id => @user.id }
      end
      
      it "should create a project" do
        lambda do
          post :create, :project => @attr
        end.should change(Project, :count).by(1)
      end
      
      it "should redirect to the project 'show' page" do
        post :create, :project => @attr
        response.should redirect_to(project_path(assigns(:project)))
      end

      it "should assign the project owner role to the user" do
        post :create, :project => @attr
        User.find(@user.id).has_role?(:project_owner).should == true
      end

      it "should create a new import worker and queue the import job" do
        lambda do
          post :create, :project => @attr.merge(:log_file => fixture_file_upload('/files/simple_log.xml', 'text/xml'))
        end.should change(ImportWorker.jobs, :size).by(1)
      end
    end
  end
  
  describe "GET 'edit'" do
  
    before(:each) do
      @project = FactoryGirl.create(:project, :user => FactoryGirl.create(:user, :roles => %w[project_owner]))
      sign_in @project.user
    end
  
    it "should be successful" do
      get :edit, :id => @project
      response.should be_success
    end
  
    it "should have the right title" do
      get :edit, :id => @project
      response.should have_selector("title", :content => "Edit project")
    end
  end
  
  describe "PUT 'update'" do
  
    before(:each) do
      @project = FactoryGirl.create(:project, :user => FactoryGirl.create(:user, :roles => %w[project_owner]))
      sign_in @project.user
    end
  
    describe "failure" do
  
      before(:each) do
        @attr = { :name => "" }
      end
  
      it "should render the 'edit' page" do
        put :update, :id => @project, :project => @attr
        response.should render_template('edit')
      end
  
      it "should have the right title" do
        put :update, :id => @project, :project => @attr
        response.should have_selector("title", :content => "Edit project")
      end
    end
  
    describe "success" do
  
      before(:each) do
        @attr = { :name => "Test Project" }
      end
  
      it "should change the project's attributes" do
        put :update, :id => @project, :project => @attr
        project = assigns(:project)
        @project.reload
        @project.name.should == project.name
      end
    end   
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @project = FactoryGirl.create(:project, :user => FactoryGirl.create(:user, :roles => %w[project_owner]))
      sign_in @project.user
    end

    it "should destroy the project" do
      lambda do
        delete :destroy, :id => @project
        response.should redirect_to(projects_path)
      end.should change(Project, :count).by(-1)
    end
  end
end
