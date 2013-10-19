module BigMac
  module UI

    def mute!
      @mute = true
    end

    def unmute!
      @mute = false
    end

    def info(message, color = :bold)
      return if quiet? 

      say("      #{message}", color)
    end

    def debug(message, color = :yellow)
      return unless debug?
      
      say("      #{message}", color)
    end

    def error(message, color = :red)
      return if quiet?

      say(message, color)
    end

    def banner(message, color = :cyan)
      return if quiet? 

      say("----> #{message}", color)
    end

    def debug=(debug)
      @debug = debug
    end

    def debug?
      @debug
    end
  end
end