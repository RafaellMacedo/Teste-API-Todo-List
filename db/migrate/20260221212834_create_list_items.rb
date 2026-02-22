class CreateListItems < ActiveRecord::Migration[8.1]
  def change
    create_table :list_items do |t|
      t.string :titulo
      t.datetime :data

      t.timestamps
    end
  end
end
