class ApplicationController < ActionController::API
  rescue_from ActiveRecord::InvalidForeignKey, with: :handle_foreign_key_violation
  
  private
  
  def not_found
    render json: { error: "Registro não encontrado" }, status: :not_found
  end
  
  def not_found_dependences
    render json: { error: "Itens depencencias não encontradas" }, status: :not_found
  end
  
  def required_fields
    render json: { error: "titulo e data são obrigatórios" }, status: :bad_request
  end

  def handle_foreign_key_violation(exception)
    render json: { error: "Não é possível deletar o item porque existem dependências." },
           status: :unprocessable_content
  end
end
