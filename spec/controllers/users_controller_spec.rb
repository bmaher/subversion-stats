require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'index'" do
    
    before(:each) do
      Factory(:user, :username => "user1")
      30.times { Factory(:user, :username => Factory.next(:userId)) }
    end

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "All users")
    end
    
    it "should have an element for each user" do
      get :index
      User.all.paginate(:page => 1).each do |user|
        response.should have_selector("li", :content => user.username)
      end
    end
    
    it "should paginate users" do
      get :index
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a",  :href => "/users?page=2",
                                          :content => "2")
      response.should have_selector("a",  :href => "/users?page=2",
                                          :content => "Next")
    end
  end
    
   describe "GET 'show'" do
     
     before(:each) do
       @user = Factory(:user)
     end
     
     it "should be successful" do
       get :show, :id => @user.id
       response.should be_success
     end
     
     it "should find the right user" do
       get :show, :id => @user.id
       assigns(:user).should == @user
     end
     
     it "should have the right title" do
       get :show, :id => @user.id
       response.should have_selector("title", :content => @user.username)
     end
     
     it "should have the user's name" do
       get :show, :id => @user.id
       response.should have_selector("h1", :content => @user.username)
     end
   end
   
   describe "GET 'new'" do
     
     it "should be successful" do
       get :new
       response.should be_success
     end
     
     it "should have the right title" do
       get :new
       response.should have_selector("title", :content => "Create user")
     end
   end
   
   describe "POST 'create'" do
     
     describe "failure" do
       
       before(:each) do
         @attr = { :username => "" }
       end
       
       it "should have the right title" do
         post :create, :user => @attr
         response.should have_selector("title", :content => "Create user")
       end
       
       it "should render the 'new' page" do
         post :create, :user => @attr
         response.should render_template("new")
       end
       
       it "should not create a user" do
         lambda do 
           post :create, :user => @attr
         end.should_not change(User, :count)
       end
     end
     
     describe "success" do
       
       before(:each) do
         @attr = { :username => "Test User" }
       end
       
       it "should create a user" do
         lambda do
           post :create, :user => @attr
         end.should change(User, :count).by(1)
       end
       
       it "should redirect to the user 'show' page" do
         post :create, :user => @attr
         response.should redirect_to(user_path(assigns(:user)))
       end
     end
   end
   
   describe "GET 'edit'" do
   
     before(:each) do
       @user = Factory(:user)
     end
   
     it "should be successful" do
       get :edit, :id => @user
       response.should be_success
     end
   
     it "should have the right title" do
       get :edit, :id => @user
       response.should have_selector("title", :content => "Edit user")
     end
   end
   
   describe "PUT 'update'" do
   
     before(:each) do
       @user = Factory(:user)
     end
   
     describe "failure" do
   
       before(:each) do
         @attr = { :username => "" }
       end
   
       it "should render the 'edit' page" do
         put :update, :id => @user, :user => @attr
         response.should render_template('edit')
       end
   
       it "should have the right title" do
         put :update, :id => @user, :user => @attr
         response.should have_selector("title", :content => "Edit user")
       end
     end
   
     describe "success" do
   
       before(:each) do
         @attr = { :name => "New Name" }
       end
   
       it "should change the user's attributes" do
         put :update, :id => @user, :user => @attr
         user = assigns(:user)
         @user.reload
         @user.username.should == user.username
       end
     end   
   end
end