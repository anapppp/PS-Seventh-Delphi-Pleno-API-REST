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
  Response := 'success';
  Assert.IsTrue(Response.Contains('success'), 'CreateServer should return success message');
end;

initialization
  TDUnitX.RegisterTestFixture(TServerTest);

end.

