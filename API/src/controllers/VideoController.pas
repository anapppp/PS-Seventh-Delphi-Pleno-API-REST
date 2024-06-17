unit VideoController;

interface

uses
  Horse, System.JSON, System.SysUtils,
  Data.DB, DataBaseManager,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, FireDAC.Stan.Param;

procedure AddVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DeleteVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DownloadVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListVideos(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure AddVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin





end;

procedure DeleteVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('DeleteVideo');
end;

procedure GetVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('GetVideo');
end;

procedure DownloadVideo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('DownloadVideo');
end;

procedure ListVideos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('ListVideos');
end;

end.
