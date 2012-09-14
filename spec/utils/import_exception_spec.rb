require 'spec_helper'

describe ImportException do

  it "should require a message and a project id" do
    ImportException.new("Test Message", 1)
  end
end