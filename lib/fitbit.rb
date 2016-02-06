require 'fitgem'

# https://github.com/a-know/a-know-dashing/blob/master/lib/fitbit.rb
class Fitbit

  attr_reader :client, :options, :config

  def initialize(options = {})
    @options = options
    @config  = Fitgem::Client.symbolize_keys YAML.load(ERB.new(IO.read('.fitbit.yml')).result)
    @client  = Fitgem::Client.new config[:oauth].merge!(options)
  end

  def todays_steps
    summary['steps']
  end

  private

  def today
    @today ||= client.activities_on_date('today')
  end

  def summary
    today['summary']
  end

end