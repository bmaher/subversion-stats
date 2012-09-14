require 'log_importer'

class ImportWorker
  include Sidekiq::Worker

  def perform(project, log)
    importer = LogImporter.new(project, log)
    importer.import
  end
end