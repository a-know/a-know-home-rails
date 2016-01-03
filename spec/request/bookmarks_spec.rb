require 'rails_helper'

RSpec.describe 'bookmarks', type: :request do
  subject { get '/bookmarks' }

  describe 'GET /bookmarks' do
    it { subject; expect(response.status).to eq 200 }
    it { subject; expect(response.body).to be_json }
    it { subject; expect(response.body).to be_json_as( entries: nil ) }
  end
end
