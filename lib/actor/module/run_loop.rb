module Actor
  module Module
    module RunLoop
      def run_loop &supplemental_action
        loop do
          message = reader.read

          handle message

          supplemental_action.() if supplemental_action
        end
      end

      def handle_stop
        raise StopIteration
      end
    end
  end
end
