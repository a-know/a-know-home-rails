# encoding: utf-8

require 'rails_helper'

RSpec.describe 'bookmarks', type: :request do
  let(:time_current) { Time.zone.parse('2014-10-01 12:00:00 UTC') }
  let(:feed_xml) { <<EOS }
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns="http://purl.org/rss/1.0/" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:taxo="http://purl.org/rss/1.0/modules/taxonomy/" xmlns:opensearch="http://a9.com/-/spec/opensearchrss/1.0/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:hatena="http://www.hatena.ne.jp/info/xmlns#" xmlns:media="http://search.yahoo.com/mrss">
<channel rdf:about="http://b.hatena.ne.jp/a-know/">
<title>a-knowのブックマーク</title>
<link>http://b.hatena.ne.jp/a-know/</link>
<description>a-knowのブックマーク</description>
<opensearch:startIndex>1</opensearch:startIndex>
<opensearch:itemsPerPage>20</opensearch:itemsPerPage>
<opensearch:totalResults>5670</opensearch:totalResults>
<items>
<rdf:Seq>
<rdf:li rdf:resource="http://b.hatena.ne.jp/a-know/20160103#bookmark-275271782"/>
<rdf:li rdf:resource="http://b.hatena.ne.jp/a-know/20160103#bookmark-275274595"/>
</rdf:Seq>
</items>
</channel>
<item rdf:about="http://b.hatena.ne.jp/a-know/20160103#bookmark-275271782">
<title>今Ruby on Railsに入門するならこの教材と進め方が最短！</title>
<link>
http://webfood.info/materials-to-start-ruby-on-rails/
</link>
<description/>
<content:encoded>
<blockquote cite="http://webfood.info/materials-to-start-ruby-on-rails/" title="今Ruby on Railsに入門するならこの教材と進め方が最短！"><cite><img src="http://cdn-ak.favicon.st-hatena.com/?url=http%3A%2F%2Fwebfood.info%2F" alt="" /> <a href="http://webfood.info/materials-to-start-ruby-on-rails/">今Ruby on Railsに入門するならこの教材と進め方が最短！</a></cite><p>Ruby on Railsを比較的最近始めた私がやる価値のあると感じた教材を紹介していきます。また、それらの教材の最短の進め方についても触れられたらと思います。 Railsができて10年以上経つため、ベテランの方も多いです。ただ、そういった方は入門者の気持ちを忘れている可能性があるし、当時の教材を紹介されても今は古くなってしまっているでしょう。 ここ1、2年でRailsに入門した私は、今教材を紹介...</p><p><a href="http://b.hatena.ne.jp/entry/http://webfood.info/materials-to-start-ruby-on-rails/"><img src="http://b.hatena.ne.jp/entry/image/http://webfood.info/materials-to-start-ruby-on-rails/" alt="はてなブックマーク - 今Ruby on Railsに入門するならこの教材と進め方が最短！" title="はてなブックマーク - 今Ruby on Railsに入門するならこの教材と進め方が最短！" border="0" style="border: none" /></a> <a href="http://b.hatena.ne.jp/append?http://webfood.info/materials-to-start-ruby-on-rails/"><img src="http://b.hatena.ne.jp/images/append.gif" border="0" alt="はてなブックマークに追加" title="はてなブックマークに追加" /></a></p></blockquote><p><img src="http://cdn1.www.st-hatena.com/users/a-/a-know/profile_s.gif" class="profile-image" alt="a-know" title="a-know" width="16" height="16" /> <a href="http://b.hatena.ne.jp/a-know/20160103#bookmark-275271782">a-know</a> </p>
</content:encoded>
<dc:creator>a-know</dc:creator>
<dc:date>2016-01-03T11:50:48+09:00</dc:date>
<hatena:bookmarkcount>56</hatena:bookmarkcount>
</item>
<item rdf:about="http://b.hatena.ne.jp/a-know/20160103#bookmark-275274595">
<title>800年前の遺跡から発見された石器、ガラケーすぎると話題に - ライブドアニュース</title>
<link>http://news.livedoor.com/article/detail/11020673/</link>
<description>想像以上にガラケー</description>
<content:encoded>
<blockquote cite="http://news.livedoor.com/article/detail/11020673/" title="800年前の遺跡から発見された石器、ガラケーすぎると話題に - ライブドアニュース"><cite><img src="http://cdn-ak.favicon.st-hatena.com/?url=http%3A%2F%2Fnews.livedoor.com%2F" alt="" /> <a href="http://news.livedoor.com/article/detail/11020673/">800年前の遺跡から発見された石器、ガラケーすぎると話題に - ライブドアニュース</a></cite><p><a href="http://news.livedoor.com/article/detail/11020673/"><img src="http://cdn-ak.b.st-hatena.com/entryimage/275274595-1451720190.jpg" alt="800年前の遺跡から発見された石器、ガラケーすぎると話題に - ライブドアニュース" title="800年前の遺跡から発見された石器、ガラケーすぎると話題に - ライブドアニュース" class="entry-image" /></a></p><p>&gt; &gt; &gt; &gt; 2016年1月2日 12時0分 ざっくり言うと オーストリアの約800年前の遺跡から、携帯電話に似た石器が発見された ストレートタイプの携帯電話にそっくりで、丸いボタンが刻まれている メソポタミア全域で使用されていた、くさび形文字も確認できる ガラケーかよ！800年前の石器が折れないタイプの携帯電話すぎると話題に【動画】 2016年1月2日 12時0分 オーストリアの約800年前の...</p><p><a href="http://b.hatena.ne.jp/entry/http://news.livedoor.com/article/detail/11020673/"><img src="http://b.hatena.ne.jp/entry/image/http://news.livedoor.com/article/detail/11020673/" alt="はてなブックマーク - 800年前の遺跡から発見された石器、ガラケーすぎると話題に - ライブドアニュース" title="はてなブックマーク - 800年前の遺跡から発見された石器、ガラケーすぎると話題に - ライブドアニュース" border="0" style="border: none" /></a> <a href="http://b.hatena.ne.jp/append?http://news.livedoor.com/article/detail/11020673/"><img src="http://b.hatena.ne.jp/images/append.gif" border="0" alt="はてなブックマークに追加" title="はてなブックマークに追加" /></a></p></blockquote><p><img src="http://cdn1.www.st-hatena.com/users/a-/a-know/profile_s.gif" class="profile-image" alt="a-know" title="a-know" width="16" height="16" /> <a href="http://b.hatena.ne.jp/a-know/20160103#bookmark-275274595">a-know</a> 想像以上にガラケー</p>
</content:encoded>
<dc:creator>a-know</dc:creator>
<dc:date>2016-01-03T01:36:10+09:00</dc:date>
<hatena:bookmarkcount>13</hatena:bookmarkcount>
</item>
</rdf:RDF>
EOS

  subject { get '/bookmarks' }

  before do
    travel_to(time_current)
    stub_request(:get, "http://b.hatena.ne.jp/a-know/rss").
      to_return(:body => feed_xml)
  end

  describe 'GET /bookmarks' do
    it { subject; expect(response.status).to eq 200 }
    it { subject; expect(response.body).to be_json }
    it do
      subject
      expect(response.body).to be_json_as(
          {
            entries: [
              {
                "comment"      => "",
                "date"         => "2016-01-03-11",
                "hatebu_url"   => "http://b.hatena.ne.jp/entry/http://webfood.info/materials-to-start-ruby-on-rails/",
                "target_title" => "今Ruby on Railsに入門するならこの教材と進め方が最短！",
                "target_url"   => "http://webfood.info/materials-to-start-ruby-on-rails/"
              },
              {
                "comment"      => "想像以上にガラケー",
                "date"         => "2016-01-03-01",
                "hatebu_url"   => "http://b.hatena.ne.jp/entry/http://news.livedoor.com/article/detail/11020673/",
                "target_title" => "800年前の遺跡から発見された石器、ガラケーすぎると話題に - ライブドアニュース",
                "target_url"   => "http://news.livedoor.com/article/detail/11020673/"
              },
            ]
          }
        )
    end
  end
end
