require 'rails_helper'

RSpec.describe 'routing to bookmarks', type: :routing do
  it 'get /bookmarks to bookmarks#index' do
    expect(get: '/bookmarks').
      to route_to(controller: 'bookmarks', action: 'index')
  end
end

RSpec.describe 'routing to knock', type: :routing do
  it 'post /knock to knock#notify' do
    expect(post: '/knock').
      to route_to(controller: 'knock', action: 'notify')
  end
end

RSpec.describe 'routing to count bookmarks', type: :routing do
  it 'get /blog_metricks/bookmarks to blog_metricks#count_bookmarks' do
    expect(get: '/blog_metricks/bookmarks').
      to route_to(controller: 'blog_metricks', action: 'count_bookmarks')
  end
end

