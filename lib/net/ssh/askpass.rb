require 'net/ssh'
require 'net/ssh/authentication/methods/keyboard_interactive'

module Net
  module SSH
    module AskPass
      module Prompt
        def prompt(text, echo=true)
          if ssh_askpass = ENV['SSH_ASKPASS']
            `#{ssh_askpass} "#{text}"`.strip
          else
            prompt_console text, echo
          end
        end
      end    
    end

    Authentication::Methods::KeyboardInteractive.class_eval do
      alias :prompt_console :prompt
      include Net::SSH::AskPass::Prompt
      alias :prompt_askpass :prompt
    end

    KeyFactory.class_eval do
      class << self
        alias :prompt_console :prompt
        include Net::SSH::AskPass::Prompt
        alias :prompt_askpass :prompt
      end
    end
  end
end
