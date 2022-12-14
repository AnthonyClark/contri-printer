class GitRepo
  attr_accessor :path, :mode
  READ_MODE = :read
  WRITE_MODE = :write

  def initialize(path, mode = GitRepo::READ_MODE)
    @path = path
    @mode = nil
    @author = {
      name: ENV['GIT_NAME'],
      email: ENV['GIT_EMAIL'],
      author_string: "#{ENV['GIT_NAME']} <#{ENV['GIT_EMAIL']}>"
    }
    @ssh_key_path = ENV['SSH_KEY_PATH']
    FileUtils.mkdir_p(@path)
  end

  def prepare_read_mode(remote_ssh_url)
    syscall_return("git init")
    if syscall("git remote add origin #{remote_ssh_url}") == false
      syscall("git remote set-url origin #{remote_ssh_url}")
    end
    syscall("git fetch origin --quiet")
    syscall("git reset --hard origin/main")
    syscall("git clean -f")
    @mode = GitRepo::READ_MODE
  end

  def log_commit_dates(limit = 1000)
    log_lines = syscall_return("git log --date=iso --pretty=format:'%ad' -n #{limit}")
    log_lines.split("\n").map do |date|
      Time.parse(date)
    end
  end

  def prepare_write_mode(remote_ssh_url)
    FileUtils.rm_rf(Dir.glob("#{path}/*", File::FNM_DOTMATCH))
    syscall_return("git init")
    syscall("git remote add origin #{remote_ssh_url}")
    @mode = GitRepo::WRITE_MODE
  end

  def commit_on_date(date)
    date = date.iso8601
    prepare_write_mode unless @mode == GitRepo::WRITE_MODE
    message = "Date: #{date}"
    env_opt = {
      "GIT_COMMITTER_NAME" => @author[:name],
      "GIT_COMMITTER_EMAIL" => @author[:email]
    }
    syscall("git commit -m \"#{message}\" --allow-empty --date \"#{date}\" --author \"#{@author[:author_string]}\" --quiet", env_opt)
  end

  def push
    env_opt = { "GIT_SSH_COMMAND" => "ssh -i ~/.ssh/id_contrigraph_user_ed25519 -o IdentitiesOnly=yes" }
    syscall(" git push origin main --force --quiet", env_opt)
  end

  private
  def syscall(cmd, envs = {})
    env = envs.map { |k, v| "#{k}=\"#{v}\"" }.join(' ')
    system("cd #{@path} && #{env} #{cmd}")
  end

  def syscall_return(cmd)
    `cd #{@path} && #{cmd}`
  end
end