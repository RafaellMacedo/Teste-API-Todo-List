class CreateItemsDependencies < ActiveRecord::Migration[7.0]
  def change
    create_table :items_dependencies do |t|
      t.references :list_item, null: false, foreign_key: { to_table: :list_items, on_delete: :cascade }
      t.references :depends_on, null: false, foreign_key: { to_table: :list_items, on_delete: :cascade }

      t.timestamps
    end
  end
end
