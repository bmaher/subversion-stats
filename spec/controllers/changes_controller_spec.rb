require 'spec_helper'

describe ChangesController do
  render_views
  
  describe "GET 'index'" do
    
    before(:each) do
      FactoryGirl.create(:change, :revision => 1)
      30.times { FactoryGirl.create(:change, :revision => FactoryGirl.generate(:revisionId)) }
    end
    
    it "should be successful" do
      get :index
      response.should be_success
    end
    
    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "All changes")
    end
    
    it "should have an element for each change" do
      get :index
      Change.all.paginate(:page => 1).each do |change|
        response.should have_selector("li", :content => change.revision.to_s)
      end
    end
    
    it "should paginate changes" do
      get :index
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a",  :href => "/changes?page=2",
                                          :content => "2")
      response.should have_selector("a",  :href => "/changes?page=2",
                                          :content => "Next")
    end
  end
  
  describe "GET 'show'" do
    
    before(:each) do
      @change = FactoryGirl.create(:change)
    end
    
    it "should be successful" do
      get :show, :id => @change.id
      response.should be_success
    end
    
    it "should find the right change" do
      get :show, :id => @change.id
      assigns(:change).should == @change
    end
    
    it "should have the right title" do
      get :show, :id => @change.id
      response.should have_selector("title", :content => "Change #{@change.fullpath}")
    end
    
    it "should have the change's revision number" do
      get :show, :id => @change.id
      response.should have_selector("h1", :content => @change.revision.to_s)
    end
    
    it "should have the change's status" do
      get :show, :id => @change.id
      response.should have_selector("p", :content => @change.status)
    end
    
    it "should have the change's project root" do
      get :show, :id => @change.id
      response.should have_selector("p", :content => @change.project_root)
    end
    
    it "should have the change's filepath" do
      get :show, :id => @change.id
      response.should have_selector("p", :content => @change.filepath)
    end
    
    it "should have the change's fullpath" do
      get :show, :id => @change.id
      response.should have_selector("p", :content => @change.fullpath)
    end
  end
  
  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Create change")
    end
  end
  
  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { :revision => "",
                  :status => "",
                  :project_root => "",
                  :filepath => "",
                  :fullpath => "",
                  :commit_id => "" }
      end
      
      it "should have the right title" do
        post :create, :change => @attr
        response.should have_selector("title", :content => "Create change")
      end
      
      it "should render the 'new' page" do
        post :create, :change => @attr
        response.should render_template("new")
      end
      
      it "should not create a change" do
        lambda do 
          post :create, :change => @attr
        end.should_not change(Change, :count)
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :revision => 1,
                  :status => "A",
                  :project_root => "/target",
                  :filepath => "/target/src/main",
                  :fullpath => "/target/src/main/file.txt",
                  :commit_id => 1 }
      end
      
      it "should create a change" do
        lambda do
          post :create, :change => @attr
        end.should change(Change, :count).by(1)
      end
      
      it "should redirect to the change 'show' page" do
        post :create, :change => @attr
        response.should redirect_to(change_path(assigns(:change)))
      end
    end
  end
  
  describe "GET 'edit'" do
  
    before(:each) do
      @change = FactoryGirl.create(:change)
    end
  
    it "should be successful" do
      get :edit, :id => @change
      response.should be_success
    end
  
    it "should have the right title" do
      get :edit, :id => @change
      response.should have_selector("title", :content => "Edit change")
    end
  end
  
  describe "PUT 'update'" do
  
    before(:each) do
      @change = FactoryGirl.create(:change)
    end
  
    describe "failure" do
  
      before(:each) do
        @attr = { :revision => "",
                  :status => "",
                  :project_root => "",
                  :filepath => "",
                  :fullpath => "",
                  :commit_id => "" }
      end
  
      it "should render the 'edit' page" do
        put :update, :id => @change, :change => @attr
        response.should render_template('edit')
      end
  
      it "should have the right title" do
        put :update, :id => @change, :change => @attr
        response.should have_selector("title", :content => "Edit change")
      end
    end
  
    describe "success" do
  
      before(:each) do
        @attr = { :revision => 1,
                  :status => "A",
                  :project_root => "/target",
                  :filepath => "/target/src/main",
                  :fullpath => "/target/src/main/file.txt",
                  :commit_id => 1 }
      end
  
      it "should change the change's attributes" do
        put :update, :id => @change, :change => @attr
        change = assigns(:change)
        @change.reload
        @change.revision.should == change.revision
      end
    end   
  end
end