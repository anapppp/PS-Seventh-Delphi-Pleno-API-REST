unit VideoController;

interface

uses
  Horse, System.JSON, System.SysUtils, System.Classes, System.DateUtils,
  Data.DB, DataBaseManager,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  ServerController;

function VideoExists(const serverID: string; videoID: string = '';
  filePath: string = ''): Boolean;
function DateToISO8601(const ADateTime: TDateTime): string;
procedure AddVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DeleteVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DownloadVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListVideos(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

function VideoExists(const serverID: string; videoID: string = '';
  filePath: string = ''): Boolean;
var
  vQuery: TFDQuery;
begin
  Result := False;
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConnection;
    vQuery.SQL.Text :=
      'SELECT * FROM Videos WHERE server_ID = :serverID AND (filePath = :filePath OR ID = :videoID)';
    vQuery.ParamByName('serverID').AsString := serverID;
    vQuery.ParamByName('filePath').AsString := filePath;
    vQuery.ParamByName('videoID').AsString := videoID;
    vQuery.Open;
    Result := not vQuery.IsEmpty;
  finally
    vQuery.Free;
  end;
end;

function DateToISO8601(const ADateTime: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss"Z"',
    TTimeZone.Local.ToUniversalTime(ADateTime));
end;

procedure AddVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  JSONBody: TJsonObject;
  vQuery: TFDQuery;
  vServerID, vVideoDescription, vFileName: string;
  vVideoSizeInBytes: Int64;
  FileStream: TFileStream;
begin
  JSONBody := Req.Body<TJsonObject>;
  vServerID := Req.Params['serverID'];
  vVideoDescription := JSONBody.GetValue('description').Value;
  vFileName := JSONBody.GetValue('fileName').Value;

  if not ServerExists(vServerID) then
  begin
    Res.Send(TJsonObject.Create.AddPair('message', 'Servidor não encontrado'))
      .Status(404);
    Exit;
  end;

  if VideoExists(vServerID, '0', vVideoFilePath + vFileName) then
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
      'INSERT INTO Videos (ID, server_ID, filePath, description, sizeInBytes, videoContent, uploadedAt ) '
      + 'VALUES (:vVideoID, :vServerID, :vFilePath, :vVideoDescription, :vVideoSizeInBytes, :vVideoContent, CURRENT_TIMESTAMP)';
    vQuery.ParamByName('vVideoID').AsString := TGUID.NewGuid.ToString;
    vQuery.ParamByName('vServerID').AsString := vServerID;
    vQuery.ParamByName('vFilePath').AsString := vVideoFilePath + vFileName;
    vQuery.ParamByName('vVideoDescription').AsString := vVideoDescription;
    vQuery.ParamByName('vVideoSizeInBytes').AsString :=
      IntToStr(vVideoSizeInBytes);
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
        'Video adicionado com sucesso')).Status(201);
    end;
  finally
    vQuery.Free;
  end;

end;

procedure DeleteVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vQuery: TFDQuery;
  vVideoID, vServerID: String;
begin
  vQuery := nil;
  try
    vServerID := Req.Params['serverID'];
    vVideoID := Req.Params['videoID'];

    if not ServerExists(vServerID) then
    begin
      Res.Send(TJsonObject.Create.AddPair('message', 'Servidor não encontrado'))
        .Status(404);
      Exit;
    end;

    if not VideoExists(vServerID, vVideoID) then
    begin
      Res.Send(TJsonObject.Create.AddPair('message',
        'Video não encontrado no servidor')).Status(404);
      Exit;
    end;

    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := FDConnection;
    vQuery.SQL.Text :=
      'DELETE FROM Videos WHERE ID = :ID AND server_ID == :serverID';
    vQuery.ParamByName('ID').AsString := vVideoID;
    vQuery.ParamByName('serverID').AsString := vServerID;
    vQuery.ExecSQL;

    if vQuery.RowsAffected = 0 then
    begin
      Res.Send(TJsonObject.Create.AddPair('message',
        'Não foi possivel excluir o video')).Status(404);
    end
    else
    begin
      Res.Send(TJsonObject.Create.AddPair('message',
        'Video excluido com sucesso')).Status(200);
    end;
  finally
    vQuery.Free;
  end;
