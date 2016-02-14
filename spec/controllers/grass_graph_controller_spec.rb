# encoding: utf-8

require 'rails_helper'

RSpec.describe GrassGraphController do
  let(:controller) { described_class.new }
  let(:github_id)  { 'a-know' }

  before do
    Dir.mkdir('tmp/spec') unless File.exists?('tmp/spec')
    File.delete('tmp/spec/test.svg') if File.exists?('tmp/spec/test.svg')
  end

  after { File.delete('tmp/spec/test.svg') if File.exists?('tmp/spec/test.svg') }

  describe '#extract_svg' do
    before do
      allow(controller).to receive(:tmpfile_path).with(github_id).and_return('tmp/spec/test.svg')
    end

    context 'svg 抽出済みのファイルが既に存在する場合' do
      before { FileUtils.copy('spec/files/extracted.svg', 'tmp/spec/test.svg') unless File.exists?('tmp/spec/test.svg') }

      it 'public contributions のグラフを svg 形式でファイルに出力したもの（既に存在するもの）の内容を返す' do
        expect(controller.extract_svg(github_id)).to eq File.read('spec/files/expect.svg')
      end
    end

    context 'svg 抽出済みのファイルがまだ存在しない場合' do
      it 'public contributions のグラフを svg 形式でファイルに出力したもの（今回新たに取得したもの）の内容を返す' do
        expect(controller.extract_svg(github_id)).to eq File.read('spec/files/expect.svg')
      end
    end
  end
end