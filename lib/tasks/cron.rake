desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  puts "Sending email updates..."
#  begin
    User.send_periodic_updates
#  rescue => ex
#    HoptoadNotifier.notify(ex)
#    puts 'Exception raised'
#  end
  puts "done."
end