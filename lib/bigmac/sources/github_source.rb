require 'rest_client'
require 'fileutils'
require 'pathname'

module BigMac
  class GithubSource < ProjectSource
    GIT_COMMAND = '/usr/bin/git'

    attr_reader :github_api
    attr_reader :destination
    attr_reader :url
    attr_reader :user_org
    attr_reader :repo_name

    def initialize(url, options)
      @url, @user_org, @repo_name = Github.parse_url(url)
      @github_api = GithubAPI.from_url(url, options)
      @destination = File.join(BigMac.repositories_dir, user_org, repo_name)
    end

    def download
      raise UnaccessibleGithubRepoError.new(url) unless @github_api.accessible?

      files = github_api.download_path('.bigmac', destination)

      if files.empty?
        Git.clone(url, destination)
      end

      Project.from_path(destination)
    end
  end
end