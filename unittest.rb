module Test
  module Unit
    module UI
      SILENT = false
    end
    class AutoRunner
      def output_level=(level)
        self.runner_options[:output_level] = level
      end
    end
  end
end
