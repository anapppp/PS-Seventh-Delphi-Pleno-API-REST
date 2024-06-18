unit App;
interface
uses
  Horse,
  Horse.Jhonson,
  System.JSON,
  System.SysUtils,
  Data.DB, DataBaseManager,
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
  DataBaseManager.InitializeDataBase;
  GlobalServer := THorse.Create();
  THorse.Use(Jhonson);
    // SERVERS
  GlobalServer
    .Post('/api/server', ServerController.CreateServer)
    .Delete('/api/servers/:serverId', ServerController.DeleteServer)
    .Get('/api/servers/:serverId', ServerController.GetServer)
    .Put('/api/servers/:serverId', ServerController.UpdateServer)
    .Get('/api/servers/available/:serverId', ServerController.CheckServerAvailability)
    .Get('/api/servers', ServerController.ListServers)
    // VIDEOS
    .Post('/api/servers/:serverId/videos', VideoController.AddVideo)
    .Delete('/api/servers/:serverId/videos/:videoId', VideoController.DeleteVideo)
    .Get('/api/servers/:serverId/videos/:videoId/binary', VideoController.GetVideo)
    .Get('/api/servers/:serverId/videos/:videoId', VideoController.DownloadVideo)
    .Get('/api/servers/:serverId/videos', VideoController.ListVideos)
    // RECYCLE
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
