class ListItem < ApplicationRecord
  has_many :items_dependencies, dependent: :destroy

  has_many :dependencies,
           through: :items_dependencies,
           source: :depends_on_item

  def self.filter(params)
    list_item = includes(:dependencies)
    list_item = list_item.where(titulo: params[:titulo]) if params[:titulo].present?
    list_item = list_item.where(data: params[:data].to_date) if params[:data].present?
    list_item
  end
end
