require 'net/ssh'

module Net
  module SSH
    module AskPass
      module Prompt
        def prompt(text, echo=true)
          if ssh_askpass = ENV['SSH_ASKPASS']
            `#{ssh_askpass}`.strip
          else
            prompt_console text, echo
          end
        end
      end
    end
  end
end

if Net::SSH::Prompt.method_defined?(:prompt)
  Net::SSH::Authentication::Methods::KeyboardInteractive.class_eval do
    alias :prompt_console :prompt
    include Net::SSH::AskPass::Prompt
  end

  Net::SSH::KeyFactory.class_eval do
    class << self
      alias :prompt_console :prompt
      include Net::SSH::AskPass::Prompt
    end
  end
else
  Net::SSH::Prompt::Prompter.class_eval do
    alias :prompt_console :ask
    include Net::SSH::AskPass::Prompt
    alias :ask :prompt
  end
end
