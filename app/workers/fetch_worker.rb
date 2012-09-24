class FetchWorker
  include Sidekiq::Worker

  def perform(project_id, repository_details)
    ImportWorker.perform_async(project_id, LogFetcher.new(repository_details).fetch)
  end
end
