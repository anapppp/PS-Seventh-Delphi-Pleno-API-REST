unit ServerController;
interface
uses
  Horse, System.JSON, System.SysUtils,
  Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Stan.Param;

procedure InitializeDatabase;
procedure CreateServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DeleteServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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
var
  FDConnection: TFDConnection;
constructor  TServerData.Create(AID: string; AName: string; AIP: string; APort: Integer);
begin
  FID := AID;
  FName := AName;
  FIP := AIP;
  FPort := APort;
end;

procedure InitializeDatabase;
begin
  FDConnection := TFDConnection.Create(nil);
  FDConnection.DriverName := 'SQLite';
  FDConnection.Params.Database := 'servers.db';
  FDConnection.LoginPrompt := False;
  FDConnection.Connected := True;
  FDConnection.ExecSQL('CREATE TABLE IF NOT EXISTS Servers (' +
    'ID TEXT PRIMARY KEY, ' +
    'Name TEXT, ' +
    'IP TEXT, ' +
    'Port INTEGER)');
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
      Res.Send('').Status(200);
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
begin
  Res.Send('CheckServerAvailability');
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
