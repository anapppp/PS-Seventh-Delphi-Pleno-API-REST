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
  Response := 'True';

  Assert.IsTrue(False, 'CreateServer should return success message');
end;

initialization
  TDUnitX.RegisterTestFixture(TVideoTest);

end.

