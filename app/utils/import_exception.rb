class ImportException < Exception

  attr :message, true
  attr :project_id, true

  def initialize(message, *project_id)
    self.message = message
    self.project_id = project_id
  end
end