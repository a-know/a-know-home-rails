class KnockController < SendToFluentController
  def notify
    fluent_logger('knock').post('slack',
      {
        message: [
          "Visitor Incoming!!",
          "UA : #{params['user_agent']}",
          "Language : #{params['language']}"
        ].join("\n")
      }
    ) if want_to_knock?
  end

  private

  def want_to_knock?
    !(admin? || from_bot?)
  end

  def admin?
    params['admin'].present? && params['admin'] == 'true'
  end

  def from_bot?
    params['user_agent'].include?('bot.html')
  end
end
