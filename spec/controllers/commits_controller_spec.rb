require 'spec_helper'

describe CommitsController do
  render_views
  
  describe "GET 'index'" do
    
    before(:each) do
      Factory(:commit, :revision => 1)
      30.times { Factory(:commit, :revision => Factory.next(:revisionId)) }
    end
    
    it "should be successful" do
      get :index
      response.should be_success
    end
    
    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "All commits")
    end
    
    it "should have an element for each commit" do
      get :index
      Commit.all.paginate(:page => 1).each do |commit|
        response.should have_selector("li", :content => commit.revision.to_s)
      end
    end
    
    it "should paginate commits" do
      get :index
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a",  :href => "/commits?page=2",
                                          :content => "2")
      response.should have_selector("a",  :href => "/commits?page=2",
                                          :content => "Next")
    end
  end
  
  describe "GET 'show'" do
    
    before(:each) do
      @commit = Factory(:commit)
    end
    
    it "should be successful" do
      get :show, :id => @commit.id
      response.should be_success
    end
    
    it "should find the right commit" do
      get :show, :id => @commit.id
      assigns(:commit).should == @commit
    end
    
    it "should have the right title" do
      get :show, :id => @commit.id
      response.should have_selector("title", :content => "Revision #{@commit.revision.to_s}")
    end
    
    it "should have the commit's revision number" do
      get :show, :id => @commit.id
      response.should have_selector("h1", :content => @commit.revision.to_s)
    end
    
    it "should have the user's commits" do
      commit = Factory(:commit)
      commit.changes.create!(:revision => commit.revision, 
                             :status => "A",
                             :project_root => "/target",
                             :filepath => "/target/src/main",
                             :fullpath => "/taget/src/main/file.txt")
                             
      get :show, :id => commit.id
      response.should have_selector("li", :content => commit.changes.first.fullpath)
    end
    
    it "should have the commit's user's name" do
      get :show, :id => @commit.id
      response.should have_selector("div", :content => @commit.user.name)
    end
    
    it "should have the commit's datetime" do
      get :show, :id => @commit.id
      response.should have_selector("div", :content => @commit.datetime)
    end
    
    it "should have the commit's message" do
      get :show, :id => @commit.id
      response.should have_selector("div", :content => @commit.message)
    end
  end
  
  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Create commit")
    end
  end
  
  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { :revision => "", :user_id => "", :datetime => "", :message => "" }
      end
      
      it "should have the right title" do
        post :create, :commit => @attr
        response.should have_selector("title", :content => "Create commit")
      end
      
      it "should render the 'new' page" do
        post :create, :commit => @attr
        response.should render_template("new")
      end
      
      it "should not create a commit" do
        lambda do 
          post :create, :commit => @attr
        end.should_not change(Commit, :count)
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :revision => 1, :user_id => 1, :datetime => "01/01/2011", :message => "message" }
      end
      
      it "should create a commit" do
        lambda do
          post :create, :commit => @attr
        end.should change(Commit, :count).by(1)
      end
      
      it "should redirect to the commit 'show' page" do
        post :create, :commit => @attr
        response.should redirect_to(commit_path(assigns(:commit)))
      end
    end
  end
  
  describe "GET 'edit'" do
  
    before(:each) do
      @commit = Factory(:commit)
    end
  
    it "should be successful" do
      get :edit, :id => @commit
      response.should be_success
    end
  
    it "should have the right title" do
      get :edit, :id => @commit
      response.should have_selector("title", :content => "Edit commit")
    end
  end
  
  describe "PUT 'update'" do
  
    before(:each) do
      @commit = Factory(:commit)
    end
  
    describe "failure" do
  
      before(:each) do
        @attr = { :revision => "", :user_id => "", :datetime => "", :message => "" }
      end
  
      it "should render the 'edit' page" do
        put :update, :id => @commit, :commit => @attr
        response.should render_template('edit')
      end
  
      it "should have the right title" do
        put :update, :id => @commit, :commit => @attr
        response.should have_selector("title", :content => "Edit commit")
      end
    end
  
    describe "success" do
  
      before(:each) do
        @attr = { :revision => 1, :user_id => 1, :datetime => "01/01/2011", :message => "message" }
      end
  
      it "should change the commits' attributes" do
        put :update, :id => @commit, :commit => @attr
        commit = assigns(:commit)
        @commit.reload
        @commit.revision.should == commit.revision
      end
    end   
  end
end