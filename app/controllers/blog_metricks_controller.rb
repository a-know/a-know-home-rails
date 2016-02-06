require 'google/api_client'

class BlogMetricksController < SendToFluentController
  HATEDA_RSS = 'http://d.hatena.ne.jp/a-know/rss'.freeze
  HATEBLO_FEED = 'http://blog.a-know.me/feed'.freeze
  HATEBLO_RSS = 'http://blog.a-know.me/rss'.freeze

  LDR_ENDPOINT = 'http://rpc.reader.livedoor.com/count?feedlink='.freeze

  DUMMY_UA = 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01'

  def count_bookmarks
    return unless every_15min?

    response_header = `curl -i -A '#{DUMMY_UA}' http://b.hatena.ne.jp/bc/gr/http://blog.a-know.me/`
    response_header =~ /Location: (.+)\r\n/
    image_url = $1

    bookmark_count = File.basename(image_url).to_i

    fluent_logger('blog-metricks').post('bookmark', { count: bookmark_count })
  end

  def count_subscribers
    return unless every_15min?

    ldr_hateda = ldr_check(Net::HTTP.get(URI.parse(LDR_ENDPOINT + HATEDA_RSS)).to_i)
    ldr_hateblo_feed = ldr_check(Net::HTTP.get(URI.parse(LDR_ENDPOINT + HATEBLO_FEED)).to_i)
    ldr_hateblo_rss  = ldr_check(Net::HTTP.get(URI.parse(LDR_ENDPOINT + HATEBLO_RSS)).to_i)

    # http://cloud.feedly.com/v3/feeds/feed%2Fhttp%3A%2F%2Fd.hatena.ne.jp%2Fa-know%2Frss
    feedly_hateda = JSON.parse(Net::HTTP.get(URI.parse(feedly_target(HATEDA_RSS))))['subscribers']
    feedly_hateblo_feed = JSON.parse(Net::HTTP.get(URI.parse(feedly_target(HATEBLO_FEED))))['subscribers']
    feedly_hateblo_rss  = JSON.parse(Net::HTTP.get(URI.parse(feedly_target(HATEBLO_RSS))))['subscribers']

    hateblo_subscribers_response = `curl -A '#{DUMMY_UA}' http://blog.hatena.ne.jp/a-know/a-know.hateblo.jp/subscribe/iframe`
    hateblo_subscribers_response =~ /data-subscribers-count="(\d+)"/
    hateblo_subscribers = $1.to_i

    total_subscribers = ldr_hateda +
                        ldr_hateblo_feed +
                        ldr_hateblo_rss +
                        feedly_hateda +
                        feedly_hateblo_feed +
                        feedly_hateblo_rss +
                        hateblo_subscribers

    fluent_logger('blog-metricks').post('subscribers',
      {
        total_subscribers: total_subscribers,
        ldr_hateda: ldr_hateda,
        ldr_hateblo_feed: ldr_hateblo_feed,
        ldr_hateblo_rss: ldr_hateblo_rss,
        feedly_hateda: feedly_hateda,
        feedly_hateblo_feed: feedly_hateblo_feed,
        feedly_hateblo_rss: feedly_hateblo_rss,
        hateblo_subscribers: hateblo_subscribers,
      }
    )
  end

  def count_hatena_stars
    return unless every_15min?

    blog_star_count  = JSON.parse(Net::HTTP.get(URI.parse(hatena_star_count('http://blog.a-know.me/'))))['star_count']
    photo_star_count = JSON.parse(Net::HTTP.get(URI.parse(hatena_star_count('http://photos.a-know.me/'))))['star_count']

    fluent_logger('blog-metricks').post('hatena-star',
      {
        blog_star_count: blog_star_count,
        photo_star_count: photo_star_count,
      }
    )
  end


  # see https://github.com/a-know/a-know-dashing/blob/master/jobs/visitor_count_real_time.rb
  def count_active_visitors
    # Update these to match your own apps credentials
    service_account_email = ENV['SERVICE_ACCOUNT_EMAIL'] # Email of service account
    profile_id = ENV['PROFILE_ID'] # Analytics profile ID.

    # Get the Google API client
    client = Google::APIClient.new(
      :application_name => ENV['APPLICATION_NAME'],
      :application_version => '0.01'
    )

    key = OpenSSL::PKey::RSA.new(ENV['A_KNOW_GOOGLE_API_KEY'])
    client.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience             => 'https://accounts.google.com/o/oauth2/token',
      :scope                => 'https://www.googleapis.com/auth/analytics.readonly',
      :issuer               => service_account_email,
      :signing_key          => key,
    )

    # Request a token for our service account
    client.authorization.fetch_access_token!

    # Get the analytics API
    analytics = client.discovered_api('analytics','v3')

    # Execute the query, get the value `[["1"]]`
    response = client.execute(:api_method => analytics.data.realtime.get, :parameters => {
      'ids' => "ga:" + profile_id,
      'metrics' => "ga:activeVisitors",
    }).data.rows

    number = response.empty? ? 0 : response.first.first.to_i

    fluent_logger('blog-metricks').post('active-visitors',
      {
        number: number,
      }
    )
  end

  private

  def ldr_check(count)
    count < 0 ? 0 : count
  end

  def feedly_target(rss_url)
    'http://cloud.feedly.com/v3/feeds/' + URI.escape("feed/#{rss_url}", ':/')
  end

  def hatena_star_count(url)
    'http://s.hatena.com/blog.json?uri=' + URI.escape(url, ':/')
  end
end