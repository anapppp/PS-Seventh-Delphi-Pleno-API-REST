program PS_Seventh_API_REST;

{$APPTYPE CONSOLE}

{$R *.dres}

uses
  System.SysUtils,
  Horse,
  Horse.Commons,
  Horse.Jhonson,
  App in 'src\App.pas',
  ServerController in 'src\controllers\ServerController.pas',
  VideoController in 'src\controllers\VideoController.pas',
  RecyclerController in 'src\controllers\RecyclerController.pas';

begin
  try
    Writeln('Servidor rodando na porta 9000.');
    App.StartServer;
  except
    on E: Exception do
      Writeln('Erro: ', E.Message);
  end;
end.







