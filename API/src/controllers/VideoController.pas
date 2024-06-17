unit VideoController;

interface

uses
  Horse, System.JSON, System.SysUtils,
  Data.DB, DataBaseManager,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  ServerController;

function VideoExists(const serverId, videoDescription: string;
  videoId: string = ''): Boolean;
procedure AddVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DeleteVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DownloadVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListVideos(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

function VideoExists(const serverId, videoDescription: string;
  videoId: string = ''): Boolean;
var
  vQuery: TFDQuery;
begin
  Result := False;
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConnection;
    vQuery.SQL.Text :=
      'SELECT * FROM Videos WHERE Server_ID = :ServerId AND (description = :VideoDescription OR ID = :VideoID)';
    vQuery.ParamByName('ServerId').AsString := serverId;
    vQuery.ParamByName('VideoDescription').AsString := videoDescription;
    vQuery.ParamByName('VideoId').AsString := videoId;
    vQuery.Open;
    Result := not vQuery.IsEmpty;
  finally
    vQuery.Free;
  end;
end;

procedure AddVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vJsonObj: TJsonObject;
  vQuery: TFDQuery;
begin
  // Obter s informacoes do video

  if not ServerExists(serverId) then
  begin
    Res.Send(TJsonObject.Create.AddPair('message', 'Servidor não encontrado'))
      .Status(404);
    Exit;
  end;

  if VideoExists(serverId, video.GetValue('id').Value) then
  begin
    Res.Send(TJsonObject.Create.AddPair('message',
      'O vídeo já existe no servidor')).Status(409);
    Exit;
  end;

  try

    // Adicionar o vídeo ao servidor
    // BLA BLA BLA BLA
    if vQuery.RowsAffected = 0 then
    begin
      vJsonObj := TJsonObject.Create;
      vJsonObj.AddPair('message', 'Erro ao adicionar o vídeo ao servidor');
      Res.Send(vJsonObj).Status(500);
    end
    else
    begin
      vJsonObj := TJsonObject.Create;
      vJsonObj.AddPair('message', 'Video Adicionado com sucesso');
      Res.Send(vJsonObj).Status(201);
    end;
  finally
    vQuery.Free;
  end;

end;

procedure DeleteVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('DeleteVideo');
end;

procedure GetVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('GetVideo');
end;

procedure DownloadVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('DownloadVideo');
end;

procedure ListVideos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('ListVideos');
end;

end.
