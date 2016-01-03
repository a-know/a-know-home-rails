# == Route Map
#
#    Prefix Verb URI Pattern          Controller#Action
# bookmarks GET  /bookmarks(.:format) bookmarks#index
#

Rails.application.routes.draw do
  get 'knock' => 'knock#notify'

  get 'bookmarks' => 'bookmarks#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
