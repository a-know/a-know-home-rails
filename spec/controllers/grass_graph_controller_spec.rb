# encoding: utf-8

require 'rails_helper'

RSpec.describe GrassGraphController do
  let(:controller) { described_class.new }
  let(:github_id)  { 'a-know' }
  describe '#extract_svg' do
    it 'public contributions のグラフを svg 形式でファイルに出力したものの内容を返す' do
      expect(controller.extract_svg(github_id)).to eq File.read('tmp/gg_svg/a-know_2016-02-14.svg')
    end
  end
end