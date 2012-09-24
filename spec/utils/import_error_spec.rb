require 'spec_helper'

describe Errors::ImportError do

  it "should require a message and a project id" do
    project_id = 1
    lambda do
      raise Errors::ImportError.new(project_id), 'Test Message'
    end.should raise_error(Errors::ImportError, 'Test Message') { |error| error.instance_variable_get(:@project_id)[0].should == project_id }
  end
end