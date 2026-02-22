class ListItemsController < ApplicationController

    def index
        list_items = ListItem.includes(:items_dependencies)

        render json: list_items.as_json(
            include: {
                items_dependencies: {
                    include: {
                        depends_on_item: {
                            only: [:id, :titulo]
                        }
                    }
                }
            }

            ), status: :ok
    end

    def store
        item = ListItem.new(item_params)

        if item.save
            store_dependencies(item)
            render json: item, status: :created
        else
            render json: item.errors, status: :unprocessable_entity
        end
    end

    private

    def item_params
        params.permit(:titulo, :data)
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
