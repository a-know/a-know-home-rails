require 'rss'

class BookmarksController < ActionController::API
  def index
    feed_url = URI.parse('http://b.hatena.ne.jp/a-know/rss')
    feed_url.query = "time=#{Time.now.to_i.to_s}" # against cache

    feed = ''
    Net::HTTP.start(feed_url.host, feed_url.port) do |http|
      feed = http.get(feed_url.path, 'User-Agent' => 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01' ).body
    end

    rss = RSS::Parser.parse(feed)

    render json: { entries: [].tap do |entries|
      rss.items.each do |item|
        entries << {}.tap do |entry|
          entry[:comment] = item.description.gsub(/[\r\n]/,"")
          entry[:date] = item.date.strftime('%Y-%m-%d-%H').gsub(/[\r\n]/,"")
          entry[:hatebu_url] = "http://b.hatena.ne.jp/entry/#{item.link}".gsub(/[\r\n]/,"")
          entry[:target_title] = item.title.gsub(/[\r\n]/,"")
          entry[:target_url] = item.link.gsub(/[\r\n]/,"")
        end
      end
    end }

  end
end
