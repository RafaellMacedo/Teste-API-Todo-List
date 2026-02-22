class ItemsDependency < ApplicationRecord
  belongs_to :list_item

  belongs_to :depends_on_item,
             class_name: "ListItem",
             foreign_key: "depends_on"
end
