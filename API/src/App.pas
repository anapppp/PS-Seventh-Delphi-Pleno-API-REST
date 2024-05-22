unit App;

interface

uses
  Horse,
  System.JSON,
  System.SysUtils,
  ServerController,
  VideoController,
  RecyclerController;


procedure StartServer;
procedure StopServer;

implementation

var
  GlobalServer: THorse;



procedure StartServer;
begin

  GlobalServer := THorse.Create();
  GlobalServer
    // SERVERS
    // Criar um novo servidor
    .Post('/api/server', ServerController.CreateServer)
    // Remover um servidor existente
    .Delete('/api/servers/:serverId', ServerController.DeleteServer)
    // Recuperar um servidor existente
    .Get('/api/servers/:serverId', ServerController.GetServer)
    // Checar disponibilidade de um servidor
    .Get('/api/servers/available/:serverId', ServerController.CheckServerAvailability)
    // Listar todos os servidores
    .Get('/api/servers', ServerController.ListServers)

    // VIDEOS
    // Adicionar um novo vídeo à um servidor
    .Post('/api/servers/:serverId/videos', VideoController.AddVideo)
    // Remover um vídeo existente
    .Delete('/api/servers/:serverId/videos/:videoId', VideoController.DeleteVideo)
    // Recuperar dados cadastrais de um vídeo
    .Get('/api/servers/:serverId/videos/:videoId', VideoController.GetVideo)
    // Download do conteúdo binário de um vídeo
    .Get('/api/servers/:serverId/videos/:videoId/binary', VideoController.DownloadVideo)
    // Listar todos os vídeos de um servidor
    .Get('/api/servers/:serverId/videos', VideoController.ListVideos)

    // RECYCLE
    // Reciclar vídeos antigos
    .Post('/api/recycler/process/:days', RecyclerController.ProcessRecycle)
    .Get('/api/recycler/status', RecyclerController.GetRecyclerStatus);

  GlobalServer.Listen(9000);
end;


procedure StopServer;
begin
  if Assigned(GlobalServer) then
  begin
    GlobalServer.StopListen;
    FreeAndNil(GlobalServer);
  end;
end;

end.
