set :branch, 'master'

set :rails_env, :production
role :web,    %w{a-know@home.a-know.me}

namespace :deploy do
  # Mackerel のグラフアノテーションのためにデプロイ開始時間を取得するだけのタスク
  task :starting do
    set :deploy_starttime, Time.now.to_i
  end

  task :finished do
    deploy_endtime = Time.now.to_i
    annotation = {
      service: 'home_a-know_me',
      role: [ 'web' ],
      from: fetch(:deploy_starttime),
      to: deploy_endtime,
      title: 'Application Deployed',
      description: 'Application deployed by capistrano'
    }
    mackerel_client = Mackerel::Client.new(mackerel_api_key: ENV['MACKEREL_APIKEY'])
    mackerel_client.post_graph_annotation(annotation)
  end
end
