#!/usr/bin/ruby
require 'logging'
require './current_logging.rb'

class Sender
  # Mix in the ability to log stuff ...
  include CurrentLogging

  def breath(minutes)
  	time = Time.now
	logger.info "#{time} Breathing in #{minutes} minute..."
  end

  def minutes_check
	begin

	    # get image
	    `raspistill -o /home/pi/detector/picam/still_image.jpg -q 40 -w 1024 -h 768`	     

	    ##### POST IMAGE TO SERVER
	    begin
	      attachment = Dir.glob("/home/pi/detector/picam/*.jpg").max_by {|f| File.mtime(f)}
	      logger.info  "#{time.to_s} attachment image is #{attachment}..."
	      
	      #attachment_video = "/home/pi/detector/picam/still_video.mp4"
	      #logger.info  "#{time.to_s} attachment video is #{attachment_video}..."

	      time = Time.now
	      logger.info "#{time.to_s} posting data..."

	      RestClient.post 'http://url/upload_single', :file => File.new(attachment, 'rb')
	      
	    rescue Exception => e

	      time = Time.now
	      logger.warn "#{time.to_s} error posting data: " + e.message  

	    end

	    time = Time.now
	    logger.info "#{time.to_s} done."

	  rescue Exception => e  

	    time = Time.now
	    logger.warn "#{time.to_s} error: " + e.message  

	  end
  end

  def hour_check
  	
	begin

		##### SEND EMAIL WITH IMAGE

	    time = Time.now	
	    logger.info "#{time} sending last update email..."

	    options = { :address              => "smtp.gmail.com",
	      :port                 => 587,
	      :domain               => 'gmail.com',
	      :user_name            => '----------',
	      :password             => '----------',
	      :authentication       => 'plain',
	      :enable_starttls_auto => true 
	    }

	    Mail.defaults do
	      delivery_method :smtp, options
	    end

	    attachment = Dir.glob("/home/pi/detector/picam/*.jpg").max_by {|f| File.mtime(f)}
	    logger.info  "#{time.to_s} attachment file is #{attachment}..."

	    mail = Mail.new do
	      from 'me@gmail.com'
	      to 'me@gmail.com'
	      subject 'Last update'
	      body File.read('body.txt')
	      add_file :filename => "#{attachment}", :content => File.read(attachment)
	    end

	    mail.deliver!

	rescue Exception => e

	    logger.warn "#{time.to_s} error sending email: " + e.message  
	end
  end
end