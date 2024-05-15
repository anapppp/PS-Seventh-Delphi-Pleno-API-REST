unit RecyclerController;

interface

uses
  Horse, System.JSON, System.SysUtils;

procedure ProcessRecycle(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetRecyclerStatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);


implementation

procedure ProcessRecycle(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  // Implemente a lógica para criar um novo servidor
  Res.Send('ProcessRecycle');
end;


procedure GetRecyclerStatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  // Implemente a lógica para criar um novo servidor
  Res.Send('GetRecyclerStatus');
end;

end.
