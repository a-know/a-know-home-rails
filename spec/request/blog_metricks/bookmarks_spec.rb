require 'rails_helper'

RSpec.describe '/blog_metricks/bookmarks', type: :request do
  describe 'GET /blog_metricks/bookmarks' do
    let(:path) { "/blog_metricks/bookmarks" }
    let(:fluent_logger) { double(:fluent_logger) }
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
      allow(Fluent::Logger::TestLogger).to receive(:new).with('blog-metricks').and_return(fluent_logger)
      allow_any_instance_of(Kernel).to receive(:`).
        with("curl -i -A 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01' http://b.hatena.ne.jp/bc/gr/http://blog.a-know.me/").
        and_return(response_headers)
    end

    subject { get path }

    it '204' do
      expect(fluent_logger).to receive(:post).with('bookmark', { count: 1489 })
      subject
      expect(response.status).to eq 204
    end
  end
end
