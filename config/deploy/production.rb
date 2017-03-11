set :branch, 'master'

set :rails_env, :production

def webapp_hosts
  service_name = 'grass-graph'
  role_name    = 'webapp'
  hosts_json = `curl -Ss -XGET "https://mackerel.io/api/v0/hosts?service=#{service_name}&role=#{role_name}" -H 'X-Api-Key:#{ENV['MACKEREL_APIKEY_READONLY']}'`
  JSON.parse(hosts_json)['hosts'].map{|n| n['name']}
end

role :web, webapp_hosts

namespace :deploy do
  # Mackerel のグラフアノテーションのためにデプロイ開始時間を取得するだけのタスク
  task :starting do
    set :deploy_starttime, Time.now.to_i
  end

  task :finished do
    deploy_endtime = Time.now.to_i
    annotation = {
      service: 'grass-graph',
      role: [ 'webapp', 'lb' ],
      from: fetch(:deploy_starttime),
      to: deploy_endtime,
      title: 'Application Deployed',
      description: 'Application deployed by capistrano'
    }
    mackerel_client = Mackerel::Client.new(mackerel_api_key: ENV['MACKEREL_APIKEY'])
    mackerel_client.post_graph_annotation(annotation)
  end
end
