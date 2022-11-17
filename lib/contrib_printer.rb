require 'git'
require 'octokit'
require 'dotenv/load'
require 'securerandom'
require 'time'

GithubRepo = Struct.new(:full_name, :ssh_url, keyword_init: true)

class ContribPrinter
  def initialize
    config_git
    @github_repo = nil
    @git_repo = nil
    @local_path = nil
    @client = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])
  end

  def clear_display
    delete_repo(get_current_repo)
  end

  def create_repo
    repo_name = "display_#{SecureRandom.hex(3)}"
    github_repo = @client.create_repo(repo_name)
    @github_repo = GithubRepo.new(full_name: github_repo[:full_name], ssh_url: github_repo[:ssh_url])
    log("Created repo: #{@github_repo.full_name}")
  end

  def test_octokit
    # Create a new local repo
    tmp_path = "/tmp/display_repo/#{Time.now.utc.to_i}/"
    @local_path = tmp_path
    FileUtils.mkdir_p(tmp_path)
    log("Created tmp path: #{tmp_path}")

    # Init empty git repo at tmp path
    @git_repo = Git.init(tmp_path)

    # Commit to repo
    print

    # Create new repo on github
    create_repo

    # Add github repo as remote to local repo
    @git_repo.add_remote('origin', @github_repo.ssh_url)

    # Push to repo
    push
  end

  def print(data: nil)
    10.times { commit(nil) }
  end

  def clone_repo
    # Clone the new repo into some tmp place so be able to commit to it
  end

  def delete_repo(repo_name)
    @client.delete_repo(repo_name)
  end

  def get_current_repo
    @client.repos.find {|r| r[:name].start_with?('display') }[:full_name]
  end

  def commit(date)
    # TODO: Custom date for commit
    # TODO: ENV or config the author variable
    # TODO: Prevent git including pairing info with global git user conf

    # For now, random date in the past 365 days
    date = (Time.now.utc - (rand(365) * 24 * 60 * 60)).iso8601

    author = "contribgraph <117421137+contribgraph@users.noreply.github.com>"
    @git_repo.commit(
      "Rand Commit: #{Time.now.utc}",
      allow_empty: true,
      author: author,
      date: date
    )
  end

  def push
    # @git_repo.push('origin', 'main')
    system("cd #{@local_path} && GIT_SSH_COMMAND='ssh -i ~/.ssh/id_contrigraph_user_ed25519 -o IdentitiesOnly=yes' git push origin main --force")
  end

  def log(message)
    puts "#{Time.now}: #{message}"
  end

  def config_git
    Git.configure do |config|
      # If you need to use a custom SSH script
      config.git_ssh = './custom_ssh.sh'
    end
  end
end
