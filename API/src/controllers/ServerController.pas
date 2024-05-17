unit ServerController;

interface

uses
  Horse, System.JSON, System.SysUtils;

procedure CreateServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DeleteServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure CheckServerAvailability(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListServers(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

type
  TServerData = record
    ID: string;
    Name: string;
    IP: string;
    Port: Integer;
  end;
var
  Servers: TArray<TServerData>;


procedure CreateServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  ServerData: TServerData;
  JSONBody: TJSONObject;
begin
  JSONBody := Req.Body<TJSONObject>;

  // Extract server data from JSON body
  ServerData.ID := TGUID.NewGuid.ToString;
  ServerData.Name := JSONBody.GetValue('name').Value;
  ServerData.IP := JSONBody.GetValue('ip').Value;
  ServerData.Port := StrToIntDef(JSONBody.GetValue('port').Value, 0);

  // Add the new server to the list of servers
  SetLength(Servers, Length(Servers) + 1);
  Servers[High(Servers)] := ServerData;

  Res.Send(TJSONObject.Create
    .AddPair('id', ServerData.ID)
    .AddPair('name', ServerData.Name)
    .AddPair('ip', ServerData.IP)
    .AddPair('port', ServerData.Port.ToString)
    .ToString);
end;

procedure DeleteServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  // Implemente a lógica para remover um servidor existente
  Res.Send('DeleteServer');
end;

procedure GetServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  // Implemente a lógica para recuperar um servidor existente
  Res.Send('GetServer');
end;

procedure CheckServerAvailability(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  // Implemente a lógica para verificar a disponibilidade de um servidor
  Res.Send('CheckServerAvailability');
end;

procedure ListServers(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  // Implemente a lógica para listar todos os servidores
   Res.Send('ListServers');
end;

end.

