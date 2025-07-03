class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::RoutingError, with: :render_not_found

  def not_found
    render_not_found
  end

  private

  def render_not_found
    render template: "errors/not_found", status: :not_found
  end
end
