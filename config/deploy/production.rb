require 'mackerel/client'

set :mackerel_api_key, ENV['MACKEREL_API_KEY']
set :service, ENV['MACKEREL_SERVICE_NAME']
set :user, 'a-know'

@client = Mackerel::Client.new(mackerel_api_key: fetch(:mackerel_api_key))

def host_ip_addrs(role)
  hosts = @client.get_hosts(service: fetch(:service), roles: fetch(:role)).select do |host|
    host.status === 'standby' || host.status === 'working'
  end.map do |host|
    interface = host.interfaces.find { |i| /^eth/ === i['name'] }
    interface['ipAddress'] if interface
  end.select { |ipaddr| ipaddr != nil }.map do |ipaddr|
    "#{fetch(:user)}@#{ipaddr}"
  end
end

set :branch, 'master'

set :rails_env, :production
role :web, 'home.a-know.me'

