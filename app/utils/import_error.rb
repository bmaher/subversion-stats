class ImportError < StandardError
  attr_accessor :project_id
  def initialize(*project_id)
    self.project_id = project_id
  end
end