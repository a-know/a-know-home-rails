class SendToFluentController < ActionController::API
  def fluent_logger(primary_tag)
    @logger ||= if Rails.env == 'test'
                Fluent::Logger::TestLogger.new(primary_tag)
              else
                Fluent::Logger::FluentLogger.new(primary_tag)
              end
  end
end