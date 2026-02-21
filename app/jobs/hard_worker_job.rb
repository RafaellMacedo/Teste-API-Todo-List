class HardWorkerJob < ApplicationJob
  queue_as :default

  def perform(name)
    Rails.logger.info "Processando #{name}"
  end
end
