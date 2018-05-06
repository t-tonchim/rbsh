require 'rbshell/version'
require 'rbshell/builtins'
require 'shellwords'
require 'io/console'
require 'readline'

module Rbshell
  ENV['PROMPT'] = 'rbsh-> '

  class << self
    def start
      Main.new.start
    end
  end

  class Main
    def start
      trap('INT', 'SIG_IGN')
      loop do
        commands = split_on_pipes
        placeholder_in = $stdin
        placeholder_out = $stdout
        pipe = []

        commands.each.with_index(1) do |command, index|
          program, *arguments = Shellwords.shellsplit(command)

          next if program.nil?
          if builtin?(program)
            call_builtin(program, *arguments)
          else
            if index < commands.size
              pipe = IO.pipe
              placeholder_out = pipe.last
            else
              placeholder_out = $stdout
            end

            spawn_program(program, *arguments, placeholder_out, placeholder_in)

            placeholder_out.close unless placeholder_out == $stdout
            placeholder_in.close unless placeholder_in == $stdin
            placeholder_in = pipe.first
          end
        end

        Process.waitall
      end
    end

    private

    def spawn_program(program, *arguments, placeholder_out, placeholder_in)
      fork do
        unless placeholder_out == $stdout
          $stdout.reopen(placeholder_out)
          placeholder_out.close
        end

        unless placeholder_in == $stdin
          $stdin.reopen(placeholder_in)
          placeholder_in.close
        end

        exec(program, *arguments)
      rescue Errno::ENOENT
        $stdout.print "-rbsh: #{program}: command not found\n"
      end
    end

    def line
     line = Readline.readline(ENV['PROMPT'])
     Readline::HISTORY.push(line)
     line
    end

    def split_on_pipes
      line.scan(/([^|]+)|["']([^"']+)["']/).flatten.compact
    end

    def builtin?(cmd)
      Builtins.respond_to?(cmd.to_sym)
    end

    def call_builtin(cmd, *arguments)
      Builtins.send(cmd.to_sym, *arguments)
    end
  end
end
