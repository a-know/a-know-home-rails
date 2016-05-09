# encoding: utf-8

require 'rails_helper'

RSpec.describe GrassGraphController do
  let(:controller) { described_class.new }
  let(:github_id)  { 'a-know' }
  let(:dummy_tmpfile) { 'tmp/spec/test.svg' }

  before do
    Dir.mkdir('tmp/spec') unless File.exists?('tmp/spec')
    File.delete(dummy_tmpfile) if File.exists?(dummy_tmpfile)
    stub_request(:get, 'https://github.com/a-know').to_return(:body => File.read('spec/files/page_response.txt'))
  end

  after { File.delete(dummy_tmpfile) if File.exists?(dummy_tmpfile) }

  describe '#tmpfile_path' do
    before do
      allow(controller).to receive(:type).and_return('graph')
      travel_to(Time.zone.parse('2016-04-01 15:30:45 JST'))
    end

    context '指定された github id が a-know だった場合' do
      it 'tmp/gg_svg に svg ファイルを作る前提でそのパスを返すこと' do
        expect(controller.tmpfile_path(github_id)).to eq './tmp/gg_svg/a-know_2016-04-01_graph.svg'
      end
    end

    context '指定された github id が a-know 以外だった場合' do
      let(:github_id)  { 'b-know' }
      before do
        Dir.delete('./tmp/gg_others_svg/2016-04-01') if File.exists?('./tmp/gg_others_svg/2016-04-01')
      end
      subject { controller.tmpfile_path(github_id) }

      it 'tmp/gg_others_svg に 年月日ごとのディレクトリを作ること' do
        subject
        expect(File.exists?('./tmp/gg_others_svg/2016-04-01')).to be_truthy
      end

      it 'tmp/gg_others_svg/yyyy-MM-dd に svg ファイルを作る前提でそのパスを返すこと' do
        expect(subject).to eq './tmp/gg_others_svg/2016-04-01/b-know_2016-04-01_graph.svg'
      end
    end
  end

  describe '#extract_svg' do
    before do
      allow(controller).to receive(:tmpfile_path).with(github_id).and_return(dummy_tmpfile)
    end

    context 'type=graph オプションが指定された場合' do
      before { allow(controller).to receive(:type).and_return('graph') }
      context 'svg 抽出済みのファイルが既に存在する場合' do
        before { FileUtils.copy('spec/files/extracted.svg', dummy_tmpfile) unless File.exists?(dummy_tmpfile) }

        it 'public contributions のグラフを svg 形式でファイルに出力したもの（既に存在するもの）の内容を返す・GCS へのアップロードは行わない' do
          expect(controller).to_not receive(:upload_gcs).with(github_id, dummy_tmpfile)
          expect(controller.extract_svg(github_id)).to eq File.read('spec/files/expect.svg')
        end
      end

      context 'svg 抽出済みのファイルがまだ存在しない場合' do
        it 'public contributions のグラフを svg 形式でファイルに出力したもの（今回新たに取得したもの）の内容を返す・GCS へのアップロードも行う' do
          expect(controller).to receive(:upload_gcs).with(github_id, dummy_tmpfile)
          expect(controller.extract_svg(github_id)).to eq File.read('spec/files/expect.svg')
        end

        it '凡例の位置が左下であること' do
          svg = controller.extract_svg(github_id)
          expect(svg).to include %Q|<text font-family="Helvetica" x="5" y="110">Less</text><g transform="translate(39 , 0)"><rect class="day" width="11" height="11" y="99" fill="#eeeeee"/></g><g transform="translate(54 , 0)"><rect class="day" width="11" height="11" y="99" fill="#d6e685"/></g><g transform="translate(69 , 0)"><rect class="day" width="11" height="11" y="99" fill="#8cc665"/></g><g transform="translate(84 , 0)"><rect class="day" width="11" height="11" y="99" fill="#44a340"/></g><g transform="translate(99 , 0)"><rect class="day" width="11" height="11" y="99" fill="#1e6823"/></g><text font-family="Helvetica" x="118" y="110">More</text>|
        end

        it 'Current streak の情報だけ、右下に表示されていること' do
          svg = controller.extract_svg(github_id)
          expect(svg).to include %Q|<text x="620" y="110" font-size="18px">42 days</text>|
        end

        context '不正な GitHub ID が指定されていた場合' do
          let(:github_id)  { '<github_id>' }
          
          it 'id:a-know として正常処理を行うこと' do
            expect(controller).to receive(:upload_gcs).with(github_id, dummy_tmpfile)
            expect(controller.extract_svg(github_id)).to eq File.read('spec/files/expect.svg')
            expect(svg).to include %Q|<text font-family="Helvetica" x="5" y="110">Less</text><g transform="translate(39 , 0)"><rect class="day" width="11" height="11" y="99" fill="#eeeeee"/></g><g transform="translate(54 , 0)"><rect class="day" width="11" height="11" y="99" fill="#d6e685"/></g><g transform="translate(69 , 0)"><rect class="day" width="11" height="11" y="99" fill="#8cc665"/></g><g transform="translate(84 , 0)"><rect class="day" width="11" height="11" y="99" fill="#44a340"/></g><g transform="translate(99 , 0)"><rect class="day" width="11" height="11" y="99" fill="#1e6823"/></g><text font-family="Helvetica" x="118" y="110">More</text>|
            expect(svg).to include %Q|<text x="620" y="110" font-size="18px">42 days</text>|
          end
        end
      end
    end

    context 'type=detail オプションが指定された場合' do
      before { allow(controller).to receive(:type).and_return('detail') }

      it 'detail に適したサイズの宣言が含まれていること' do
        svg = controller.extract_svg(github_id)
        expect(svg).to match /translate\(15, 60\)/
        expect(svg).to match /width="720" height="375"/
      end

      it 'detail な情報が svg に含まれていること' do
        svg = controller.extract_svg(github_id)
        expect(svg).to match %r|<text font-family="Helvetica" x="40" y="150" font-size="15px">Contributions in the last year</text>|
        expect(svg).to match %r|<text font-family="Helvetica" x="330" y="150" font-size="15px">Longest streak</text>|
        expect(svg).to match %r|<text font-family="Helvetica" x="550" y="150" font-size="15px">Current streak</text>|
        expect(svg).to match %r|1,498 total|
        expect(svg).to match %r|43 days|
        expect(svg).to match %r|42 days|
      end

      it 'detail な情報を区別する罫線が含まれていること' do
        svg = controller.extract_svg(github_id)
        expect(svg).to match %r|<g stroke="gray" stroke-width="1"><path d="M 0 130 H 700"/></g>|
        expect(svg).to match %r|<g stroke="gray" stroke-width="1"><path d="M 0 130 V 235"/></g><g stroke="gray" stroke-width="1"><path d="M 270 130 V 235"/></g><g stroke="gray" stroke-width="1"><path d="M 490 130 V 235"/></g><g stroke="gray" stroke-width="1"><path d="M 700 130 V 235"/></g><g stroke="gray" stroke-width="1"><path d="M 0 235 H 700"/></g>|
      end

      it '凡例の位置が右下であること' do
        svg = controller.extract_svg(github_id)
        expect(svg).to include %Q|<text font-family="Helvetica" x="553" y="110">Less</text><g transform="translate(587 , 0)"><rect class="day" width="11" height="11" y="99" fill="#eeeeee"/></g><g transform="translate(602 , 0)"><rect class="day" width="11" height="11" y="99" fill="#d6e685"/></g><g transform="translate(617 , 0)"><rect class="day" width="11" height="11" y="99" fill="#8cc665"/></g><g transform="translate(632 , 0)"><rect class="day" width="11" height="11" y="99" fill="#44a340"/></g><g transform="translate(647 , 0)"><rect class="day" width="11" height="11" y="99" fill="#1e6823"/></g><text font-family="Helvetica" x="666" y="110">More</text>|
      end
    end
  end
end