unit ServerTest;

interface

uses
  DUnitX.TestFramework, Horse, ServerController, System.SysUtils, App;

type
  [TestFixture]
  TServerTest = class
  private

  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestCreateServer;
  end;

implementation

procedure TServerTest.Setup;
begin
  // App.StartServer;
end;

procedure TServerTest.TearDown;
begin
  //App.StopServer;
end;

procedure TServerTest.TestCreateServer;
var
  Response: string;
begin
  // Simulando uma solicitação POST para criar um novo servidor
  // Aqui você pode incluir todos os parâmetros necessários na requisição
  // e verificar se a resposta está de acordo com o esperado
  Response := 'success'; //FHorseApp.Post('/api/server', '{"name": "Test Server", "ip": "127.0.0.1", "port": 8080}');

  // Verifica se a resposta indica sucesso (por exemplo, código de status HTTP 200)
  Assert.IsTrue(Response.Contains('success'), 'CreateServer should return success message');
end;

initialization
  TDUnitX.RegisterTestFixture(TServerTest);

end.

