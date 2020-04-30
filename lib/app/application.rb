require_relative 'mail'
require_relative 'task'

class Application

  def perform
    mails = Mail.new.perform
    mails.each { | m | Task.new(m).perform }
  end

end
