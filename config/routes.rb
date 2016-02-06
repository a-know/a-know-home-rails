# == Route Map
#
#                        Prefix Verb URI Pattern                              Controller#Action
#                         knock POST /knock(.:format)                         knock#notify
#                     bookmarks GET  /bookmarks(.:format)                     bookmarks#index
#       blog_metricks_bookmarks GET  /blog_metricks/bookmarks(.:format)       blog_metricks#count_bookmarks
#     blog_metricks_subscribers GET  /blog_metricks/subscribers(.:format)     blog_metricks#count_subscribers
#    blog_metricks_hatena_stars GET  /blog_metricks/hatena_stars(.:format)    blog_metricks#count_hatena_stars
# blog_metricks_active_visitors GET  /blog_metricks/active_visitors(.:format) blog_metricks#count_active_visitors
#         a_know_metricks_steps GET  /a_know_metricks/steps(.:format)         activity_metricks#collect_steps
#

Rails.application.routes.draw do
  post 'knock' => 'knock#notify'

  get 'bookmarks' => 'bookmarks#index'

  # collect blog metricks
  get '/blog_metricks/bookmarks' => 'blog_metricks#count_bookmarks'
  get '/blog_metricks/subscribers' => 'blog_metricks#count_subscribers'
  get '/blog_metricks/hatena_stars' => 'blog_metricks#count_hatena_stars'
  get '/blog_metricks/active_visitors' => 'blog_metricks#count_active_visitors'

  # collect a-know metricks
  get '/a_know_metricks/steps' => 'activity_metricks#collect_steps'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
