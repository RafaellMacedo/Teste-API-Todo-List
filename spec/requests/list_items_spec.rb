require 'rails_helper'

RSpec.describe "Controler List Items API", type: :request do

  before(:each) do
    ListItem.delete_all
  end

  describe "POST /item" do
    it "Store New Items With Dependence Created" do
      titleExpect = "Teste Técnico"
      dateExpect  = "2026-02-21 19:04"

      item_dependencia1 = ListItem.create!(titulo: "item_dependencia1", data: Time.now)
      item_dependencia2 = ListItem.create!(titulo: "item_dependencia2", data: Time.now)
      item_dependencia3 = ListItem.create!(titulo: "item_dependencia3", data: Time.now)

      post "/item",
           params: {
             titulo: titleExpect,
             data: dateExpect,
             dependencias: [
              item_dependencia1.titulo, 
              item_dependencia2.titulo, 
              item_dependencia3.titulo
            ]
           },
           as: :json

      expect(response).to have_http_status(:created)

      item = ListItem.last

      expect(item.titulo).to eq(titleExpect)
      expect(item.data.strftime("%Y-%m-%d %H:%M")).to eq(dateExpect)
      expect(item.items_dependencies.count).to eq(3)
    end

    it "Store New Items without Dependence Created" do
      titleExpect = "Item without dependence"
      dateExpect  = "2026-02-21 19:04"

      post "/item",
           params: {
             titulo: titleExpect,
             data: dateExpect,
             dependencias: []
           },
           as: :json

      expect(response).to have_http_status(:created)

      item = ListItem.last

      expect(item.titulo).to eq(titleExpect)
      expect(item.data.strftime("%Y-%m-%d %H:%M")).to eq(dateExpect)
      expect(item.items_dependencies.count).to eq(0)
    end
  end
  
end

