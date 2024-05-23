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
    .Post('/api/server', ServerController.CreateServer)
    .Delete('/api/servers/:serverId', ServerController.DeleteServer)
    .Get('/api/servers/:serverId', ServerController.GetServer)
    .Get('/api/servers/available/:serverId', ServerController.CheckServerAvailability)
    .Get('/api/servers', ServerController.ListServers)

    // VIDEOS
    .Post('/api/servers/:serverId/videos', VideoController.AddVideo)
    .Delete('/api/servers/:serverId/videos/:videoId', VideoController.DeleteVideo)
    .Get('/api/servers/:serverId/videos/:videoId', VideoController.GetVideo)
    .Get('/api/servers/:serverId/videos/:videoId/binary', VideoController.DownloadVideo)
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
