require 'json'

service_name = 'grass-graph'
role_name    = 'webapp'

hosts_json = `curl -Ss -XGET "https://mackerel.io/api/v0/hosts?service=#{service_name}&role=#{role_name}" -H 'X-Api-Key:#{ENV['MACKEREL_APIKEY_READONLY']}'`
hosts = JSON.parse(hosts_json)['hosts'].map{|n| n['id']}

hosts.each do |host|
  metadata_json = `curl -Ss -XGET https://mackerel.io/api/v0/hosts/#{host}/metadata/aws_instance_metadata -H 'X-Api-Key:#{ENV['MACKEREL_APIKEY_READONLY']}'`
  ip_addr = JSON.parse(metadata_json).find{|data| data['name'] == 'public_ip_addr'}['value']
  host_json = `curl -Ss -XGET https://mackerel.io/api/v0/hosts/#{host} -H 'X-Api-Key:#{ENV['MACKEREL_APIKEY_READONLY']}'`
  host_name = JSON.parse(host_json)['host']['name']

  f = File.open("/home/ubuntu/.ssh/config", "a")

  f.print <<EOS
Host #{host_name}
  HostName #{ip_addr}
  User a-know

EOS

  f.close
end
