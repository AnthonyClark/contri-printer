require 'dotenv/load'
require 'octokit'
require 'git'
require 'securerandom'
require 'Date'
require 'time'
require_relative 'git_repo.rb'

class GitService
  SECONDS_PER_DAY = 60 * 60 * 24
  HIGH = 10
  LOW = 1

  def initialize
    @github = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    @git_repo = GitRepo.new(Dir.mktmpdir)
  end

  def clear_contributions
    @github.delete_repo(current_gh_repo[:full_name])
  end

  def push_data_to_display(data)
    github_repo = @github.create_repo("display_#{SecureRandom.hex(3)}")
    @git_repo.prepare_write_mode(github_repo[:ssh_url])
    data_to_commits(data)
    @git_repo.push
  end

  def get_current_data
    @git_repo.prepare_read_mode(current_gh_repo[:ssh_url])
    commit_counts = @git_repo.log_commit_dates(10_000).map do |date|
      days_since(date)
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
        commit_count.times { @git_repo.commit_on_date(date) }
      end
    end
  end

  def date_days_ago(days)
    (Time.now.utc - (days * 24 * 60 * 60))
  end

  def days_since(t)
    ((Time.now - t) / (GitService::SECONDS_PER_DAY)).floor
  end

  def current_gh_repo
    @current_gh_repo ||= @github.repos.find {|r| r[:name].start_with?('display') }
  end
end
