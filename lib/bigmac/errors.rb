module BigMac
  class BigMacError < StandardError
  end

  class AbstractMethodError < BigMacError
    def initialize(method_name)
      @method_name = method_name
    end

    def to_s
      "#{@method_name} is abstract."
    end
  end


  class GitCloneError < BigMacError
    def initialize(url, stderr)
      @url = url
      @stderr = stderr
    end

    def to_s
      <<-MSG.gsub /^\s+/, ""
        "Failed to clone git repository #{@url}"
        "If this is a private repository you should specify the -p option."
        #{@stderr}
      MSG
    end
  end

  class GitPullError < BigMacError
    def initialize(path, stderr)
      @path = path
      @stderr = stderr
    end

    def to_s
      <<-MSG.gsub /^\s+/, ""
        "Failed to pull git repository #{@path}"
        #{@stderr}
      MSG
    end
  end

  class UnaccessibleGithubRepoError < BigMacError
    attr_reader :repo
    def initialize(repo)
      super
      @repo = repo
    end

    def to_s
      <<-MSG.gsub /^\s+/, ""
        Could not access github repository: #{repo}.
        Possible Causes:
        - The repository you specified does not exist.
        - The repository you specified is private and you did not use the -p option
        - You did use the -p option but entered the wrong username/password
      MSG
    end
  end

  class GithubForbiddenError < BigMacError
    def initialize(result_json)
      super
      @result_json = result_json
    end

    def to_s
      msg = [] << "Github API just returned a 403 Forbidden response."

      if result_json['message'] =~ /API Rate Limit Exceeded for/
        msg << "- You have exceeded the number of allowed API request per hour"
      end

      msg << "Try running with the --force-clone option"
      msg.join("\n")
    end
  end

  class RequiredOptionError < BigMacError
    attr_reader :required
    def initialize(*required)
      super
      @required = required
    end

    def to_s
      if required.size == 1
        "The option #{required.first.inspect} is required."
      else
        "The options [#{required.map(&:inspect).join(',')}] are required."
      end
    end
  end
end