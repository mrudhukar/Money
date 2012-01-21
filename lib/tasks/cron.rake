def exception_notify
  yield
  rescue Exception => exception
  env = {}
  env['exception_notifier.options'] = {
    :email_prefix => "[Moneytracker Exception] ",
    :sender_address => %{"Exception Notifier" <moneytracker@moneytracker.heroku.com>},
    :exception_recipients => ENV['ADMIN_EMAIL'] || "mrudhu@gmail.com"
  }
  ExceptionNotifier::Notifier.exception_notification(env, exception).deliver
  raise exception
end

desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  puts "Sending email updates..."
  exception_notify { User.send_periodic_updates }
  puts "done."
end