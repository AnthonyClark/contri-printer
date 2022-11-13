require 'git'
require 'dotenv'

class ContribPrinter

  def initialize
    config_git
  end

  def print(data)
    raise NotImplementedError
  end

  private
  def config_git
    config.ssh
  end
end
