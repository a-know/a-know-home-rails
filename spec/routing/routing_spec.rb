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

RSpec.describe 'routing to count subscribers', type: :routing do
  it 'get /blog_metricks/subscribers to blog_metricks#count_subscribers' do
    expect(get: '/blog_metricks/subscribers').
      to route_to(controller: 'blog_metricks', action: 'count_subscribers')
  end
end

RSpec.describe 'routing to count hatena-star', type: :routing do
  it 'get /blog_metricks/hatena_stars to blog_metricks#count_hatena_stars' do
    expect(get: '/blog_metricks/hatena_stars').
      to route_to(controller: 'blog_metricks', action: 'count_hatena_stars')
  end
end

RSpec.describe 'routing to count active visitors', type: :routing do
  it 'get /blog_metricks/active_visitors to blog_metricks#count_active_visitors' do
    expect(get: '/blog_metricks/active_visitors').
      to route_to(controller: 'blog_metricks', action: 'count_active_visitors')
  end
end

