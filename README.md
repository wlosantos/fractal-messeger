# Api de Mensagens

### Pré-requisitos
- Ruby '3.2.2'
- Bundler '2.4.14'
- Docker
- Ter a porta 3000 livre (rails)
- Ter a porta 5433 livre (postgres)
- Ter a porta 6378 livre (redis)

### Execução
- usando o docker

  execute o comando: `docker-compose up` para iniciar o projeto; <br />
  execute o comando: `docker-compose down` para fechar o projeto;

#### Criar o banco de dados (apenas na primeira vez)
- execute o comando: `rails db:setup`

#### Executar migração (quando necessário)
- execute o comando: `rails db:migrate`

### Iniciar a aplicação
- executar o comando: `rails server -b 0.0.0.0 -p 3000`

### Conexão
* Para acesso é necessário um cadastro válido da empresa 'url/registrations' com os dados:
  
  ```json
  {
	"user_application_id": 30,
	"user_application_name": "Bertoni",
	"datagateway_token": "be36a42b8c-c8a5e54d47-1685540843",
	"url": "https://staging.datagateway.fractaltecnologia.com.br"
  }
  ```
  - A url é a base de onde será feito a verificação do fractal_id válido. Como exemplo estou usando o staging, por isso é necessário que seja adicionado um datagateway_token existente no servidor.
 
* Para acessar o sistema é só criar uma nova session 'url/sessions' com os dodos:
  ```json
  {
	"email": "usuario@user.client@appfractal.com",
	"fractal_id": "30021"
  }
  ```
- Este acesso irá gerar um token de acesso ao serviço de mensagem
 
* Documentação da API
  url: <a href="https://walrus-app-odsyu.ondigitalocean.app/api-docs/index.html" target="_blank">Doc messeger swagger</a>

![alt Swagger docs](https://github.com/wlosantos/fractal-messeger/blob/develop/public/swagger.png)

* Para fazer os teste de endpoint use o app  <a href="https://insomnia.rest/download" target="_blank">Insomnia</a>
- segue a collection do Insomnia para teste: <a href="https://github.com/wlosantos/fractal-messeger/blob/develop/public/Insomnia_collection-fractal_messeger.json" target="_blank">Json para importar no Insomnia</a>

![alt Insomnia docs](https://github.com/wlosantos/fractal-messeger/blob/develop/public/insomnia.png)

* O sistema está usando o Rspec:
![alt Insomnia docs](https://github.com/wlosantos/fractal-messeger/blob/develop/public/test-rspec.png)
