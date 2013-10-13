class Thor
  module Shell
    class Basic
      def ask(statement, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        color = args.first

        if options[:limited_to]
          ask_filtered(statement, color, options)
        else
          ask_simply(statement, color, options)
        end
      end

      protected

      def ask_simply(statement, color, options)
        options = {:echo => true}.merge(options)
        default = options[:default]
        message = [statement, ("(#{default})" if default), nil].uniq.join(" ")
        say(message, color)

        stty_settings = `stty -g`
        begin
          system("stty -echo") unless options[:echo]
          result = $stdin.gets.chomp
        ensure
          system "stty #{stty_settings}"
          puts "\n" unless options[:echo]
        end

        return unless result

        result.strip!

        if default && result == ""
          default
        else
          result
        end
      end
    end
  end
end