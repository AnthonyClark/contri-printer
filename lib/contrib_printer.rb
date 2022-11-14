require 'git'
require 'octokit'
require 'dotenv/load'
require 'securerandom'

class ContribPrinter
  def initialize
    config_git
    # @git_repo = Git.open('./../contri_user_dir/display')
    @git_repo = nil
    @repo_name = nil
    @tmp_path = nil
    @client = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])
  end

  def clear_display
    delete_repo(get_current_repo)
  end

  def create_repo
    # append a random hex string to the repo name
    @repo_name = "display_#{SecureRandom.hex(3)}"
    @client.create_repo('display')
  end

  def test_octokit
    # Create a new repo
    # create_repo

    # Clone repo to somewhere tmp
    @tmp_path = "/tmp/display_repo/#{SecureRandom.hex(3)}/"
    @repo_name = get_current_repo
    git_url = @client.repo(@repo_name)[:git_url]
    binding.pry
    Git.clone(git_url, @tmp_path)

    # Commit to repo

    # Push to repo
  end


  def print(data: nil)
    5.times { commit(nil) }
    push
  end

  private
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
    author = "contribgraph <117421137+contribgraph@users.noreply.github.com>"
    @git_repo.commit("Rand Commit: #{Time.now.utc}", allow_empty: true, author: author)
  end

  def push
    # @git_repo.push('origin', 'main')
    system("cd ./../contri_user_dir/display && GIT_SSH_COMMAND='ssh -i ~/.ssh/id_contrigraph_user_ed25519 -o IdentitiesOnly=yes' git push origin main --force")
  end

  def config_git
    Git.configure do |config|
      # If you need to use a custom SSH script
      config.git_ssh = './custom_ssh.sh'
    end
  end
end
