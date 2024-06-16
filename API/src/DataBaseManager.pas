unit DataBaseManager;

interface

uses
  FireDAC.Comp.Client;

var
  FDConnection: TFDConnection;

procedure InitializeDataBase;

implementation

procedure InitializeDataBase;
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
  FDConnection.ExecSQL('CREATE TABLE IF NOT EXISTS Videos (' +
    'ID TEXT PRIMARY KEY, ' +
    'Server_ID TEXT, ' +
    'description TEXT, ' +
    'sizeInBytes INTEGER, ' +
    'FOREIGN KEY(Server_ID) REFERENCES Servers(ID))');
end;

end.
