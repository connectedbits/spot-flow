# frozen_string_literal: true

module SpotFlow
  module Services
    module ProcessExecutor

      def execute_process(*args, env: nil)
        command = args.shelljoin

        r, w = IO.pipe
        process_env = env || {}
        process_env["PATH"] ||= ENV["PATH"]
        process_env["NODE_PATH"] ||= ENV["NODE_PATH"]

        # The redirection of err to the STDERR of the owning process is to allow the
        # caller process to have a chance to display any extra information emitted via STDERR
        #
        # We also specifically drop any env vars that are not indicated by the caller
        # since we likely do not want to bleed any external information into the JS process
        pid = Process.spawn(process_env, command, unsetenv_others: true, out: w, err: STDERR)
        status = Process::Status.wait(pid)
        w.close
        stdout = r.read.chomp rescue nil
        r.close
        if status.success?
          stdout
        else
          raise "#{command} failed, #{status}: #{stdout || "No output"}"
        end
      end

      def execute_json_process(*args, env: nil)
        JSON.parse(execute_process(*args, env: env))
      end
    end
  end
end
