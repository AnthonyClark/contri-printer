require_relative 'git_service.rb'

class ContribPrinter
  def initialize()
    @git_client = GitService.new
  end

  def clear_display
    @git_client.clear_contributions
  end

  def print(data)
    @git_client.push_data_to_display(data)
  end
end
