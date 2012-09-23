class LogOverHttpWorker
  include Sidekiq::Worker

  def perform(project, repository_details)
    log = LogOverHttp.new(repository_details).fetch
    importer = LogImporter.new(project, log)
    importer.import
  end
end
