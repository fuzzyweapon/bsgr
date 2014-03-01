module AresMUSH
  module Login
    class QuitCmd
      include AresMUSH::Plugin

      # Validators
      no_switches

      def want_command?(client, cmd)
        cmd.root_is?("quit")
      end
            
      def handle
        client.emit_ooc(t("login.goodbye"))
        client.disconnect
      end
    end
  end
end
