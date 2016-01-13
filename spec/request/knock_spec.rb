require 'rails_helper'

RSpec.describe '/knock', type: :request do
  describe 'POST /knock' do
    let(:path) { "/knock" }
    let(:fluent_logger) { double(:fluent_logger) }

    before do
      allow(Fluent::Logger::TestLogger).to receive(:new).with('knock').and_return(fluent_logger)
    end

    subject { post path, params }

    context 'not specified admin=true' do
      let(:params) do
        {
          user_agent: 'USER_AGENT_STRING',
          language: 'LANGUAGE_STRING',
        }
      end

      it '204' do
        expect(fluent_logger).to receive(:post).with('slack', { message: "Visitor Incoming!!\nUA : USER_AGENT_STRING\nLanguage : LANGUAGE_STRING" })
        subject
        expect(response.status).to eq 204
      end
    end

    context 'specified admin=true' do
      let(:params) do
        {
          user_agent: 'USER_AGENT_STRING',
          language: 'LANGUAGE_STRING',
          admin: true,
        }
      end

      it 'should not post fluent_logger' do
        expect(fluent_logger).to_not receive(:post)
        subject
      end
    end
  end
end