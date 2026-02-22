class ApplicationController < ActionController::API
 
  private
  
  def not_found
    render json: { error: "Registro não encontrado" }, status: :not_found
  end
  
  
  def required_fields
    render json: { error: "titulo e data são obrigatórios" }, status: :bad_request
  end
end
