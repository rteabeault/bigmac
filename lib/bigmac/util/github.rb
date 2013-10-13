module BigMac
  class Github
    URL_REGEX = /(?:(?:(?:https|git):\/\/github.com\/)|git@github.com:)([\w-]+)\/([\w-]+)(?:\.git|$)/

    class << self
      def valid_url?(url)
        url =~ URL_REGEX 
      end

      def parse_url(url)
        if url =~ URL_REGEX
          [url, $1, $2]
        else
          raise "#{url} is not a valid github url!"
        end
      end

    end

  end
end