require 'spec_helper'

describe ImportWorker do
  
  it "should create a new worker" do
    lambda do
      ImportWorker.perform_async(1, "test")
    end.should change(ImportWorker.jobs, :size).by(1)
  end
  
  it "should handle multiple workers asynchronously" do
    lambda do
      ImportWorker.perform_async(1, "test")
      ImportWorker.perform_async(2, "test")
    end.should change(ImportWorker.jobs, :size).by(2)
  end
end
