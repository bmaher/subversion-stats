require 'spec_helper'

describe FetchWorker do

  it "should create a new worker" do
    lambda do
      FetchWorker.perform_async(1)
    end.should change(FetchWorker.jobs, :size).by(1)
  end

  it "should handle multiple workers asynchronously" do
    lambda do
      FetchWorker.perform_async(1)
      FetchWorker.perform_async(2)
    end.should change(FetchWorker.jobs, :size).by(2)
  end
end
