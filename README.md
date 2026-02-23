# Teste API Todo List

Este projeto foi desenvolvido usando Ruby on Rails com o intuito de resolver o teste técnico.

Tecnologias utilizadas

| Tecnologia | Versão |
| ---------- | ------ |
| Ruby       | 3.3.1  |
| PostgreSQL | 16     |
| Redis      | 7      |
| Sidekiq    | -      |
| Docker     | -      |


# Setup do projeto

Clone o repositório

```
git clone git@github.com:RafaellMacedo/Teste-API-Todo-List.git
```

Acesse a pasta do projeto e build o container:

```
docker composer build
docker compose up
```

Entre no container da aplicação para criar o banco de dados e rodar os testes:

```
docker compose exec web bash
```

Criar os bancos

```
bundle exec rails db:create
```

Rodar as migrations

```
bundle exec rails db:migrate
```

Rodar os testes`
>Como o projeto não seta automaticamente o banco de teste, rode:

```
RAILS_ENV=test bundle exec rspec
```

# Desenvolvimento da API

O desenvolvimento foi feito por etapas, criando issues no repositório e trabalhando em branches específicas:

| Issue          | Pull Request                                                           |
| -------------- | ---------------------------------------------------------------------- |
| Criar item     | [PR #7](https://github.com/RafaellMacedo/Teste-API-Todo-List/pull/7)   |
| Listar itens   | [PR #11](https://github.com/RafaellMacedo/Teste-API-Todo-List/pull/11) |
| Atualizar item | [PR #14](https://github.com/RafaellMacedo/Teste-API-Todo-List/pull/14) |
| Excluir item   | [PR #16](https://github.com/RafaellMacedo/Teste-API-Todo-List/pull/16) |

# Rotas da API

A URL base após subir o container é: http://localhost:3000

## GET /item

Lista todos os itens ou filtra por título e/ou data.

Parâmetros opcionais:
- `titulo`
- `data` (formato `YYYY-MM-DD`)

> Exemplos:

```
/item
```
```
/item?titulo=Tarefa
```
```
/item?titulo=Tarefa&data=2026-02-22
```

> Response

```
{
    {
        "id": 3,
        "titulo": "Tarefa B",
        "data": "20/10/2026",
        "dependencias": []
    },
    {
        "id": 4,
        "titulo": "Tarefa A",
        "data": "20/10/2026",
        "dependencias": [
            {
                "id": 3,
                "titulo": "Tarefa B",
                "data": "20/10/2026"
            }
        ]
    }
}
```

## POST /item

Cria um novo item. Campos obrigatórios: `titulo` e `data`.

Dependências podem ser enviadas como array de títulos.

> Body

```
{
    "titulo": "Tarefa A",
    "data": "20/10/2026",
    "dependencias": [
        "Tarefa B"
    ]
}
```

> Response

```
{
    "id": 4,
    "titulo": "Tarefa A",
    "data": "20/10/2026",
    "dependencias": [
        {
            "id": 3,
            "titulo": "Tarefa B",
            "data": "20/10/2026"
        }
    ]
}
```

## PUT /item

Altera campos `titulo` e `data` de um item.
- Campos obrigatórios para identificar o item: `titulo` e `data`.
- Campos opcionais para alteração: `titulo_novo`, `data_novo`.
- Se houver dependentes e a data for alterada, suas datas também são atualizadas recursivamente.
- É possível atualizar a dependência de um item, substituindo-a por outro item. A seguir, um exemplo de requisição

> Body

```
{
    "titulo": "Tarefa B",
    "titulo_novo": "Tarefa C",
    "data": "21/10/2026",
    "data_novo": "25/10/2026"
}
```

> Response

```
{
    "id": 3,
    "titulo": "Tarefa C",
    "data": "25/10/2026",
    "dependencias": []
}
```

> Exemplo de alteração de item com dependente

```
{
    "titulo": "Tarefa A",
    "data": "20/10/2026",
    "data_novo": "25/10/2026"
}
```

> Response

```
{
    "id": 6,
    "titulo": "Tarefa A",
    "data": "25/10/2026",
    "dependencias": [
        {
            "id": 5,
            "titulo": "Tarefa B",
            "data": "26/10/2026"
        }
    ]
}
```

> Exemplo de alteração de item dependente

```
{
    "titulo": "Tarefa A",
    "data": "20/10/2026",
    "dependencias": [
        "Tarefa C"
    ]
}
```

> Response

```
{
    "id": 6,
    "titulo": "Tarefa A",
    "data": "25/10/2026",
    "dependencias": [
        {
            "id": 5,
            "titulo": "Tarefa C",
            "data": "21/10/2026"
        }
    ]
}
```

## DELETE /item

Deleta um item. Primeiro é necessário deletar dependentes, depois o item principal.

Campos obrigatórios: `titulo` e `data`.

> Body

```
{
    "titulo": "Tarefa D",
    "data": "20/10/2026"
}
```

> Response

```
{
    "message": "Item deletado com sucesso"
}
```
