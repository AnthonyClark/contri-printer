require 'dotenv/load'
require 'octokit'
require 'git'
require 'securerandom'
require 'Date'
require 'time'

class GitService
  SECONDS_PER_DAY = 60 * 60 * 24
  HIGH = 10
  LOW = 1

  def initialize
    # TODO: Fix git gem use of custom ssh script
    # TODO: Use a config rather than instance variables for ENV things
    @github = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    @author = ENV['GIT_CONTRIBUTER']
    @ssh_key_path = ENV['SSH_KEY_PATH']
  end

  def clear_contributions
    @github.delete_repo(current_gh_repo[:full_name])
  end

  def push_data_to_display(data)
    init_local_git_repo

    data_to_commits(data)

    push_to_display
  end

  def get_current_data
    # Clone current repo somewhere tmp
    FileUtils.mkdir_p(local_repo_path)
    git = Git.init(local_repo_path)
    git.add_remote('origin', current_gh_repo[:ssh_url]) unless git.remotes.any?
    reset_local_to_remote_repo

    # Get data from commits
    commit_counts = git.log(10_000).map do |commit|
      days_since(commit.author.date)
    end.tally

    first_day_offset = commit_counts.keys.max
    data = Array.new(7) { Array.new(53, 0) }

    (0..52).each do |week|
      (0..6).each do |day|
        index = (week * 7) + day

        count = commit_counts[first_day_offset - index] || 0
        data[day][week] = (count >= GitService::HIGH) ? 1 : 0
      end
    end

    data
  end

  private

  def data_to_commits(data)
    current_weekday_index = Date.today.wday + 1 # Last column on GH, weeks start Sunday

    # Days between today and start of graph
    offset = (52 * 7) + current_weekday_index

    # Go through each commit, column by column (week by week) not row by row
    (0..52).each do |week|
      (0..6).each do |day|
        index = (week * 7) + day
        date = date_days_ago(offset - index)
        commit_count = data[day][week] == 1 ? 10 : 1
        commit_count.times { commit(date: date) }
      end
    end
  end

  def push_to_display
    @github_repo = @github.create_repo("display_#{SecureRandom.hex(3)}")
    @git_repo_write.add_remote('origin', @github_repo[:ssh_url])
    system("cd #{@git_repo_write.dir.path} && GIT_SSH_COMMAND='ssh -i ~/.ssh/id_contrigraph_user_ed25519 -o IdentitiesOnly=yes' git push origin main --force")
    # run_git_command("push origin main --force")
  end

  def commit(date: date_days_ago(rand(365)))
    # TODO: Prevent git including pairing info with global git user conf
    @git_repo_write.commit(
      "Time: #{Time.now.utc}",
      allow_empty: true,
      author: @author,
      date: date
    )
  end

  def date_days_ago(days)
    (Time.now.utc - (days * 24 * 60 * 60)).iso8601
  end

  def init_local_git_repo
    path = "/tmp/display_repo/#{Time.now.utc.to_i}/"
    FileUtils.mkdir_p(path)
    @git_repo_write = Git.init(path)
  end

  # Method that gets number of days between two Time objects
  def days_since(t)
    ((Time.now - t) / (GitService::SECONDS_PER_DAY)).floor
  end

  def reset_local_to_remote_repo
    run_git_command("fetch origin")
    run_git_command("reset --hard origin/main")
  end

  def run_git_command(command)
    system("cd #{local_repo_path} && GIT_SSH_COMMAND='ssh -i #{@ssh_key_path} -o IdentitiesOnly=yes' git #{command}")
  end 

  def current_gh_repo
    @current_gh_repo ||= @github.repos.find {|r| r[:name].start_with?('display') }
  end

  def local_repo_path
    "/tmp/display_repo/#{current_gh_repo[:name]}/"
  end
end
