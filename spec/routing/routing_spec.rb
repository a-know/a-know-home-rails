require 'rails_helper'

RSpec.describe 'Routes', type: :routing do
  describe 'for a-know-home routes' do
    it 'get /bookmarks to bookmarks#index' do
      expect(get: '/bookmarks').
        to route_to(controller: 'bookmarks', action: 'index')
    end

    it 'post /knock to knock#notify' do
      expect(post: '/knock').
        to route_to(controller: 'knock', action: 'notify')
    end
  end

  describe 'for blog-metricks' do
    it 'get /blog_metricks/bookmarks to blog_metricks#count_bookmarks' do
      expect(get: '/blog_metricks/bookmarks').
        to route_to(controller: 'blog_metricks', action: 'count_bookmarks')
    end

    it 'get /blog_metricks/subscribers to blog_metricks#count_subscribers' do
      expect(get: '/blog_metricks/subscribers').
        to route_to(controller: 'blog_metricks', action: 'count_subscribers')
    end

    it 'get /blog_metricks/hatena_stars to blog_metricks#count_hatena_stars' do
      expect(get: '/blog_metricks/hatena_stars').
        to route_to(controller: 'blog_metricks', action: 'count_hatena_stars')
    end

    it 'get /blog_metricks/active_visitors to blog_metricks#count_active_visitors' do
      expect(get: '/blog_metricks/active_visitors').
        to route_to(controller: 'blog_metricks', action: 'count_active_visitors')
    end
  end

  describe 'for a-know-metricks' do
    it 'get /a_know_metricks/steps to activity_metricks#collect_steps' do
      expect(get: '/a_know_metricks/steps').
        to route_to(controller: 'activity_metricks', action: 'collect_steps')
    end
  end

  describe 'for my grass-graph' do
    it 'get /grass-graph to grass-graph#show' do
      expect(get: '/grass-graph').
        to route_to(controller: 'grass_graph', action: 'show')
    end
  end

  describe 'for grass-graph service' do
    let(:github_id) { 'a-know' }
    it 'get /images/:github_id to grass-graph#service' do
      expect(get: "/images/#{github_id}").
        to route_to(controller: 'grass_graph', action: 'service', github_id: 'a-know')
    end
  end
end
