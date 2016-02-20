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
        expect(controller.extract_svg(github_id)).to match /width="720" height="375"/
      end
    end
  end
end