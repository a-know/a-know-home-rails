class BlogMetricksController < ActionController::API
  def count_bookmarks
    response_header = `curl -i -A 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01' http://b.hatena.ne.jp/bc/gr/http://blog.a-know.me/`
    response_header =~ /Location: (.+)\r\n/
    image_url = $1

    bookmark_count = File.basename(image_url).to_i

    logger = if Rails.env == 'test'
               Fluent::Logger::TestLogger.new('blog-metricks')
             else
               Fluent::Logger::FluentLogger.new('blog-metricks')
             end
    logger.post('bookmark',
      {
        count: bookmark_count
      }
    )
  end

  def count_subscribers
    ldr_hateda = ldr_check(Net::HTTP.get(URI.parse('http://rpc.reader.livedoor.com/count?feedlink=' + 'http://d.hatena.ne.jp/a-know/rss')).to_i)
    ldr_hateblo_feed = ldr_check(Net::HTTP.get(URI.parse('http://rpc.reader.livedoor.com/count?feedlink=' + 'http://blog.a-know.me/feed')).to_i)
    ldr_hateblo_rss  = ldr_check(Net::HTTP.get(URI.parse('http://rpc.reader.livedoor.com/count?feedlink=' + 'http://blog.a-know.me/rss')).to_i)

    # http://cloud.feedly.com/v3/feeds/feed%2Fhttp%3A%2F%2Fd.hatena.ne.jp%2Fa-know%2Frss
    feedly_hateda = JSON.parse(Net::HTTP.get(URI.parse(feedly_target('http://d.hatena.ne.jp/a-know/rss'))))['subscribers']
    feedly_hateblo_feed = JSON.parse(Net::HTTP.get(URI.parse(feedly_target('http://blog.a-know.me/feed'))))['subscribers']
    feedly_hateblo_rss  = JSON.parse(Net::HTTP.get(URI.parse(feedly_target('http://blog.a-know.me/rss'))))['subscribers']

    hateblo_subscribers_response = `curl -A 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01' http://blog.hatena.ne.jp/a-know/a-know.hateblo.jp/subscribe/iframe`
    hateblo_subscribers_response =~ /data-subscribers-count="(\d+)"/
    hateblo_subscribers = $1.to_i

    total_subscribers = ldr_hateda + ldr_hateblo_feed + ldr_hateblo_rss + feedly_hateda + feedly_hateblo_feed + feedly_hateblo_rss + hateblo_subscribers

    logger = if Rails.env == 'test'
               Fluent::Logger::TestLogger.new('blog-metricks')
             else
               Fluent::Logger::FluentLogger.new('blog-metricks')
             end
    logger.post('subscribers',
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

  private

  def ldr_check(count)
    count < 0 ? 0 : count
  end

  def feedly_target(rss_url)
    'http://cloud.feedly.com/v3/feeds/' + URI.escape("feed/#{rss_url}", ':/')
  end
end