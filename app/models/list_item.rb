class ListItem < ApplicationRecord
  has_many :items_dependencies, dependent: :destroy

  has_many :dependencies,
           through: :items_dependencies,
           source: :depends_on_item
end
