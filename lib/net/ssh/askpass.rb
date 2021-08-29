require 'net/ssh'

Net::SSH::Prompt::Prompter.class_eval do
  alias :ask_console :ask

  def ask(prompt, echo=true)
    if ssh_askpass = ENV['SSH_ASKPASS']
      `#{ssh_askpass}`.strip
    else
      ask_console prompt, echo
    end
  end
end
