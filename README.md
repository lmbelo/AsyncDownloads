# AsyncDownloads

<p><b>Aplicação cliente/servidor para gerenciar downloads simultâneos.</b></p>

<h3>Banco de dados</h3>
Ao inicializar a aplicação, o sistema verificará a presença do arquivo de banco de dados no diretório padrão. Caso o arquivo não exista, um novo arquivo será criado. Em seguida, os scripts serão executados.

O caminho padrão e o nome do arquivo de banco de dados estão informados a seguir:
 - C:\Users\\<seu_usuario>\Documents\Desafio\Database\DESAFIO.s3db

<h3>Servidor</h3>

A aplicação servidora recebe a notificação de um novo download solicitado pela aplicação cliente e a persiste no banco de dados.

A aplicação servidora recebe uma solicitação de busca de histório de download, realiza a busca no banco de dados e faz o marshalling e serialização dos dados para retornar a consulta.

  * Nota: a aplicação servidora apresenta algumas limitações por conta do banco de dados SQLite. Porém, requisições assíncronas estão sendo gerenciadas.

<h3>Cliente</h3>

A aplicação cliente pode ser compilada para várias plataformas, como: win, mac, ios, android e linux. Apenas o objeto fonte para windows será fornecido junto ao projeto
 - desafio\server\Win32\Release\server.exe
 - desafio\client\Win32\Release\client.exe

A aplicação cliente recebe uma solicitação de download através do botão superior no menu "+". O usuário deverá informar o link para download. Ao confirmar o link, o download será colocado na lista de downloads.
 - Neste momento, será enviado para a aplicação servidora uma requisição para registrar uma nova solicitação de download. Assim que finalizado, outra solicitação de finalização de download será enviada para o servidor, registrando o término do download.
A aplicação cliente mantêm uma lista na tela principal para exibir os últimos downloads solicitados. O usuário poderá acompanhar o progresso.

* Nota: o tamanho da url não poderá ultrapassar 600 caracteres.

O botão superior direito "|" abre um menu de opções: 

    1) Exibir mensagem: será exibido uma mensagem na tela com o progresso atual do download selecionado na lista de downloads;
    2) Parar download: será interrompido o download do item selecionado na lista de downloads; 
    3) Histórico de downloads: será realizada uma consulta no servidor solicitando todos os downloads já registrados. Uma nova janela exibirá os registros em forma de lista.
 
<h3>Instruções para execução</h3>

Inicialize a aplicação servidora.
 - Por padrão, as configurações de host serão inicializadas com "localhost:8080". 
 - Clique no botão "Start" e deixa a aplicação executando.
 
Inicialize a aplicação cliente.
 - Por padrão as configurações de host serão inicializadas com "localhost:8080".
 - Siga as instruções acima para utilizar a aplicação.
