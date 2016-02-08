# encoding: utf-8

require 'rails_helper'

RSpec.describe '/blog_metricks/bookmarks', type: :request do
  let(:fluent_logger) { double(:fluent_logger) }

  before do
    allow(Fluent::Logger::TestLogger).to receive(:new).with('blog-metricks').and_return(fluent_logger)
  end

  describe 'GET /blog_metricks/bookmarks' do
    let(:path) { "/blog_metricks/bookmarks" }
    let(:response_headers) do
      [
        "HTTP/1.1 302 Moved Temporarily",
        "Server: nginx",
        "Date: Fri, 05 Feb 2016 00:16:59 GMT",
        "Content-Type: text/html; charset=iso-8859-1",
        "Content-Length: 3",
        "Connection: keep-alive",
        "Cache-Control: max-age=1800",
        "Location: http://cdn-ak.b.st-hatena.com/images/counter/gr/00/01/0001489.gif",
        "Expires: Fri, 05 Feb 2016 00:18:57 GMT",
        "X-Content-Type-Options: nosniff",
        "X-Framework: Ridge/0.11",
        "X-Ridge-Dispatch: Hatena::Bookmark::Engine::Bc#default",
        "X-Runtime: 57ms",
        "X-View-Runtime: 0ms",
        "X-Cache: HIT from squid.hatena.ne.jp",
        "X-Cache-Lookup: HIT from squid.hatena.ne.jp:8080",
        "Via: 1.1 bookmark2squid13.hatena.ne.jp:8080 (squid/2.7.STABLE6)",
        "X-Roles: [sb]",
        "Vary: Accept-Encoding,Cookie,User-Agent",
        "",
        "302"
      ].join("\r\n")
    end

    before do
      allow_any_instance_of(Kernel).to receive(:`).
        with("curl -i -A 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01' http://b.hatena.ne.jp/bc/gr/http://blog.a-know.me/").
        and_return(response_headers)
    end

    subject { get path }

    context '15分刻みのタイミングのとき' do
      before { travel_to(Time.zone.parse('2016-04-01 15:30:45 JST')) }

      it 'fluentd に投げて 204 を返す' do
        expect(fluent_logger).to receive(:post).with('bookmark', { count: 1489 })
        subject
        expect(response.status).to eq 204
      end
    end

    context '15分刻みのタイミングではないとき' do
      before { travel_to(Time.zone.parse('2016-04-01 15:50:55 JST')) }

      it 'fluentd には投げずに 204 を返す' do
        expect(fluent_logger).to_not receive(:post)
        subject
        expect(response.status).to eq 204
      end
    end
  end

  describe 'GET /blog_metricks/subscribers' do
    let(:path) { "/blog_metricks/subscribers" }
    let(:feedly_json) { <<EOS }
{"id":"feed/http://d.hatena.ne.jp/a-know/rss","feedId":"feed/http://d.hatena.ne.jp/a-know/rss","language":"en","title":"えいのうにっき","velocity":2.3,"subscribers":2,"website":"http://blog.a-know.me/","contentType":"article","description":"あたまのなかのデトックスを、不定期的に。主に Web 系技術ネタ。","coverUrl":"http://storage.googleapis.com/site-assets/I9VeG9f0QeTtPISmaHzbDyWcWThVnYA7R26i24uITMk_cover-14f11f4446d","iconUrl":"http://storage.googleapis.com/site-assets/I9VeG9f0QeTtPISmaHzbDyWcWThVnYA7R26i24uITMk_icon-150c6077020","partial":false,"twitterScreenName":"a_know","visualUrl":"http://storage.googleapis.com/site-assets/I9VeG9f0QeTtPISmaHzbDyWcWThVnYA7R26i24uITMk_visual-150c6077020","coverColor":"000000","twitterFollowers":881}
EOS
    let(:hateblo_subscribers_button) { File.read(Rails.root + 'spec/files/blog_metricks/subscribe_button.html') }

    before do
      stub_request(:get, 'http://rpc.reader.livedoor.com/count?feedlink=http://d.hatena.ne.jp/a-know/rss').to_return(:body => "-1")
      stub_request(:get, 'http://rpc.reader.livedoor.com/count?feedlink=http://blog.a-know.me/feed').to_return(:body => "0")
      stub_request(:get, 'http://rpc.reader.livedoor.com/count?feedlink=http://blog.a-know.me/rss').to_return(:body => "1")
      stub_request(:get, 'http://cloud.feedly.com/v3/feeds/feed%2Fhttp%3A%2F%2Fd.hatena.ne.jp%2Fa-know%2Frss').to_return(:body => feedly_json)
      stub_request(:get, 'http://cloud.feedly.com/v3/feeds/feed%2Fhttp%3A%2F%2Fblog.a-know.me%2Ffeed').to_return(:body => feedly_json)
      stub_request(:get, 'http://cloud.feedly.com/v3/feeds/feed%2Fhttp%3A%2F%2Fblog.a-know.me%2Frss').to_return(:body => feedly_json)
      stub_request(:get, 'http://blog.hatena.ne.jp/a-know/a-know.hateblo.jp/subscribe/iframe').to_return(:body => hateblo_subscribers_button)
    end

    subject { get path }

    context '15分刻みのタイミングのとき' do
      before { travel_to(Time.zone.parse('2016-04-01 15:30:45 JST')) }
      it 'fluentd に投げて 204 を返す' do
        expect_hash = {
          total_subscribers: 10, # 0 + 0 + 1 + 2 + 2 + 2 + 3
          ldr_hateda: 0,
          ldr_hateblo_feed: 0,
          ldr_hateblo_rss: 1,
          feedly_hateda: 2,
          feedly_hateblo_feed: 2,
          feedly_hateblo_rss: 2,
          hateblo_subscribers: 3,
        }
        expect(fluent_logger).to receive(:post).
          with('subscribers', expect_hash)
        subject
        expect(response.status).to eq 204
      end
    end

    context '15分刻みのタイミングではないとき' do
      before { travel_to(Time.zone.parse('2016-04-01 15:50:55 JST')) }
      it 'fluentd には投げずに 204 を返す' do
        expect(fluent_logger).to_not receive(:post)
        subject
        expect(response.status).to eq 204
      end
    end
  end

  describe 'GET /blog_metricks/hatena_stars' do
    let(:path) { "/blog_metricks/hatena_stars" }
    let(:blog_json)  { '{"count":{"green":8,"blue":1,"red":2,"yellow":"237"},"title":"\u3048\u3044\u306e\u3046\u306b\u3063\u304d","uri":"http://blog.a-know.me/","star_count":123}' }
    let(:photo_json) { '{"count":{"yellow":"125"},"title":"\u3048\u3044\u306e\u3046\u3075\u3049\u3068","uri":"http://photos.a-know.me/","star_count":456}' }

    before do
      stub_request(:get, 'http://s.hatena.com/blog.json?uri=http%3A%2F%2Fblog.a-know.me%2F').to_return(:body => blog_json)
      stub_request(:get, 'http://s.hatena.com/blog.json?uri=http%3A%2F%2Fphotos.a-know.me%2F').to_return(:body => photo_json)
    end

    subject { get path }

    context '15分刻みのタイミングのとき' do
      before { travel_to(Time.zone.parse('2016-04-01 15:30:45 JST')) }
      it 'fluentd に投げて 204 を返す' do
        expect_hash = {
          blog_star_count: 123,
          photo_star_count: 456,
        }
        expect(fluent_logger).to receive(:post).
          with('hatena-star', expect_hash)
        subject
        expect(response.status).to eq 204
      end
    end

    context '15分刻みのタイミングではないとき' do
      before { travel_to(Time.zone.parse('2016-04-01 15:50:55 JST')) }
      it 'fluentd には投げずに 204 を返す' do
        expect(fluent_logger).to_not receive(:post)
        subject
        expect(response.status).to eq 204
      end
    end
  end

  describe 'GET /blog_metricks/active_visitors' do
    pending 'Google Analytics API をリクエストし、リアルタイムで訪問者数を取得、fluentd に送る'
  end
end
