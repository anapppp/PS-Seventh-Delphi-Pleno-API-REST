unit Test;

interface

uses
  DUnitX.TestFramework, Horse, System.SysUtils,
  ServerController, VideoController, RecyclerController;

type
  [TestFixture]
  TServerControllerTest = class
  private
    FHorseApp: THorse;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  end;

implementation

procedure TServerControllerTest.Setup;
begin
  FHorseApp := THorse.Create;
  FHorseApp.Post('/api/server', ServerController.CreateServer);
end;

procedure TServerControllerTest.TearDown;
begin
  FHorseApp.Destroy;
end;



end.



