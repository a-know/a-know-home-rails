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
    let(:hateblo_subscribers_button) { <<EOS }
<!DOCTYPE html>
<html
  lang="ja"
  data-avail-langs="ja en"

  data-feedback="http://blog.hatena.ne.jp/-/feedback/iframe"
  data-page="user-blog-subscribe-iframe"
  data-device="pc"

  data-static-domain="https://blog.st-hatena.com"

  data-admin-domain="http://blog.hatena.ne.jp"


  data-blog-name="えいのうにっき"
  data-blog-host="a-know.hateblo.jp"
  data-blogs-uri-base="http://blog.a-know.me"



  data-author="a-know"

  data-bkc="da39a3ee5e6b4b0d3255bfef95601890afd80709"

  >

  <head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>

    <title></title>


<script type="text/javascript">
// <!--

if (~navigator.userAgent.indexOf('Mac OS X')) {
  document.write('<style type="text/css">html, body { font-family: \x27Helvetica\x27, \x27Arial\x27, \x27ヒラギノ角ゴ Pro W3\x27, \x27Hiragino Kaku Gothic Pro\x27, sans-serif; } </style>');
} else {
  document.write('<style type="text/css">html, body { font-family: \x27Helvetica\x27, \x27Arial\x27, \x27メイリオ\x27, \x27Meiryo\x27, \x27MS PGothic\x27, sans-serif; } </style>');
}

// -->
</script>

<!--[if lt IE 9]>
<script src="https://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->




    <link rel="stylesheet" type="text/css" href="https://blog.st-hatena.com/css/admin.css?version=aa4c42cc56a9fce4d6a732ce3ee73a53"/>

  </head>
  <body class="body-iframe page-user-blog-subscribe-iframe">

  <div class="hatena-module">
    <div class="hatena-follow-button-box btn-subscribe js-hatena-follow-button-box"

    data-is-subscribing=""


    data-subscribers-count="3"
  >

  <a href="#" class="hatena-follow-button js-hatena-follow-button">
    <span class="subscribing">
      <span class="foreground">読者です</span>
      <span class="background">読者をやめる</span>
    </span>
    <span class="unsubscribing" data-track-name="profile-widget-subscribe-button" data-track-once>
      <span class="foreground">読者になる</span>
      <span class="background">読者になる</span>
    </span>
  </a>
  <div class="subscription-count-box js-subscription-count-box">
    <i></i>
    <u></u>
    <span class="subscription-count js-subscription-count">
    </span>
  </div>
</div>

  </div>



    <script type="text/javascript" src="https://platform.twitter.com/widgets.js"></script>
<script type="text/javascript" src="https://apis.google.com/js/plusone.js">
  {"parsetags": "explicit"}
</script>
<script type="text/javascript" src="https://b.st-hatena.com/js/bookmark_button.js" charset="utf-8" async="async"></script>



  <script type="text/javascript" src="http://cdn7.www.st-hatena.com/js/react/0.13.3/react-with-addons.min.js"></script>


<script type="text/javascript" src="http://cdn7.www.st-hatena.com/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="http://cdn7.www.st-hatena.com/js/jquery/jquery-ui.1.10.0.custom.min.js"></script>
<script type="text/javascript" src="http://cdn7.www.st-hatena.com/js/jquery/jquery.flot.0.8.3.js"></script>
<script type="text/javascript" src="http://cdn7.www.st-hatena.com/js/jquery/jquery.flot.time.0.8.3.js"></script>



<script type="text/javascript" src="https://blog.st-hatena.com/js/hatenablog.js?version=aa4c42cc56a9fce4d6a732ce3ee73a53"></script>
<script type="text/javascript" src="https://blog.st-hatena.com/js/texts-ja.js?version=aa4c42cc56a9fce4d6a732ce3ee73a53"></script>



<script src="https://www.google.com/recaptcha/api.js" async defer></script>




  </body>
</html>
EOS

    before do
      stub_request(:get, 'http://rpc.reader.livedoor.com/count?feedlink=http://d.hatena.ne.jp/a-know/rss').to_return(:body => "-1")
      stub_request(:get, 'http://rpc.reader.livedoor.com/count?feedlink=http://blog.a-know.me/feed').to_return(:body => "0")
      stub_request(:get, 'http://rpc.reader.livedoor.com/count?feedlink=http://blog.a-know.me/rss').to_return(:body => "1")
      stub_request(:get, 'http://cloud.feedly.com/v3/feeds/feed%2Fhttp%3A%2F%2Fd.hatena.ne.jp%2Fa-know%2Frss').to_return(:body => feedly_json)
      stub_request(:get, 'http://cloud.feedly.com/v3/feeds/feed%2Fhttp%3A%2F%2Fblog.a-know.me%2Ffeed').to_return(:body => feedly_json)
      stub_request(:get, 'http://cloud.feedly.com/v3/feeds/feed%2Fhttp%3A%2F%2Fblog.a-know.me%2Frss').to_return(:body => feedly_json)
      allow_any_instance_of(Kernel).to receive(:`).
        with("curl -A 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01' http://blog.hatena.ne.jp/a-know/a-know.hateblo.jp/subscribe/iframe").
        and_return(hateblo_subscribers_button)
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
end
