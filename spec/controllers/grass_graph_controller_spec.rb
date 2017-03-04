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
    let(:fluent_logger) { double(:fluent_logger) }

    before do
      allow(controller).to receive(:tmpfile_path).with(github_id).and_return(dummy_tmpfile)
      allow(Fluent::Logger::TestLogger).to receive(:new).with('knock').and_return(fluent_logger)
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
          expect(fluent_logger).to receive(:post).with('slack', { message: "Grass-Graph Generated!!\nGitHub ID : a-know\nhttps://github.com/a-know" })
          expect(controller).to receive(:upload_gcs).with(github_id, dummy_tmpfile)
          expect(controller.extract_svg(github_id)).to eq File.read('spec/files/expect.svg')
        end

        it '凡例の位置が右下であること' do
          expect(fluent_logger).to receive(:post).with('slack', { message: "Grass-Graph Generated!!\nGitHub ID : a-know\nhttps://github.com/a-know" })
          svg = controller.extract_svg(github_id)
          expect(svg).to include %Q|<text font-family="Helvetica" x="535" y="110">Less</text><g transform="translate(569 , 0)"><rect class="day" width="11" height="11" y="99" fill="#eeeeee"/></g><g transform="translate(584 , 0)"><rect class="day" width="11" height="11" y="99" fill="#d6e685"/></g><g transform="translate(599 , 0)"><rect class="day" width="11" height="11" y="99" fill="#8cc665"/></g><g transform="translate(614 , 0)"><rect class="day" width="11" height="11" y="99" fill="#44a340"/></g><g transform="translate(629 , 0)"><rect class="day" width="11" height="11" y="99" fill="#1e6823"/></g><text font-family="Helvetica" x="648" y="110">More</text>|
        end

        context '不正な GitHub ID が指定されていた場合' do
          let(:github_id)  { '<github_id>' }

          it 'id:a-know として正常処理を行うこと' do
            allow(controller).to receive(:tmpfile_path).with('a-know').and_return(dummy_tmpfile)
            expect(controller).to receive(:upload_gcs).with('a-know', dummy_tmpfile)
            expect(fluent_logger).to receive(:post).with('slack', { message: "Grass-Graph Generated!!\nGitHub ID : <github_id>\nhttps://github.com/<github_id>" })

            svg = controller.extract_svg(github_id)
            expect(svg).to eq File.read('spec/files/expect.svg')
            expect(svg).to include %Q|<text font-family="Helvetica" x="535" y="110">Less</text><g transform="translate(569 , 0)"><rect class="day" width="11" height="11" y="99" fill="#eeeeee"/></g><g transform="translate(584 , 0)"><rect class="day" width="11" height="11" y="99" fill="#d6e685"/></g><g transform="translate(599 , 0)"><rect class="day" width="11" height="11" y="99" fill="#8cc665"/></g><g transform="translate(614 , 0)"><rect class="day" width="11" height="11" y="99" fill="#44a340"/></g><g transform="translate(629 , 0)"><rect class="day" width="11" height="11" y="99" fill="#1e6823"/></g><text font-family="Helvetica" x="648" y="110">More</text>|
          end
        end
      end
    end
  end
end
