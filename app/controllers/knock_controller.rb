class KnockController < ApplicationController
  def notify
    log = if Rails.env == 'test'
            Fluent::Logger::TestLogger.new('knock')
          else
            Fluent::Logger::FluentLogger.new('knock')
          end
    log.post('slack', { message: "Visitor Incoming!!\nUA : #{params['user_agent']}\nLanguage : #{params['language']}" })
  end
end
