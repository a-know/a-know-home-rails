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
end