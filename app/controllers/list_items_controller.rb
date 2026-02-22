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

        if list_item
            update_params = params.permit(:titulo_novo, :data_novo).to_h.compact

            item_updated = {}
            item_updated[:titulo] = update_params[:titulo_novo] if update_params.key?(:titulo_novo)
            item_updated[:data]   = update_params[:data_novo] if update_params.key?(:data_novo)

            if item_updated.any?
            list_item.update(item_updated)
            end
            
            render json: list_item, status: :ok
        else
            not_found
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
