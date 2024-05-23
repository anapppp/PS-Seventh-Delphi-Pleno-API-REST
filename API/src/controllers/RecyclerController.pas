unit RecyclerController;

interface

uses
  Horse, System.JSON, System.SysUtils;

procedure ProcessRecycle(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetRecyclerStatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);


implementation

procedure ProcessRecycle(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('ProcessRecycle');
end;


procedure GetRecyclerStatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('GetRecyclerStatus');
end;

end.
