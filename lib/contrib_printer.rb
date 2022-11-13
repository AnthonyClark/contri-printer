require 'git'
# require 'dotenv'

class ContribPrinter

  def initialize
    config_git
    # TODO: Make this dynamic and temporary
    @git_repo = g = Git.open('./../contri_user_dir/display')
  end

  def print(data: nil)
    5.times { commit(nil) }
    push
  end

  def reset_repo
    # Reset repo to first commit
    # TODO: Make this dynamic
    @git_repo.reset_hard('29fa160cfffb666e6f238fccd19b52010e2264d9')
    push
  end

  private
  def commit(date)
    # TODO: Custom date for commit
    # TODO: ENV or config the author variable
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
