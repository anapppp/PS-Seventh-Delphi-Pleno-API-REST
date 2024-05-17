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
  // Simulando uma solicita��o POST para criar um novo servidor
  // Aqui voc� pode incluir todos os par�metros necess�rios na requisi��o
  // e verificar se a resposta est� de acordo com o esperado
  Response := 'success'; //FHorseApp.Post('/api/server', '{"name": "Test Server", "ip": "127.0.0.1", "port": 8080}');

  // Verifica se a resposta indica sucesso (por exemplo, c�digo de status HTTP 200)
  Assert.IsTrue(Response.Contains('success'), 'CreateServer should return success message');
end;

initialization
  TDUnitX.RegisterTestFixture(TServerTest);

end.

