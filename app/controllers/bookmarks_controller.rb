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
          entry[:comment] = trim_newline(item.description)
          entry[:date] = trim_newline(item.date.strftime('%Y-%m-%d-%H'))
          entry[:hatebu_url] = trim_newline("http://b.hatena.ne.jp/entry/#{item.link}")
          entry[:target_title] = trim_newline(item.title)
          entry[:target_url] = trim_newline(item.link)
        end
      end
    end }

  end

  private

  def trim_newline(str)
    str.gsub(/[\r\n]/,"")
  end
end
