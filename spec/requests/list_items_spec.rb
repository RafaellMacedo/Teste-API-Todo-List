require 'rails_helper'

RSpec.describe "Controler List Items API", type: :request do

  before(:each) do
    ListItem.delete_all
  end

  describe "POST /item" do
    it "Store New Items With Dependence Created" do
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

    it "Store New Items without Dependence Created" do
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
    it "Return all items with your dependencies" do
      ListItem.create!(titulo: "Item 1", data: Time.now)
      ListItem.create!(titulo: "Item 2", data: Time.now)
      ListItem.create!(titulo: "Item 3", data: Time.now)
  
      get "/item"
  
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "GET /item?titulo=Tarefa A" do
    it "Search the title" do
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
    it "Search the date" do
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
    it "Search using title and date" do
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
    it "Not change item because item not found" do
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
  end

  describe "PUT /item" do
    it "Not change item when not send title in request" do
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
  end

  describe "PUT /item" do
    it "Not change item when not send date in request" do
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

  describe "PUT /item" do
    it "Change the title" do
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
  end
  
end

