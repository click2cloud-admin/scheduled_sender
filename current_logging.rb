module CurrentLogging
  def logger
    @logger ||= CurrentLogging.logger_for(self.class.name)
  end

  # Use a hash class-ivar to cache a unique Logger per class:
  @loggers = {}

  class << self
    def logger_for(classname)
      @loggers['scheduler_logger'] ||= configure_logger
    end

    def configure_logger
     logger = Logging.logger['scheduler_logger']
      logger.add_appenders(
      	Logging.appenders.file('scheduler_sender.log'),
		Logging.appenders.stdout
      	)
      logger
      
    end
  end
end