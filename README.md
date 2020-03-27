# POC de Audiobook

O objetivo dessa POC era testar funcionalidade de áudio em Swift para o iOS.

## Bibliotecas

1. [AVFoundation](https://developer.apple.com/documentation/avfoundation)
2. [AVPlayer](https://developer.apple.com/documentation/avfoundation/avplayer)

---

## Utilização

Para arquivos locais, ou seja sem streaming http, se utiliza o AVAudioPlayer fornecendo o path do arquivo na sua inicialização.
Caso seja necessário fazer streaming http é utilizado o AVPlayer, ele toca audio e vídeo e suporta urls HTTP, este também possui flags sobre o status do buffer e conectividade.
Também é possível instanciar um AVPlayerViewController e fazer um present() dele, isso cria um AVPlayer com várias funcionalidade pré-configuradas porém pouca customização.
Para customizar um AVPlayerViewController é possível utilizar seu método contentOverlayView que recebe uma view e insere ela na frente do vídeo porém atrás dos controles.
Na maioria dos casos o ideal será criar um AVPlayer e botões para controlá-lo ao invés de usar um  AVPlayerViewController devido à dificuldade de customização do segundo.
(Existe também extensões do AVPlayer, por exemplo o AVQueuePlayer que implementa funcionalidades de reproduzir uma playlist de arquivos recebidos por streaming)
*Todos players acima possuem métodos .play() .pause()  .seek() além de outros situacionalmente úteis.*
*Para manter o áudio reproduzindo mesmo no background basta definir uma AVAudioSession.sharedInstance e habilitar "Audio and AirPlay" nas configurações do projeto. ( um exemplo disso está na POC e no primeiro vídeo abaixo)*

---

## Exemplo

### Para simplesmente rodar um áudio

1. Instânciar um AVAudioPlayer e inicializá-lo dentro de um try catch(vale tanto para áudio baixado ou vindo por url). *essa configurações devem ser chamadas no viewDidLoad*
2. Chamar o método “prepareToPlay” *essa configurações devem ser chamadas no viewDidLoad*
3. Controlar execução nos cliques dos botões

### Para rodar em background
1. Instanciar audioSession.sharedInstance() *chamar essas configurações também no viewDidLoad*
2. Dentro de um try catch chamar audioSession.setCategory(.playback, mode: .default) *chamar essas configurações também no viewDidLoad*
3. Habilitar modo background de áudio nas configuraçõess do projeto -> capabilities -> background Mode -> audio, air play, etc. *chamar essas configurações também no viewDidLoad*

### Controlar pelo painel de controle iOS
1. Instanciar MPRemoteCommandCenter.shared()
2. Criar uma função utilizando o método commandCenter.playCommand.addTarget para todos os cenários que quisermos implementar (play, pause, restart) fazendo dentro as devidas validações(player parado, rodando e etc).
3. Criar uma função de configuração para informar o estado inicial do player pelo comando de controle
4. criar variável do tipo dicionário e estar os seguintes valores. *chamar no viewDidLoad pois são funções de configuração*
	`dicionario[MPNowPlayingInfoPropertyElapsedPlaybackTime] = tempo atual do player`
	`dicionario[MPMediaItemPropertyPlaybackDuration] = duração do player`
	`dicionario[MPNowPlayingInfoPropertyPlaybackRate] = taxa de reprodução do audio`
5. Depois atribuir o dicionário com os devidos valores ao MPNowPlayingInfoCenter. *chamar no viewDidLoad pois são funções de configuração*
	`MPNowPlayingInfoCenter.default().nowPlayingInfo = dicionário`

E por fim para cada ação do player dentro do app, utilizar uma função que atualize os dados do áudio no painel de controle da mesma forma em que é inicializado só que com os novos dados.


## Tutoriais seguidos para implementação

1. [AVAudioPlayer](https://www.youtube.com/watch?v=dqad3XuMwHI)
2. [Slider para controlar áudio](https://www.youtube.com/watch?v=S3BSK8UVJyc)
3. [AVPlayerViewController](https://www.youtube.com/watch?v=2_N3VDK_dJQ)

## O que ficou faltando testar?

1. Controlar o áudio no painel de controle não ficou muito confiável
2. Customização da View do player em tela cheia
3. Saber se ele segue tocando ao sair da view
4. Usar variáveis locais salvando onde o áudio parou e fazer com que volte a tocar onde parou
5. Tratamento de erro (não ter internet, etc)
6. Entender melhor o consumo de armazenamento dos aúdios no celular
