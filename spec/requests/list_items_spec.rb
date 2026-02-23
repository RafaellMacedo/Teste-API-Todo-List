require 'rails_helper'

RSpec.describe "Controler List Items API", type: :request do

  before(:each) do
    ListItem.delete_all
  end

  describe "POST /item when creating an item" do
    it "creates with dependencies" do
      title_expected = "Teste Técnico"
      date_expected  = "2026-02-21 19:04"

      item_dependence1 = ListItem.create!(titulo: "item_dependencia1", data: Time.now)
      item_dependence2 = ListItem.create!(titulo: "item_dependencia2", data: Time.now)
      item_dependence3 = ListItem.create!(titulo: "item_dependencia3", data: Time.now)

      post "/item",
           params: {
             titulo: title_expected,
             data: date_expected,
             dependencias: [
              item_dependence1.titulo, 
              item_dependence2.titulo, 
              item_dependence3.titulo
            ]
           },
           as: :json

      expect(response).to have_http_status(:created)

      item = ListItem.last

      expect(item.titulo).to eq(title_expected)
      expect(item.data.strftime("%Y-%m-%d %H:%M")).to eq(date_expected)
      expect(item.items_dependencies.count).to eq(3)
    end

    it "creates without dependencies" do
      title_expected = "Item without dependence"
      date_expected  = "2026-02-21 19:04"

      post "/item",
           params: {
             titulo: title_expected,
             data: date_expected,
             dependencias: []
           },
           as: :json

      expect(response).to have_http_status(:created)

      item = ListItem.last

      expect(item.titulo).to eq(title_expected)
      expect(item.data.strftime("%Y-%m-%d %H:%M")).to eq(date_expected)
      expect(item.items_dependencies.count).to eq(0)
    end
  end
  
  describe "GET /item" do
    it "returns all items with their dependencies" do
      ListItem.create!(titulo: "Item 1", data: Time.now)
      ListItem.create!(titulo: "Item 2", data: Time.now)
      ListItem.create!(titulo: "Item 3", data: Time.now)
  
      get "/item"
  
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "GET /item?titulo=Tarefa A" do
    it "searches by title" do
      item_title = "Tarefa A"
      title_expected = "Tarefa A"

      ListItem.create!(titulo: item_title, data: Time.now)
      ListItem.create!(titulo: "Item 2", data: Time.now)
  
      get "/item?titulo=" + item_title
  
      expect(response).to have_http_status(:ok)

      response_json = JSON.parse(response.body)

      expect(response_json.first["titulo"]).to eq(title_expected)
    end
  end
  
  describe "GET /item?data=2026-02-22" do
    it "searches by date" do
      item_title = "Tarefa A"
      item_date = Date.parse("2026-02-22").to_datetime
      
      ListItem.create!(titulo: item_title, data: item_date)
      ListItem.create!(titulo: "Tarefa B", data: "2026-02-21")

      title_expected = "Tarefa A"
      date_expected = "22/02/2026"
  
      get "/item?data=" + item_date.to_s
  
      expect(response).to have_http_status(:ok)

      response_json = JSON.parse(response.body)

      expect(response_json.first["titulo"]).to eq(title_expected)
      expect(response_json.first["data"]).to eq(date_expected)
    end
  end
  
  describe "GET /item?titulo=Tarefa A&data=2026-02-22" do
    it "searches by title and date" do
      item_title = "Tarefa A"
      item_date = Date.parse("2026-02-22").to_datetime
      item_date2 = Date.parse("2026-02-23").to_datetime

      ListItem.create!(titulo: item_title, data: item_date)
      ListItem.create!(titulo: item_title, data: item_date2)
      ListItem.create!(titulo: "Tarefa B", data: "2026-02-21")
  
      title_expected = "Tarefa A"
      date_expected = "22/02/2026"

      get "/item?titulo=" + item_title + "&data=" + item_date.to_s
  
      expect(response).to have_http_status(:ok)

      response_json = JSON.parse(response.body)

      expect(response_json.first["titulo"]).to eq(title_expected)
      expect(response_json.first["data"]).to eq(date_expected)
      expect(response_json.first["data"]).not_to eq(item_date2.strftime("%d/%m/%Y"))
    end
  end

  describe "PUT /item" do
    it "does not update the item when it is not found" do
      item_title = "Tarefa A"
      item_date = Time.now
      title_expected = "Tarefa A"

      ListItem.create!(titulo: item_title, data: item_date)
      ListItem.create!(titulo: "Tarefa B", data: Time.now)
  
      get "/item?titulo=" + item_title
  
      expect(response).to have_http_status(:ok)

      response_json = JSON.parse(response.body)
      
      expect(response_json.first["titulo"]).to eq(title_expected)

      item_title_not_exist = "Tarefa Not Exist"
      item_title_change = "Tarefa Alterado Titulo"
      
      put "/item",
           params: {
             titulo: item_title_not_exist,
             data: item_date,
             titulo_novo: item_title_change
           },
           as: :json

      expect(response).to have_http_status(:not_found)
    end

    it "does not update the item when title is missing" do
      item_title = "Tarefa A"
      item_date = Time.now
      title_expected = "Tarefa A"

      ListItem.create!(titulo: item_title, data: item_date)
      ListItem.create!(titulo: "Tarefa B", data: Time.now)
  
      get "/item?titulo=" + item_title
  
      expect(response).to have_http_status(:ok)

      response_json = JSON.parse(response.body)

      expect(response_json.first["titulo"]).to eq(title_expected)

      item_title_not_exist = "Tarefa Not Exist"
      item_title_change = "Tarefa Alterado Titulo"
      
      put "/item",
           params: {
             data: item_date,
             titulo_novo: item_title_change
           },
           as: :json

      expect(response).to have_http_status(:bad_request)
    end

    it "does not update the item when date is missing" do
      item_title = "Tarefa A"
      item_date = Time.now
      title_expected = "Tarefa A"

      ListItem.create!(titulo: item_title, data: item_date)
      ListItem.create!(titulo: "Tarefa B", data: Time.now)
  
      get "/item?titulo=" + item_title
  
      expect(response).to have_http_status(:ok)

      response_json = JSON.parse(response.body)

      expect(response_json.first["titulo"]).to eq(title_expected)

      item_title_not_exist = "Tarefa Not Exist"
      item_title_change = "Tarefa Alterado Titulo"
      
      put "/item",
           params: {
            titulo: item_title,
             titulo_novo: item_title_change
           },
           as: :json

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "PUT /item when updating an item" do
    it "updates the title" do
      item_title = "Tarefa A"
      item_date = Date.parse("2026-02-22").to_datetime
      title_expected = "Tarefa A"

      ListItem.create!(titulo: item_title, data: item_date)
      ListItem.create!(titulo: "Tarefa B", data: Time.now)
  
      get "/item?titulo=" + item_title
  
      expect(response).to have_http_status(:ok)

      response_json = JSON.parse(response.body)
      
      expect(response_json.first["titulo"]).to eq(title_expected)

      item_title_old = response_json.first["titulo"]
      item_title_change = "Tarefa Alterado Titulo"
      
      put "/item",
           params: {
             titulo: item_title,
             data: item_date,
             titulo_novo: item_title_change
           },
           as: :json

      expect(response).to have_http_status(:ok)

      title_expected = "Tarefa Alterado Titulo"

      response_json = JSON.parse(response.body)

      expect(response_json["titulo"]).to eq(title_expected)
      expect(response_json["titulo"]).not_to eq(item_title_old)
    end

    it "updates the date" do
      item_title = "Tarefa A"
      item_date = Date.parse("2026-02-22").to_datetime

      title_expected = "Tarefa A"
      date_expected = "22/02/2026"

      ListItem.create!(titulo: item_title, data: item_date)
      ListItem.create!(titulo: "Tarefa B", data: Time.now)
  
      get "/item?titulo=" + item_title
  
      expect(response).to have_http_status(:ok)
      response_json = JSON.parse(response.body)
      expect(response_json.first["titulo"]).to eq(title_expected)
      expect(response_json.first["data"]).to eq(date_expected)

      item_date_old = response_json.first["data"]
      item_date_change = Date.parse("2026-02-23").to_datetime
      
      put "/item",
           params: {
             titulo: item_title,
             data: item_date,
             data_novo: item_date_change
           },
           as: :json

      expect(response).to have_http_status(:ok)

      date_expected = "23/02/2026"

      response_json = JSON.parse(response.body)

      expect(response_json["data"]).to eq(date_expected)
      expect(response_json["data"]).not_to eq(item_date_old)
    end

    it "updates dependencies" do
      item_titleA = "Tarefa A"
      item_titleB = "Tarefa B"
      item_dateA = Date.parse("2026-10-20").to_datetime
      item_dateB = Date.parse("2026-10-21").to_datetime

      list_itemA = ListItem.create!(titulo: item_titleA, data: item_dateA)
      list_itemB = ListItem.create!(titulo: item_titleB, data: item_dateB)

      list_itemA.items_dependencies.create(depends_on: list_itemB.id)
  
      item_dateA_change = Date.parse("2026-10-25").to_datetime
      
      put "/item",
           params: {
             titulo: item_titleA,
             data: item_dateA,
             data_novo: item_dateA_change
           },
           as: :json

      expect(response).to have_http_status(:ok)

      dateA_expected = "25/10/2026"
      dateB_expected = "26/10/2026"

      response_json = JSON.parse(response.body)

      expect(response_json["data"]).to eq(dateA_expected)
      expect(response_json["data"]).not_to eq(item_dateA_change)
      expect(response_json["dependencias"].first["data"]).to eq(dateB_expected)
    end
  end

  describe "PUT /item" do
    it "updates dependencies when the item is found" do
      item_titleA = "Tarefa A"
      item_titleB = "Tarefa B"
      item_titleC = "Tarefa C"
      item_dateA = Date.parse("2026-10-20").to_datetime
      item_dateB = Date.parse("2026-10-21").to_datetime
      item_dateC = Date.parse("2026-10-21").to_datetime

      list_itemA = ListItem.create!(titulo: item_titleA, data: item_dateA)
      list_itemB = ListItem.create!(titulo: item_titleB, data: item_dateB)
      ListItem.create!(titulo: item_titleC, data: item_dateC)

      list_itemA.items_dependencies.create(depends_on: list_itemB.id)
  
      item_dateA_change = Date.parse("2026-10-25").to_datetime
      
      put "/item",
           params: {
             titulo: item_titleA,
             data: item_dateA,
             dependencias: [
              item_titleC
            ]
           },
           as: :json

      expect(response).to have_http_status(:ok)

      titleA_expected = "Tarefa A"
      titleC_expected = "Tarefa C"
      dateC_expected = "21/10/2026"

      response_json = JSON.parse(response.body)

      expect(response_json["titulo"]).to eq(titleA_expected)
      expect(response_json["dependencias"].first["titulo"]).to eq(titleC_expected)
      expect(response_json["dependencias"].first["data"]).to eq(dateC_expected)
    end
  end

  describe "PUT /item when dependencies are invalid" do
    it "does not update dependencies" do
      item_titleA = "Tarefa A"
      item_titleB = "Tarefa B"
      item_titleC = "Tarefa C"
      item_dateA = Date.parse("2026-10-20").to_datetime
      item_dateB = Date.parse("2026-10-21").to_datetime

      list_itemA = ListItem.create!(titulo: item_titleA, data: item_dateA)
      list_itemB = ListItem.create!(titulo: item_titleB, data: item_dateB)

      list_itemA.items_dependencies.create(depends_on: list_itemB.id)
  
      item_dateA_change = Date.parse("2026-10-25").to_datetime
      
      put "/item",
           params: {
             titulo: item_titleA,
             data: item_dateA,
             dependencias: [
              item_titleC
            ]
           },
           as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /item" do
    it "deletes an item without dependencies" do
      item_title = "Tarefa A"
      item_date = Date.parse("2026-10-20").to_datetime

      ListItem.create!(titulo: item_title, data: item_date)
      
      delete "/item",
           params: {
             titulo: item_title,
             data: item_date
           },
           as: :json

      expect(response).to have_http_status(:ok)
    end

    it "deletes an item with dependencies" do
      item_titleA = "Tarefa A"
      item_titleB = "Tarefa B"
      item_dateA = Date.parse("2026-10-20").to_datetime
      item_dateB = Date.parse("2026-10-21").to_datetime

      list_itemA = ListItem.create!(titulo: item_titleA, data: item_dateA)
      list_itemB = ListItem.create!(titulo: item_titleB, data: item_dateB)

      list_itemA.items_dependencies.create(depends_on: list_itemB.id)
      
      delete "/item",
           params: {
             titulo: item_titleA,
             data: item_dateA
           },
           as: :json

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
  
end

