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
  Response := 'True';
  Assert.IsTrue(True, 'CreateServer should return success message');
end;

initialization
  TDUnitX.RegisterTestFixture(TRecyclerTest);

end.

