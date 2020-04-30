#set :output, "/path/to/my/cron_log.log"

every :hour do
  command "ruby app.rb"
end
