unit VideoTest;

interface

uses
  DUnitX.TestFramework, Horse, ServerController, System.SysUtils, App;

type
  [TestFixture]
  TVideoTest = class
  private
    FHorseApp: THorse;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestAddVideo;
  end;

implementation

procedure TVideoTest.Setup;
begin
  //App.StartServer
end;

procedure TVideoTest.TearDown;
begin
  //App.StopServer;
end;

procedure TVideoTest.TestAddVideo;
var
  Response: string;
begin
  // Simulando uma solicitação POST para criar um novo servidor
  // Aqui você pode incluir todos os parâmetros necessários na requisição
  // e verificar se a resposta está de acordo com o esperado
  Response := 'True';

  // Verifica se a resposta indica sucesso (por exemplo, código de status HTTP 200)
  Assert.IsTrue(False, 'CreateServer should return success message');
end;

initialization
  TDUnitX.RegisterTestFixture(TVideoTest);

end.

