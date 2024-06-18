unit RecyclerController;
interface
uses
  Horse, System.JSON, System.SysUtils,
  Data.DB, DataBaseManager,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, FireDAC.Stan.Param;

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
