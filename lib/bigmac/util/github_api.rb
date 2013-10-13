require 'rest_client'
require 'json/pure'

module BigMac
  class GithubAPI
    VALID_URL = /(?:(?:(?:https|git):\/\/github.com\/)|git@github.com:)([\w-]+)\/([\w-]+)(?:\.git|$)/

    class << self

      def from_url(github_repo_url, options)
        url, user_org, repo_name = Github.parse_url(github_repo_url)
        github_username = options[:github_username]
        github_password = options[:github_password]
        api_url = build_api_url(user_org, repo_name, github_username, github_password)

        GithubAPI.new(api_url)
      end

      def build_api_url(user_org, repo_name, username, password)
        if(username && password)
          "https://#{username}:#{password}@api.github.com/repos/#{user_org}/#{repo_name}"
        else
          "https://api.github.com/repos/#{user_org}/#{repo_name}"
        end
      end
    end

    attr_reader :api_url

    def initialize(api_url)
      @api_url = api_url
    end

    def accessible?
      @accessible ||= begin
        RestClient.get(api_url)
        true
      rescue RestClient::ResourceNotFound
        false
      end
    end

    def download_path(path, to)
      url = "#{@api_url}/contents/#{path}"
      files = find_files(path)
      if files.nil?
        []
      else
        files.map do |file|
          write_file(file, to)
        end
      end
    end

    def find_files(path)
      url = "#{@api_url}/contents/#{path}"
      begin
        results = api_request(url)
        results.reduce([]) do |files, file|
          if file['type'] == 'file'
            files << file
          elsif file['type'] == 'dir'
            files.concat(find_files(file['path']))
          end
        end
      rescue RestClient::ResourceNotFound
        []
      end
    end

    private

    def write_file(file, to)
      file_path = File.join(to, file['path'])
      FileUtils.mkdir_p File.dirname(file_path)

      File.open(file_path, 'w+') do |f|
        url = "#{@api_url}/contents/#{file['path']}"
        f.write api_request(url, :accept => 'application/vnd.github.raw')
      end

      file_path
    end

    def api_request(url, options = {})
      RestClient.get(url, options) do |response, request, result, &block|
        case response.code
        when 200
          if options[:accept] == 'application/vnd.github.raw'
            response
          else
            JSON.parse(response)
          end
        when 403
          raise GithubForbiddenError.new(JSON.parse(response))
        # when 404
        #   nil
        else
          response.return!(request, result, &block)
        end
      end
    end
  end
end