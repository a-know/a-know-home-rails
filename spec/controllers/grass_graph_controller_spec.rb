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
    end
  end
end