end;

procedure GetVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vQuery: TFDQuery;
  vJsonObj: TJsonObject;
  vServerID, vVideoID: String;
begin
  vQuery := nil;
  try
    vServerID := Req.Params['serverId'];
    vVideoID := Req.Params['videoId'];

    if not VideoExists(vServerID, vVideoID) then
    begin
      Res.Send(TJsonObject.Create.AddPair('message', 'Video não encontrado'))
        .Status(404);
      Exit;
    end;

    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := FDConnection;
    vQuery.SQL.Text :=
      'SELECT * FROM Videos WHERE ID=:ID and server_ID=:serverID';
    vQuery.ParamByName('ID').AsString := vVideoID;
    vQuery.ParamByName('serverID').AsString := vServerID;
    vQuery.Open;
    vJsonObj := TJsonObject.Create;

    vJsonObj.AddPair('videoContent',
      TJsonString.Create(vQuery.FieldByName('videoContent').AsString));
    // Res.Send(vJsonObj).Status(200);
       Res.Status(200);
  finally
    vQuery.Free;
  end;
end;

procedure DownloadVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vQuery: TFDQuery;
  vVideoID, vServerID, vFilePath: string;
  FileStream: TFileStream;
begin
  vQuery := nil;
  try
    vServerID := Req.Params['serverId'];
    vVideoID := Req.Params['videoId'];

    if not VideoExists(vServerID, vVideoID) then
    begin
      Res.Send(TJsonObject.Create.AddPair('message', 'Video não encontrado'))
        .Status(404);
      Exit;
    end;

    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := FDConnection;
    vQuery.SQL.Text :=
      'SELECT * FROM Videos WHERE ID=:ID and server_ID=:serverID';
    vQuery.ParamByName('ID').AsString := vVideoID;
    vQuery.ParamByName('serverID').AsString := vServerID;
    vQuery.Open;

    vFilePath := vQuery.FieldByName('filePath').AsString;

    FileStream := TFileStream.Create(vFilePath, fmOpenRead or fmShareDenyWrite);
    Res.ContentType('application/octet-stream');
    Res.RawWebResponse.SetCustomHeader('Content-Disposition',
      'attachment; filename="' + vVideoID + '"');
    // Res.SendStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

procedure ListVideos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vQuery: TFDQuery;
  vJsonArr: TJsonArray;
  vJsonObj: TJsonObject;
  vCount: Integer;
  vServerID, iso8601Date: String;
begin
  vQuery := nil;
  vJsonArr := nil;
  try
    vServerID := Req.Params['serverId'];
    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := FDConnection;
    vQuery.SQL.Text := 'SELECT * FROM Videos WHERE server_ID = :serverID';
    vQuery.ParamByName('serverID').AsString := vServerID;
    vQuery.Open;

    vJsonArr := TJsonArray.Create;
    for vCount := 0 to vQuery.RecordCount - 1 do
    begin
      iso8601Date := DateToISO8601(vQuery.FieldByName('uploadedAt').AsDateTime);
      vJsonObj := TJsonObject.Create;
      vJsonObj.AddPair('ID', TJsonString.Create(vQuery.FieldByName('ID')
        .AsString));
      vJsonObj.AddPair('serverID',
        TJsonString.Create(vQuery.FieldByName('server_ID').AsString));
      vJsonObj.AddPair('filePath',
        TJsonString.Create(vQuery.FieldByName('filePath').AsString));
      vJsonObj.AddPair('description',
        TJsonString.Create(vQuery.FieldByName('description').AsString));
      vJsonObj.AddPair('sizeInBytes',
        TJsonNumber.Create(vQuery.FieldByName('sizeInBytes').AsInteger));
      vJsonObj.AddPair('uploadedAt', TJsonString.Create(iso8601Date));
      vJsonArr.Add(vJsonObj);
      vQuery.Next;
    end;
    Res.Send(vJsonArr.ToJSON).Status(200);
  finally
    vQuery.Free;
    vJsonArr.Free;
  end;
end;
end.
