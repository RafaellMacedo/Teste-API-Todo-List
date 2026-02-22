class ListItem < ApplicationRecord
  validates :titulo, presence: true
  validates :data, presence: true

  has_many :items_dependencies, foreign_key: :list_item_id

  has_many :dependencies,
           through: :items_dependencies,
           source: :depends_on_item

  def self.filter(params)
    list_item = includes(:dependencies)
    list_item = list_item.where(titulo: params[:titulo]) if params[:titulo].present?
    list_item = list_item.where(data: params[:data].to_date) if params[:data].present?
    list_item
  end

  def self.findTitleWithDate(params)
    list_item = includes(:dependencies)
    list_item.find_by(titulo: params[:titulo],data: params[:data].to_date)
  end
  
  def update_date_items_depencies(new_date)
    list_item_old_date = self.data
    self.update(data: new_date)

    diff_in_days = (new_date.to_date - list_item_old_date.to_date).to_i

    items_dependencies.each do |dependencie|
      dependencie_item = dependencie.depends_on_item
      next unless dependencie_item
      dependencie_item.update_date_items_depencies(dependencie_item.data + diff_in_days.days)
    end
  end
end
