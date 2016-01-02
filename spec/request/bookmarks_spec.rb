require 'rails_helper'

RSpec.describe 'bookmarks', type: :request do
  subject { get '/bookmarks' }

  describe 'GET /bookmarks' do
    it { subject; expect(response.status).to eq 204 }
  end
end
