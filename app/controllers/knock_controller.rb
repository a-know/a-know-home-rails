class KnockController < ApplicationController
  def notify
    log = if Rails.env == 'test'
            Fluent::Logger::TestLogger.new('knock')
          else
            Fluent::Logger::FluentLogger.new('knock')
          end
    log.post('slack',
      {
        message: [
          "Visitor Incoming!!",
          "UA : #{params['user_agent']}",
          "Language : #{params['language']}"
        ].join("\n")
      }
    )
  end
end
