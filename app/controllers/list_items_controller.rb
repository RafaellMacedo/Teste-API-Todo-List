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

        list_item = ListItem.findTitleWithDate(params)

        return not_found unless list_item

        if params[:titulo_novo].present?
            list_item.update(titulo: params[:titulo_novo])
        end

        if params[:data_novo].present?
            new_date = DateTime.parse(params[:data_novo])
            list_item.update_date_items_depencies(new_date)
        end

        render json: list_item, status: :ok
    end

    def destroy
        return required_fields unless validate_request

        list_item = ListItem.findTitleWithDate(params)

        return not_found unless list_item

        if list_item.destroy
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
