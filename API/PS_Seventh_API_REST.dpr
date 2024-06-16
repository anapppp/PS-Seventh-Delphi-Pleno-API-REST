program PS_Seventh_API_REST;
{$APPTYPE CONSOLE}
{$R *.dres}
uses
  System.SysUtils,
  Horse,
  Horse.Commons,
  Horse.Jhonson,
  DataBaseManager in 'src\DataBaseManager.pas',
  App in 'src\App.pas',
  ServerController in 'src\controllers\ServerController.pas',
  VideoController in 'src\controllers\VideoController.pas',
  RecyclerController in 'src\controllers\RecyclerController.pas';

begin
  try
    Writeln('Servidor rodando na porta 9000.');
    App.StartServer;
  except on E: Exception do
    begin
     Writeln('Erro: ' + E.Message);
     Writeln('Tipo de exceção: ' + E.ClassName);
    end;
  end;
end.
