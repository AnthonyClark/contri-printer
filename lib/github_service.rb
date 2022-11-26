require 'dotenv/load'
require 'octokit'
require 'git'

# TODO: Rename to GitService or something more appropriate
class GithubService
  SECONDS_PER_DAY = 60 * 60 * 24
  HIGH = 10
  LOW = 1

  def initialize
    # TODO: Fix git gem use of custom ssh script
    # GithubService.config_git
    @github = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    @current_gh_repo = nil
  end

  def get_current_data
    # Get commits for current path or something.
    get_current_repo

    # Clone current repo somewhere tmp
    FileUtils.mkdir_p(local_repo_path)
    git = Git.init(local_repo_path)
    git.add_remote('origin', @current_gh_repo[:ssh_url]) unless git.remotes.any?
    reset_local_to_remote_repo


    # Get data from commits
    commit_counts = git.log(10_000).map do |commit|
      days_since(commit.author.date)
    end.tally

    binding.pry

    first_day_offset = commit_counts.keys.max
    data = Array.new(7) { Array.new(53, 0) }

    (0..52).each do |week|
      (0..6).each do |day|
        index = (week * 7) + day

        count = commit_counts[first_day_offset - index] || 0
        data[day][week] = (count >= GithubService::HIGH) ? 1 : 0  
      end
    end

    data
  end

  # Method that gets number of days between two Time objects
  def days_since(t)
    ((Time.now - t) / (GithubService::SECONDS_PER_DAY)).floor
  end

  private

  def reset_local_to_remote_repo
    run_git_command("fetch origin")
    run_git_command("reset --hard origin/main")
  end

  def run_git_command(command)
    system("cd #{local_repo_path} && GIT_SSH_COMMAND='ssh -i #{ENV['SSH_KEY_PATH']} -o IdentitiesOnly=yes' git #{command}")
  end 

  def get_current_repo
    @current_gh_repo = @github.repos.find {|r| r[:name].start_with?('display') }
  end

  def local_repo_path
    "/tmp/display_repo/#{@current_gh_repo[:name]}/"
  end

  # def self.config_git
  #   Git.configure do |config|
  #     # config.git_ssh = './custom_ssh.sh'
  #     config.git_ssh = './custom_ssh.sh'
  #   end
  # end
end
