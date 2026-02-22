class ApplicationController < ActionController::API
 
  private
  
  def not_found
    render json: { error: "Registro não encontrado" }, status: :not_found
  end
end
