module Rbshell
  class Builtins
    class << self
      def cd(dir = ENV['HOME'])
        if dir == '-'
          dir = ENV['OLDPWD'] || ''
        end

        ENV['OLDPWD'] = Dir.pwd
        Dir.chdir(dir)
      rescue Errno::ENOENT
        $stdout.print "-rbsh: cd: #{dir}: No such file or directory\n"
      end

      def exit(code = 0)
        super(code.to_i)
      end

      def exec(*command)
        super(*command)
      end

      def set(args)
        k, v = args.split('=')
        ENV[k] = v
      end

      alias_method :export, :set
    end
  end
end
