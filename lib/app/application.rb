require_relative 'mail'
require_relative 'task'

class Application

  def perform
    ot_mails = Mail.new.perform
    ot_mails.each do |mail|
      Task.new(mail).perform
    end
  end

end
