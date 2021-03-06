class SendToFluentController < ActionController::API
  SEND_FREQUENCY_MIN = 15
  SEND_FREQUENCY_FITBIT = 5

  def fluent_logger(primary_tag)
    @logger ||= if Rails.env == 'test'
                Fluent::Logger::TestLogger.new(primary_tag)
              else
                Fluent::Logger::FluentLogger.new(primary_tag)
              end
  end

  private

  def every_15min?
    min = DateTime.now.min
    min % SEND_FREQUENCY_MIN == 0
  end

  def send_fitbit_timing?
    min = DateTime.now.min
    min % SEND_FREQUENCY_FITBIT == 0
  end
end