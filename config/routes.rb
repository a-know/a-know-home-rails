# == Route Map
#
#                    Prefix Verb URI Pattern                          Controller#Action
#                     knock POST /knock(.:format)                     knock#notify
#                 bookmarks GET  /bookmarks(.:format)                 bookmarks#index
#   blog_metricks_bookmarks GET  /blog_metricks/bookmarks(.:format)   blog_metricks#count_bookmarks
# blog_metricks_subscribers GET  /blog_metricks/subscribers(.:format) blog_metricks#count_subscribers
#

Rails.application.routes.draw do
  post 'knock' => 'knock#notify'

  get 'bookmarks' => 'bookmarks#index'

  # collect blog metricks
  get '/blog_metricks/bookmarks' => 'blog_metricks#count_bookmarks'
  get '/blog_metricks/subscribers' => 'blog_metricks#count_subscribers'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
