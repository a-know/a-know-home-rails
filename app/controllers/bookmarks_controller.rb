class BookmarksController < ActionController::API
  def index
    render json: { entries: nil }
  end
end
