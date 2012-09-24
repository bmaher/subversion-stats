require 'log_importer'

class ImportWorker
  include Sidekiq::Worker

  def perform(project_id, log)
    LogImporter.new(project_id, log).import
  end
end