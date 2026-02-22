class CreateItemsDependencies < ActiveRecord::Migration[8.1]
  def change
    create_table :items_dependencies do |t|
      t.references :list_item, null: false, foreign_key: true
      t.integer :depends_on

      t.timestamps
    end
  end
end
