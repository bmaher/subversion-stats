require 'spec_helper'

describe LogOverHttp, :broken_in_travis => true do

  before(:each) do
    @attr = { :repository_url => 'http://v8.googlecode.com/svn/trunk/',
              :revision_from  => '1' }
  end

  it "should require repository details" do
    LogOverHttp.new(@attr)
  end

  describe "success" do

    it "should retrieve a log over http" do
      LogOverHttp.new(@attr).fetch.should include('<?xml version="1.0"?>')
    end
  end

  describe "failure" do

    it "should error if svn doesn't exit with 0" do
      lambda do
        LogOverHttp.new(@attr.merge(:repository_url => 'localhost')).fetch
      end.should raise_error(SvnError)
    end
  end

  describe "username" do

    it "should return a username parameter given a username" do
      http_log = LogOverHttp.new(@attr.merge(:username => "user"))
      http_log.username.should eq '--username user'
    end

    it "should return blank given no username" do
      http_log = LogOverHttp.new(@attr)
      http_log.username.should be_blank
    end
  end

  describe "password" do

    it "should return a password parameter given a password" do
      http_log = LogOverHttp.new(@attr.merge(:password => "password"))
      http_log.password.should eq '--password password'
    end

    it "should return blank given no password" do
      http_log = LogOverHttp.new(@attr)
      http_log.password.should be_blank
    end
  end

  describe "revisions" do

    it "should return a range if given a from and to" do
      http_log = LogOverHttp.new(@attr.merge(:revision_to => '2'))
      http_log.revisions.should eq '-r1:2'
    end

    it "should return a single revision given a from but no to" do
      http_log = LogOverHttp.new(@attr)
      http_log.revisions.should eq '-r1'
    end

    it "should return a range if given a from of HEAD but no to" do
      http_log = LogOverHttp.new(@attr.merge(:revision_from => 'HEAD'))
      http_log.revisions.should eq '-rHEAD:0'
    end

    it "should return blank if given no from or to" do
      http_log = LogOverHttp.new(@attr.merge(:revision_from => ''))
      http_log.revisions.should be_blank
    end
  end
end
