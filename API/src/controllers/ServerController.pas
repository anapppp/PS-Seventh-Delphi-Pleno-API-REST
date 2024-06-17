unit ServerController;
interface
uses
  Horse, System.JSON, System.SysUtils,
  Data.DB, DataBaseManager,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  IdTCPClient, IdException;

procedure CreateServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DeleteServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure UpdateServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure CheckServerAvailability(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListServers(Req: THorseRequest; Res: THorseResponse; Next: TProc);
implementation
type
  TServerData = class
  private
    FID: string;
    FName: string;
    FIP: string;
    FPort: Integer;
  public
    constructor Create(AID: string; AName: string; AIP: string; APort: Integer);
    property ID: string read FID write FID;
    property Name: string read FName write FName;
    property IP: string read FIP write FIP;
    property Port: Integer read FPort write FPort;
  end;


constructor  TServerData.Create(AID: string; AName: string; AIP: string; APort: Integer);
begin
  FID := AID;
  FName := AName;
  FIP := AIP;
  FPort := APort;
end;


procedure CreateServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  ServerData: TServerData;
  JSONBody: TJSONObject;
  ServerID, ServerName, ServerIP: string;
  ServerPort: Integer;
  FDQuery: TFDQuery;
begin
  JSONBody := Req.Body<TJSONObject>;
  ServerID := TGUID.NewGuid.ToString;
  ServerName := JSONBody.GetValue('name').Value;
  ServerIP := JSONBody.GetValue('ip').Value;
  ServerPort := StrToIntDef(JSONBody.GetValue('port').Value, 0);
  ServerData := TServerData.Create(ServerID, ServerName, ServerIP, ServerPort);
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection;
    FDQuery.SQL.Text := 'INSERT INTO Servers (ID, Name, IP, Port) VALUES (:ID, :Name, :IP, :Port)';
    FDQuery.ParamByName('ID').AsString := ServerData.ID;
    FDQuery.ParamByName('Name').AsString := ServerData.Name;
    FDQuery.ParamByName('IP').AsString := ServerData.IP;
    FDQuery.ParamByName('Port').AsInteger := ServerData.Port;
    FDQuery.ExecSQL;
  finally
    FDQuery.Free;
  end;

  JSONBody.AddPair('ID', ServerData.ID);
  Res.Send(JSONBody).Status(201);
end;

procedure UpdateServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vServerID, vServerName, vServerIP: string;
  vServerPort: Integer;
  JSONBody: TJSONObject;
  vQuery: TFDQuery;
  vAllFieldsPresent: Boolean;
begin
  JSONBody := Req.Body<TJSONObject>;
  vServerID := Req.Params['serverId'];

  vAllFieldsPresent := Assigned(JSONBody.FindValue('name')) and
                       Assigned(JSONBody.FindValue('ip')) and
                       Assigned(JSONBody.FindValue('port'));

  if not vAllFieldsPresent then
  begin
    Res.Send(TJSONObject.Create.AddPair('message', 'Todos os campos devem ser fornecidos')).Status(400);
  end
  else
  begin
    vServerName := JSONBody.GetValue('name').Value;
    vServerIP := JSONBody.GetValue('ip').Value;
    vServerPort := StrToIntDef(JSONBody.GetValue('port').Value, 0);


  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConnection;
    vQuery.SQL.Text := 'UPDATE Servers SET Name = :Name, IP = :IP, Port = :Port WHERE ID = :ID';
    vQuery.ParamByName('ID').AsString := vServerID;
    vQuery.ParamByName('Name').AsString := vServerName;
    vQuery.ParamByName('IP').AsString := vServerIP;
    vQuery.ParamByName('Port').AsInteger := vServerPort;
    vQuery.ExecSQL;

    if vQuery.RowsAffected = 0 then
    begin
      Res.Send(TJSONObject.Create.AddPair('message', 'Servidor com ID = ' + vServerID + ' não encontrado.')).Status(404);
    end
    else
    begin
      Res.Send(TJSONObject.Create.AddPair('message', 'Servidor atualizado com sucesso.')).Status(200);
    end;
  finally
    vQuery.Free;
  end;
  end;
end;

procedure DeleteServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vQuery: TFDQuery;
  vJsonObj: TJsonObject;
  vServerID: String;
begin
  vQuery := nil;
  try
    vServerID := Req.Params['serverId'];
    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := FDConnection;
    vQuery.SQL.Text := 'DELETE FROM Servers WHERE ID = :ID';
    vQuery.ParamByName('ID').AsString := vServerID;
    vQuery.ExecSQL;

    if vQuery.RowsAffected = 0 then
    begin
      vJsonObj := TJsonObject.Create;
      vJsonObj.AddPair('message', 'Servidor com ID = '+ vServerID + ' não encontrado.');
      Res.Send(vJsonObj).Status(404);
    end
    else
    begin
      Res.Send('Servidor excluido com sucesso.').Status(200);
    end;
  finally
    vQuery.Free;
  end;

end;

procedure GetServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vQuery: TFDQuery;
  vJsonObj: TJsonObject;
  vServerID: String;
begin
  vQuery := nil;
  try
    vServerID := Req.Params['serverId'];
    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := FDConnection;
    vQuery.SQL.Text := 'SELECT * FROM Servers WHERE ID = :ID';
    vQuery.ParamByName('ID').AsString := vServerID;
    vQuery.Open;
    vJsonObj := TJsonObject.Create;
    if vQuery.IsEmpty then
    begin
      vJsonObj.AddPair('message', 'Servidor com ID = '+ vServerID + ' não encontrado.');
      Res.Send(vJsonObj).Status(404);
    end
    else
    begin
      vJsonObj.AddPair('ID', TJsonString.Create(vQuery.FieldByName('ID').AsString));
      vJsonObj.AddPair('Name', TJsonString.Create(vQuery.FieldByName('Name').AsString));
      vJsonObj.AddPair('IP', TJsonString.Create(vQuery.FieldByName('IP').AsString));
      vJsonObj.AddPair('Port', TJsonNumber.Create(vQuery.FieldByName('Port').AsInteger));
      Res.Send(vJsonObj).Status(200);
    end;
  finally
    vQuery.Free;
  end;
end;


procedure CheckServerAvailability(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vServerID: string;
  vQuery: TFDQuery;
  vTCPClient: TIdTCPClient;
  vJsonObj: TJSONObject;
  vIP: string;
  vPort: Integer;
begin
  vServerID := Req.Params['serverId'];
  vQuery := TFDQuery.Create(nil);
  vTCPClient := TIdTCPClient.Create(nil);
  vJsonObj := TJSONObject.Create;
  try
    vQuery.Connection := FDConnection;
    vQuery.SQL.Text := 'SELECT IP, Port FROM Servers WHERE ID = :ID';
    vQuery.ParamByName('ID').AsString := vServerID;
    vQuery.Open;

    if vQuery.IsEmpty then
    begin
      vJsonObj.AddPair('message', 'Servidor com ID = ' + vServerID + ' não encontrado.');
      Res.Send(vJsonObj).Status(404);
    end
    else
    begin
      vIP := vQuery.FieldByName('IP').AsString;
      vPort := vQuery.FieldByName('Port').AsInteger;

      vTCPClient.Host := vIP;
      vTCPClient.Port := vPort;
      try
        vTCPClient.ConnectTimeout := 1000; // 1 segundo de timeout
        vTCPClient.Connect;
        vJsonObj.AddPair('status', 'available');
      except
        on E: Exception do
        begin
          vJsonObj.AddPair('status', 'unavailable');
          vJsonObj.AddPair('error', E.Message);
        end;
      end;
      Res.Send(vJsonObj).Status(200);
    end;
  finally
    vQuery.Free;
    vTCPClient.Free;
    vJsonObj.Free;
  end;
end;


procedure ListServers(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vQuery: TFDQuery;
  vJsonArr: TJsonArray;
  vJsonObj: TJsonObject;
  vCount: Integer;
begin
  vQuery := nil;
  vJsonArr := nil;
  try
    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := FDConnection;
    vQuery.SQL.Text := 'SELECT * FROM Servers';
    vQuery.Open;

    vJsonArr := TJsonArray.Create;
    for vCount := 0 to vQuery.RecordCount - 1 do
    begin
      vJsonObj := TJsonObject.Create;
      vJsonObj.AddPair('ID', TJsonString.Create(vQuery.FieldByName('ID').AsString));
      vJsonObj.AddPair('Name', TJsonString.Create(vQuery.FieldByName('Name').AsString));
      vJsonObj.AddPair('IP', TJsonString.Create(vQuery.FieldByName('IP').AsString));
      vJsonObj.AddPair('Port', TJsonNumber.Create(vQuery.FieldByName('Port').AsInteger));
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
