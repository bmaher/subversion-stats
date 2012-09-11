require 'spec_helper'

describe CommittersController do
  render_views
  
  describe "GET 'index'" do
    
    before(:each) do
      FactoryGirl.create(:committer, :name => "committer1")
      30.times { FactoryGirl.create(:committer, :name => FactoryGirl.generate(:committerId)) }
    end

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "All committers")
    end
    
    it "should have an element for each committer" do
      get :index
      Committer.all.paginate(:page => 1).each do |committer|
        response.should have_selector("li", :content => committer.name)
      end
    end
    
    it "should paginate committers" do
      get :index
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a",  :href => "/committers?page=2",
                                          :content => "2")
      response.should have_selector("a",  :href => "/committers?page=2",
                                          :content => "Next")
    end
  end
    
   describe "GET 'show'" do
     
     before(:each) do
       @committer = FactoryGirl.create(:committer)
     end
     
     it "should be successful" do
       get :show, :id => @committer.id
       response.should be_success
     end
     
     it "should find the right committer" do
       get :show, :id => @committer.id
       assigns(:committer).should == @committer
     end
     
     it "should have the right title" do
       get :show, :id => @committer.id
       response.should have_selector("title", :content => @committer.name)
     end
     
     it "should have the committer's name" do
       get :show, :id => @committer.id
       response.should have_selector("h1", :content => @committer.name)
     end
     
     it "should have the committer's commits" do
       committer = FactoryGirl.create(:committer)
       committer.commits.create!(:revision => 1,
                            :datetime => "01/01/2011",
                            :message => "message")
                            
       get :show, :id => committer.id
       response.should have_selector("li", :content => committer.commits.first.revision.to_s)
     end
   end
   
   describe "GET 'new'" do
     
     it "should be successful" do
       get :new
       response.should be_success
     end
     
     it "should have the right title" do
       get :new
       response.should have_selector("title", :content => "Create committer")
     end
   end
   
   describe "POST 'create'" do
     
     describe "failure" do
       
       before(:each) do
         @attr = { :name => "" }
       end
       
       it "should have the right title" do
         post :create, :committer => @attr
         response.should have_selector("title", :content => "Create committer")
       end
       
       it "should render the 'new' page" do
         post :create, :committer => @attr
         response.should render_template("new")
       end
       
       it "should not create a committer" do
         lambda do 
           post :create, :committer => @attr
         end.should_not change(Committer, :count)
       end
     end
     
     describe "success" do
       
       before(:each) do
         @attr = { :name => "Test committer" }
       end
       
       it "should create a committer" do
         lambda do
           post :create, :committer => @attr
         end.should change(Committer, :count).by(1)
       end
       
       it "should redirect to the committer 'show' page" do
         post :create, :committer => @attr
         response.should redirect_to(committer_path(assigns(:committer)))
       end
     end
   end
   
   describe "GET 'edit'" do
   
     before(:each) do
       @committer = FactoryGirl.create(:committer)
     end
   
     it "should be successful" do
       get :edit, :id => @committer
       response.should be_success
     end
   
     it "should have the right title" do
       get :edit, :id => @committer
       response.should have_selector("title", :content => "Edit committer")
     end
   end
   
   describe "PUT 'update'" do
   
     before(:each) do
       @committer = FactoryGirl.create(:committer)
     end
   
     describe "failure" do
   
       before(:each) do
         @attr = { :name => "" }
       end
   
       it "should render the 'edit' page" do
         put :update, :id => @committer, :committer => @attr
         response.should render_template('edit')
       end
   
       it "should have the right title" do
         put :update, :id => @committer, :committer => @attr
         response.should have_selector("title", :content => "Edit committer")
       end
     end
   
     describe "success" do
   
       before(:each) do
         @attr = { :name => "New Name" }
       end
   
       it "should change the committer's attributes" do
         put :update, :id => @committer, :committer => @attr
         committer = assigns(:committer)
         @committer.reload
         @committer.name.should == committer.name
       end
     end   
   end
end