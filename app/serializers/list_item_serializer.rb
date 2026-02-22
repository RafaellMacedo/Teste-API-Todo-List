class ListItemSerializer < ActiveModel::Serializer
  attributes :id, :titulo, :data, :dependencias

  def data
    object.data.strftime("%d/%m/%Y")
  end

  def dependencias
    object.items_dependencies.map do |dep|
      {
        id: dep.depends_on,
        titulo: ListItem.find_by(id: dep.depends_on)&.titulo,
        data: ListItem.find_by(id: dep.depends_on)&.data.strftime("%d/%m/%Y")
      }
    end
  end
end
