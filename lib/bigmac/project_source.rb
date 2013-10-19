require 'uri'
require 'fileutils'

module BigMac
  class ProjectSource
    DEFAULT_REPO_ID = "rteabeault/mccafe"
    DEFAULT_REPO_URL = "https://github.com/#{DEFAULT_REPO_ID}"

    class << self
      def from_id(id, options)
        klass, slug = klass_and_slug_for_id(id)
        klass.new(slug, options)
      end

      private

      def klass_and_slug_for_id(id)
        #TODO Add support for git and path sources
        case id
        when nil
          [GithubSource, DEFAULT_REPO_URL]
        when Github::URL_REGEX
          [GithubSource, id]
        else
          [GithubSource, "https://github.com/#{id}"]
        end
      end
    end

    attr_reader :local_path

    def download
      raise "Method download should be implemented"
    end
  end
end