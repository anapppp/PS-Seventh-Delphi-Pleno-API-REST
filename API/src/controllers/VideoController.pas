unit VideoController;

interface

uses
  Horse, System.JSON, System.SysUtils, System.Classes,
  Data.DB, DataBaseManager,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  ServerController;

function VideoExists(const serverId, filePath: string;
  videoId: string = ''): Boolean;
procedure AddVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DeleteVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DownloadVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListVideos(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

function VideoExists(const serverId, filePath: string;
  videoId: string = ''): Boolean;
var
  vQuery: TFDQuery;
begin
  Result := False;
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConnection;
    vQuery.SQL.Text :=
      'SELECT * FROM Videos WHERE Server_ID = :ServerId AND (filePath = :filePath OR ID = :VideoID)';
    vQuery.ParamByName('ServerId').AsString := serverId;
    vQuery.ParamByName('filePath').AsString := filePath;
    vQuery.ParamByName('VideoId').AsString := videoId;
    vQuery.Open;
    Result := not vQuery.IsEmpty;
  finally
    vQuery.Free;
  end;
end;

procedure AddVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  JSONBody: TJsonObject;
  vQuery: TFDQuery;
  vServerID, vVideoDescription, vFileName, vVideoID: string;
  vVideoSizeInBytes: Int64;
  FileStream: TFileStream;
begin
  JSONBody := Req.Body<TJsonObject>;
  vVideoDescription := JSONBody.GetValue('description').Value;
  vFileName := JSONBody.GetValue('fileName').Value;
  vServerID := JSONBody.GetValue('serverID').Value;

  if not ServerExists(vServerID) then
  begin
    Res.Send(TJsonObject.Create.AddPair('message', 'Servidor não encontrado'))
      .Status(404);
    Exit;
  end;

  if VideoExists(vServerID, vVideoFilePath + vFileName) then
  begin
    Res.Send(TJsonObject.Create.AddPair('message',
      'O vídeo já existe no servidor')).Status(409);
    Exit;
  end;

  try
    FileStream := TFileStream.Create(vVideoFilePath + vFileName,
      fmOpenRead or fmShareDenyWrite);
    vVideoSizeInBytes := FileStream.Size;

    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := FDConnection;
    vQuery.SQL.Text :=
      'INSERT INTO Videos (ID, Server_ID, filePath, description, sizeInBytes, videoContent ) '
      + 'VALUES (:vVideoID, :vServerID, :vFilePath, :vVideoDescription, :vVideoSizeInBytes, :vVideoContent)';
    vQuery.ParamByName('vVideoID').AsString := TGUID.NewGuid.ToString;
    vQuery.ParamByName('vServerID').AsString := vServerID;
    vQuery.ParamByName('vFilePath').AsString := vVideoFilePath + vFileName;
    vQuery.ParamByName('vVideoDescription').AsString := vVideoDescription;
    vQuery.ParamByName('vVideoSizeInBytes').AsString := IntToStr(vVideoSizeInBytes);
    vQuery.ParamByName('vVideoContent').AsStream := FileStream;
    vQuery.ExecSQL;

    if vQuery.RowsAffected = 0 then
    begin
      Res.Send(TJsonObject.Create.AddPair('message',
        'Erro ao adicionar o vídeo ao servidor')).Status(500);
    end
    else
    begin
      Res.Send(TJsonObject.Create.AddPair('message',
        'Video Adicionado com sucesso')).Status(201);
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
