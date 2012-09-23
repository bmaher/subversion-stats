require 'spec_helper'

describe LogOverHttpWorker do

  it "should create a new worker" do
    lambda do
      LogOverHttpWorker.perform_async(1)
    end.should change(LogOverHttpWorker.jobs, :size).by(1)
  end

  it "should handle multiple workers asynchronously" do
    lambda do
      LogOverHttpWorker.perform_async(1)
      LogOverHttpWorker.perform_async(2)
    end.should change(LogOverHttpWorker.jobs, :size).by(2)
  end
end
