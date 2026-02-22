Este projeto foi desenvolvido usando a linguagem Ruby On Rails com o intuíto de resolver o teste técnico

Estas são as tecnologias e suas versões utilizadas para desenvolver este projeto

> Ruby 3.3.1

> PostgresSQl 16

> Redis 7

> sidekiq

> Docker

Para rodar o projeto clone em sua máquina este repositório usando o comando abaixo

> git clone git@github.com:RafaellMacedo/Teste-API-Todo-List.git

Depois acesse a pasta clonada e rode os comandos para buildar o container

docker composer build
docker compose up

Criação das migrations
bundle exec rails g model ListItem titulo:string data:datetime
bundle exec rails g model ItemsDependency listitem:references depends_on:integer
bundle exec rails db:migrate

Para rodar os testes, utilize o seguinte comando, pois, o projeto não esta setando automaticamente o banco de test durante a execução.

> RAILS_ENV=test bundle exec rspec
