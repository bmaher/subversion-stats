class DeleteProjectWorker
  include Sidekiq::Worker

  def perform(project)
    Project.find(project).destroy
  end
end