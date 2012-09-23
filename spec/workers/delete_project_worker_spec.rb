require 'spec_helper'

describe DeleteProjectWorker do

  it "should create a new worker" do
    lambda do
      DeleteProjectWorker.perform_async(1)
    end.should change(DeleteProjectWorker.jobs, :size).by(1)
  end

  it "should handle multiple workers asynchronously" do
    lambda do
      DeleteProjectWorker.perform_async(1)
      DeleteProjectWorker.perform_async(2)
    end.should change(DeleteProjectWorker.jobs, :size).by(2)
  end
end
