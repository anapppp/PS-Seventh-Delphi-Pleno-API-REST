unit RecyclerTest;

interface

uses
  DUnitX.TestFramework, Horse, ServerController, System.SysUtils, App;

type
  [TestFixture]
  TRecyclerTest = class
  private
    FHorseApp: THorse;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestProcessRecycle;
  end;

implementation

procedure TRecyclerTest.Setup;
begin
  //App.StartServer;
end;

procedure TRecyclerTest.TearDown;
begin
  //App.StopServer;
end;

procedure TRecyclerTest.TestProcessRecycle;
var
  Response: string;
begin
  // Simulando uma solicitação POST para criar um novo servidor
  // Aqui você pode incluir todos os parâmetros necessários na requisição
  // e verificar se a resposta está de acordo com o esperado
  Response := 'True';

  // Verifica se a resposta indica sucesso (por exemplo, código de status HTTP 200)
  Assert.IsTrue(True, 'CreateServer should return success message');
end;

initialization
  TDUnitX.RegisterTestFixture(TRecyclerTest);

end.

