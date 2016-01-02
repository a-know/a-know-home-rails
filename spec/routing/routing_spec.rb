require 'rails_helper'

RSpec.describe 'routing to bookmarks', type: :routing do
  it 'get /bookmarks to bookmarks#index' do
    expect(get: '/bookmarks').
      to route_to(controller: 'bookmarks', action: 'index', format: 'json')
  end
end
