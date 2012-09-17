class ImportError < StandardError
  def initialize(*project_id)
    @project_id = project_id
  end
end