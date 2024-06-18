unit RecyclerController;

interface

uses
  Horse, System.JSON, System.SysUtils, System.Classes, System.DateUtils,
  Data.DB, DataBaseManager,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  ServerController, VideoController;

procedure ProcessRecycle(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetRecyclerStatus(Req: THorseRequest; Res: THorseResponse;
  Next: TProc);

implementation

procedure ProcessRecycle(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  days: String;
  cutoffDate: TDateTime;
  vQuery: TFDQuery;
begin
  days := Req.Params['days'];
  vQuery := nil;

  try
    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := FDConnection;
    vQuery.SQL.Text := 'DELETE FROM VIDEOS WHERE uploadedAt < datetime(' +
      QuotedStr('now') + ', ' + QuotedStr('-' + days+ ' day')+' )';
    vQuery.ExecSQL;
    if vQuery.RowsAffected = 0 then
    begin
      Res.Send(TJsonObject.Create.AddPair('message',
        'Nenhum video encontrado no(s) último(s) ' + Req.Params['days'] +
        ' dia(s)')).Status(404);
    end
    else
      Res.Send(TJsonObject.Create.AddPair('message',
        'Vídeos removidos com sucesso.')).Status(200);
  finally
    vQuery.Free;
  end;
end;

procedure GetRecyclerStatus(Req: THorseRequest; Res: THorseResponse;
  Next: TProc);
begin
  Res.Send('GetRecyclerStatus');
end;

end.
