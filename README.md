# Chat Dev-jr Voll
  Boas vindas ao Chat Voll, o site onde você pode se registrar e conversar com outras pessoas em tempo real!

## Objetivo

Desenvolver uma aplicação para troca de mensagens utilizando Rails no backend e Vue.js no frontend.

## Como rodar a aplicação no computador:

#### Seu computador precisa de Git (para versionamento do código), Ruby On Rails, Redis, Node.js, Vue & npm (para executar a aplicação) e PostgreSQL (que será nosso banco de dados). Clique nos links, caso ainda não tenha instalado algum desses:

 - [ ] [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
 - [ ] [Vue](https://br.vuejs.org/v2/guide/installation.html)
 - [ ] [Ruby](https://www.ruby-lang.org/pt/documentation/installation/)
 - [ ] [Rails](https://guides.rubyonrails.org/v5.0/getting_started.html)
 - [ ] [Redis](https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/)
 - [ ] [Node.js e npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)

 - O **PostgreSQL** precisa estar ativo para que a aplicação funcione, rodando local ou docker.

## Instalando a aplicação:

 1. Primeiro, abra um novo terminal e clone o repositório utilizando o comando 
 `git clone git@github.com:DanielDaher/chat-dev-jr-voll.git`

 2. Em seguida, digite `cd chat-dev-jr-voll` para entrar no diretório (pasta) do projeto, que acabou de ser criada.

 3. Vá para a pasta do Backend, rodando `cd backend-api` no terminal, e execute `bundle install` para instalar as dependências necessárias.

 4. Crie, dentro da pasta `backend-api`, um arquivo com o nome `.env` e coloque as mesmas variáveis do arquivo .env.example desta pasta. Siga as orientações dele, ajustando usuário, senha e etc. 
  Salve as modificações!

 5. Execute, no terminal, o comando `rails db:drop db:create db:migrate dev:setup`. Isso irá resetar ou criar o banco de dados, populando-o com alguns exemplos de usuários e mensagens.
 
 6. Com o comando `rails s`, o backend da aplicação já estará funcionando. Aguarde alguns segundos, que o terminal mostrará a mensagem "Listening on http://127.0.0.1:3000", ou algo similar, que significa que está tudo certo. Lembrando que, para executar este passo é necessário que seu **PostgreSQL** esteja ativo.

 7. Abra outro terminal (para não interromper o backend, que deve continuar rodando), se mantendo na mesma pasta (backend-api) e execute `redis-server`, para ativar o redis. Se estiver tudo certo, ele exibirá, dentre outras mensagens, o texto "Ready to accept connections tcp".

 8. Abra outro terminal (para não interromper o redis, que deve continuar rodando), se mantendo na mesma pasta (backend-api) e execute `bundle exec sidekiq`, para ativar o sidekiq. Se estiver tudo certo, ele exibirá, dentre outras mensagens, o texto "Starting processing, hit Ctrl-C to stop".

 9. Abra outro terminal (para não interromper o sidekiq, que deve continuar rodando), mas agora é necessário SAIR da pasta backend-api e acessar a pasta "frontend-chat-voll". Faça isso com o comando `cd../frontend-chat-voll`.

 10. Agora, neste terminal da pasta frontend, execute `npm install` para instalar as dependências necessárias do Vue. Em seguida, crie dentro desta pasta, mais um arquivo com o nome `.env` e coloque as mesmas variáveis do arquivo .env.example desta pasta. Ajuste as variáveis que representam tanto a url da API backend, quanto a do websocket (pode manter as mesmas do arquivo .env.example e, se necessário, depois ajuste).

 11. Em seguida, volte ao terminal e execute o comando `npm run serve`, que irá colocar no ar o frontend da aplicação. Se este comando funcionar, você verá essa mensagem "Local:   http://localhost:8080/", que é a url do frontend. 

 12. Abra outro terminal (para não interromper o frontend, que deve continuar rodando), mas agora é necessário SAIR da pasta frontend-chat-voll e acessar a pasta "websocket-server". Faça isso com o comando `cd../websocket-server`.

 13. Instale as dependências da pasta websocket-server com `npm install`

 14. Agora, crie dentro desta pasta, mais um arquivo com o nome `.env` e coloque as mesmas variáveis do arquivo .env.example desta pasta. Ajuste as variáveis que representam tanto a url de frontend, quanto a do backend (você pode obte-las nos devidos terminais em que estes serviços estão rodando).

 15. Em seguida, execute o comando `npm run start` para ativar o servidor websocket. 


 16. Agora  você pode abrir seu navegador e digitar a url http://localhost:8080.

 17. E agora é só desfrutar do site!

## Tecnologias Utilizadas:

  1. Backend: A maior parte da API foi feita utilizando Ruby On Rails, contando com várias gems, tais como "bcrypt", "jwt", "sidekiq", "redis" e "faker". Respectivamente, estas gems tratam de criptografar senha, autenticar usuários, processar mensagens de forma assíncrona e, por último, popular o banco de dados com exemplos genéricos.

  2. Backend (parte2): A outra parte do backend foi feita utilizando um micro-serviço em Node.js. Esta partição ficou responsável por lidar com os websockets recebidos do frontend, e acionar o sidekiq (da API Rails citada anteriormente) para que as mensagens sejam cadastradas de forma assíncrona no banco de dados. O objetivo disto é criar uma fila de tarefas, para não sobrecarregar o sistema.

  3. Frontend: O frontend foi feito utilizando Vue.js, contando com várias bibliotecas deste framework, tais como "axios", "bulma", "socket.io" e "sweet-alert". Respectivamente, estas libs tratam de fazer requisições ao backend, estilizar os componentes com um css mais refinado, lidar com envio e recepção de mensagens em tempo real, e, por último, alertar o usuário (de forma sutil) de ações que não funcionaram (por exemplo, ao tentar cadastrar um usuário que já existe).

## Diferenciais implementados:

  - Comunicação em tempo real via WebSocket [✅]
  - Suporte ao envio de arquivos (permitindo anexos como imagens e documentos pequenos) [✅] 
  - Implementação de paginação na listagem de mensagens para melhor desempenho [✅] 
  - Mecanismo de autenticação (por exemplo, JWT) para garantir segurança nas requisições [✅]
  - Criação de um endpoint de métricas [❌] 
  - Processamento assíncrono de mensagens utilizando fila de tarefas (exemplo: Redis + Sidekiq) [✅] 


## Outras funcionalidades implementadas:

  - Login e Submit com username e senha: É possível fazer login na aplicação com usuário e senha. Caso não saiba nenhum, pode criar um novo marcando o checkbox da tela de login.

  - Logout: uma vez logado, o sistema te redireciona para a página de dashboard, que apresenta um botão "Sair", uma lista de contatos e o chat. É possível fazer logout clicando no botão "Sair", e então o sistema redireciona novamente para a tela de login.

  - Iniciar conversa: Caso não tenha nenhum contato ainda, é possível iniciar uma nova conversa. Basta preencher o input com o nome do usuário, e apertar enter (ou clicar em "iniciar conversa"). Ao efetuar esta ação, o sistema buscará por um usuário com o valor digitado, sendo que, os nomes, neste aplicação, são únicos. Caso encontre algum, o chat permitirá que novas mensagens sejam enviadas. Caso não encontre, então um alerta sutil aparece na tela, informando que o usuário não foi encontrado.

  - Lista de contatos (conversas): A lista de contatos apresenta todos os usuários com quem você interagiu. Ao clicar em um deles, o chat apresenta o histórico da conversa e o input para enviar novas mensagens (ou arquivos). Além disso, o contato selecionado apresenta uma cor de fundo diferente, para facilitar o entendimento de com quem se está conversando.

  - Notificações: Ao receber uma nova mensagem, aparecem três exclamações (!!!) próximas ao nome do contato que as enviou. Clicando na conversa, a notificação some.

  - Enviar: Uma vez que o chat está aberto, é possível enviar mensagens de texto ou arquivos. Os arquivos são exibidos com o link "Abrir Mídia", que abrirá o link do arquivo em uma nova aba do navegador.

  - Buscar mais mensagens: O chat sempre busca as últimas 30 mensagens de uma conversa (pois o backend está sempre paginando, para não sobrecarregar a resposta). Porém, quando já existem 30 mensagens apresentadas na tela, aparece o botão "Buscar mais mensagens". Clicando nele, o sistema parte para a próxima página da paginação, buscando 30 mensagens anteriores a estas. É possível buscar infinitamente, clicando no botão. Caso todas as mensagens já estejam na tela, o botão continua funcionando, mas seu retorno é vazio.

  - Scroll To Top/Bottom: Sempre que um chat abre, ou uma mensagem nova chega no mesmo, o scroll da página vai para o ponto mais baixo possível, permitindo que o conteúdo mais recente seja lido. Porém, caso o botão "Buscar mais mensagens" seja acionado, acontece o oposto. O scroll vai para o ponto mais acima possível, exibindo o conteúdo mais antigo da conversa.