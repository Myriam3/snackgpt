class ApplicationController < ActionController::Base
  # Protect every route by default
  before_action :authenticate_user!

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Redirect after login
  def after_sign_in_path_for(resource)
    profile_path
  end
end
