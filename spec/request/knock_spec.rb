require 'rails_helper'

RSpec.describe '/knock', type: :request do
  describe 'POST /knock' do
    let(:path) { "/knock" }
    let(:fluent_logger) { double(:fluent_logger) }

    subject { post path }

    before do
      allow(Fluent::Logger::TestLogger).to receive(:new).with('knock').and_return(fluent_logger)
    end

    it '204' do
      expect(fluent_logger).to receive(:post).with('slack', { message: "Visitor Incoming!!" })
      subject
      expect(response.status).to eq 204
    end
  end
end