class ListItemsController < ApplicationController

    def index
        render json: ListItem.filter(params), status: :ok
    end

    def store
        return required_fields unless validate_request

        item = ListItem.new(item_params)

        if item.save
            store_dependencies(item)
            render json: item, status: :created
        else
            render json: item.errors, status: :unprocessable_entity
        end
    end

    def update
        return required_fields unless validate_request

        item = ListItem.findTitleWithDate(params)

        return not_found unless item

        if params[:titulo_novo].present?
            item.update(titulo: params[:titulo_novo])
        end

        if params[:data_novo].present?
            new_date = DateTime.parse(params[:data_novo])
            item.update_date_items_depencies(new_date)
        end

        if params[:dependencias].present?
            return not_found_dependences unless exist_dependences
            item.items_dependencies.destroy_all
            store_dependencies(item)
        end

        render json: item, status: :ok
    end

    def destroy
        return required_fields unless validate_request

        item = ListItem.findTitleWithDate(params)

        return not_found unless item

        if item.destroy
            render json: { message: "Item deletado com sucesso" }, status: :ok
        else
            render json: { error: "Não foi possível deletar o item" }, status: :unprocessable_entity
        end
    end

    private

    def item_params
        params.permit(:titulo, :data)
    end

    def item_params_update
        params.permit(:titulo, :titulo_novo, :data, :data_novo)
    end

    def validate_request
        unless params.permit(:titulo).present? && params.permit(:data).present?
            return false
        end
        return true
    end

    def exist_dependences
        item_dependence_ids = params[:dependencias].map do |dependencia|
            ListItem.find_by(titulo: dependencia)&.id
        end.compact
        item_dependence_ids.present?
    end
    
    def store_dependencies(item)
        return unless params[:dependencias].present?

        params[:dependencias].each do |dependencia|
            dependency_item = ListItem.find_by(titulo: dependencia)
            next unless dependency_item
            
            item.items_dependencies.create(
                depends_on: dependency_item.id
            )
        end
    end
end
