unit ServerController;

interface

uses
  Horse, System.JSON, System.SysUtils,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;


procedure CreateServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DeleteServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure CheckServerAvailability(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListServers(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

// definindo o tipo TServerData
type
  TServerData = class
  private
    // "F" significa Field. Convenção que indicam campos/ variaveis de instância de uma classe
    FID: string;
    FName: string;
    FIP: string;
    FPort: Integer;
  public
    // "A" significa Argumento em AID, AIP, etc. Essa eh apenas uma convencao em Delphi
    constructor Create(AID: string; AName: string; AIP: string; APort: Integer);
//    procedure SaveToDatabase;
    property ID: string read FID write FID;
    property Name: string read FName write FName;
    property IP: string read FIP write FIP;
    property Port: Integer read FPort write FPort;
  end;

var
  Servers: TArray<TServerData>;     // Array com elementos do tipo TServer
  FDConnection: TFDConnection;



// Fazendo o constructorTServerData.Create
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




// Agora sim, comeca o programa.....

procedure CreateServer(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  ServerData: TServerData;       // A variavel Server Data eh do tipo TServerData
  JSONBody: TJSONObject;         // A variavel JSONBody é do tipo TJSONObject, que vem do System.JSON
  ServerID, ServerName, ServerIP: string;
  ServerPort: Integer;
  FDQuery: TFDQuery;
begin
  JSONBody := Req.Body<TJSONObject>;         // Pega a requisicao do body

  // Gera um ID do tipo GUID
  ServerID := TGUID.NewGuid.ToString;
  // Extrai as informacoes do body
  ServerName := JSONBody.GetValue('name').Value;
  ServerIP := JSONBody.GetValue('ip').Value;
  ServerPort := StrToIntDef(JSONBody.GetValue('port').Value, 0);

  // Criando a instância de TServerData usando o construtor
  ServerData := TServerData.Create(ServerID, ServerName, ServerIP, ServerPort);

  // Persistindo dados no banco de dados SQLite
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

