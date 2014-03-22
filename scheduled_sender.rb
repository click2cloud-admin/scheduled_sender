require 'rufus-scheduler'
require 'mail'
require 'logging'
require 'rest_client'
require 'bundler/setup'
require './current_logging.rb'
require './sender.rb'

include CurrentLogging


time = Time.now
logger.level = :debug
logger.info "#{time.to_s} starting..."


scheduler = Rufus::Scheduler.new
sender = Sender.new

# get video
#{}`raspivid -t 5000 -o /home/pi/detector/picam/still_video.mp4`

scheduler.every('1m') do

  sender.breath(1)

end


scheduler.every '2m' do

  sender.minutes_check

end


scheduler.every '1h' do

 sender.hour_check

end

scheduler.join

