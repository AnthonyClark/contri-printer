require 'git'
require 'octokit'
require 'dotenv/load'
require 'securerandom'
require 'time'
require 'Date'

GithubRepo = Struct.new(:full_name, :ssh_url, keyword_init: true)

class ContribPrinter
  def initialize(shade: false)
    config_git
    @github_repo = nil
    @git_repo = nil
    @local_path = nil
    @client = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])
    @on, @off = 1, 0
    if shade
      @on = 10
      @off = 1
    end
  end

  def clear_display
    delete_repo(get_current_repo)
  end

  def demo
    game = GameOfLife.new(7, 53)
    game.add_glider(1, 1)
    print(game.data)
  end

  # TODO: Enforce rows and cols to be 53 and 7 respectively for github graph
  def print(data)
    init_local_repo

    data_to_commits(data)

    push_to_display
  end

  def data_to_commits(data)
    # Where does the last column start?
    current_weekday_index = Date.today.wday

    # Days between today and start of graph
    offset = (52 * 7) +  current_weekday_index

    # Go through each commit, column by column not row by row
    (0..52).each do |week|
      (0..6).each do |day|
        index = (week * 7) + day
        date = date_days_ago(offset - index)
        commit_count = data[day][week] == 1 ? @on : @off
        commit_count.times { commit(date: date) }
      end
    end
  end

  private

  def date_days_ago(days)
    (Time.now.utc - (days * 24 * 60 * 60)).iso8601
  end

  # TODO: Extract to some Git repo managing class
  def push_to_display
    create_remote_repo
    @git_repo.add_remote('origin', @github_repo.ssh_url)
    push
  end

  # TODO: Extract to some Git repo managing class
  def init_local_repo
    @local_path = "/tmp/display_repo/#{Time.now.utc.to_i}/"
    FileUtils.mkdir_p(@local_path)
    log("Created tmp path: #{@local_path}")
    @git_repo = Git.init(@local_path)
  end

  def demo_print
    10.times { commit(nil) }
  end

  def delete_repo(repo_name)
    @client.delete_repo(repo_name)
  end

  def get_current_repo
    @client.repos.find {|r| r[:name].start_with?('display') }[:full_name]
  end

  # TODO: Extract to some Git repo managing class
  def create_remote_repo
    repo_name = "display_#{SecureRandom.hex(3)}"
    github_repo = @client.create_repo(repo_name)
    @github_repo = GithubRepo.new(full_name: github_repo[:full_name], ssh_url: github_repo[:ssh_url])
    log("Created repo: #{@github_repo.full_name}")
  end

  def commit(date: date_days_ago(rand(365)))
    # TODO: Custom date for commit
    # TODO: ENV or config the author variable
    # TODO: Prevent git including pairing info with global git user conf

    author = "contribgraph <117421137+contribgraph@users.noreply.github.com>"
    @git_repo.commit(
      "Rand Commit: #{Time.now.utc}",
      allow_empty: true,
      author: author,
      date: date
    )
  end

  def push
    # TODO: Try fix the push api instead of using shell directly here.
    # @git_repo.push('origin', 'main')
    system("cd #{@local_path} && GIT_SSH_COMMAND='ssh -i ~/.ssh/id_contrigraph_user_ed25519 -o IdentitiesOnly=yes' git push origin main --force")
  end

  def log(message)
    puts "#{Time.now}: #{message}"
  end

  def config_git
    Git.configure do |config|
      config.git_ssh = './custom_ssh.sh'
    end
  end
end
