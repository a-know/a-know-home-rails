require 'rails_helper'

RSpec.describe '/heartbeat', type: :request do
  describe 'POST /heartbeat' do
    let(:path) { "/heartbeat" }

    subject { get path }

    it '200 ok' do
      subject
      expect(response.status).to eq 200
      expect(response.body).to   eq 'OK'
    end
  end
end