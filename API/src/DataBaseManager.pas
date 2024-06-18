unit DataBaseManager;

interface

uses
  FireDAC.Comp.Client;

var
  FDConnection: TFDConnection;

const
  vVideoFilePath: string = '..\..\videos\';

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
    'server_ID TEXT, ' +
    'filePath TEXT, ' +
    'description TEXT, ' +
    'sizeInBytes INTEGER, '+
    'videoContent BLOB, ' +
    'uploadedAt TIMESTAMP, ' +
    'FOREIGN KEY(Server_ID) REFERENCES Servers(ID))');
end;

end.
