unit Unit1;

{
    String Exchange Server Demo    INDY10.5.X

    It just shows how to send and receive String.

    No error handling

    Most of the code is bdlm's.

    Adnan
    Email: helloy72@yahoo.com

    compile and execute with DELPHI XE 2 is OK (bdlm 06.11.2011& 06.03.2012)
    add TEncoding (change according to your needs)
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdContext, IdSync, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdTCPServer, IdGlobal;

type
  TStringServerForm = class(TForm)
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    IdTCPServer1: TIdTCPServer;
    procedure CheckBox1Click(Sender: TObject);
    procedure IdTCPServer1Execute(AContext: TIdContext);
    procedure IdTCPServer1Connect(AContext: TIdContext);
    procedure FormCreate(Sender: TObject);
    procedure IdTCPServer1Disconnect(AContext: TIdContext);
    procedure IdTCPServer1Exception(AContext: TIdContext;
      AException: Exception);
  private
    procedure ShowStartServerdMessage;
    procedure StopStartServerdMessage;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StringServerForm: TStringServerForm;

implementation

{$R *.dfm}

procedure TStringServerForm.CheckBox1Click(Sender: TObject);
begin
  if ( CheckBox1.Checked = True ) then
    IdTCPServer1.Active := True
  else
    IdTCPServer1.Active := False;
end;

procedure TStringServerForm.FormCreate(Sender: TObject);
begin
  IdTCPServer1.Bindings.Add.IP   := '127.0.0.1';
  IdTCPServer1.Bindings.Add.Port := 6000;
end;

procedure TStringServerForm.IdTCPServer1Connect(AContext: TIdContext);
begin
  Memo1.Lines.Add('A client connected');
end;

procedure TStringServerForm.IdTCPServer1Disconnect(AContext: TIdContext);
begin
    Memo1.Lines.Add('A client disconnected');
end;

procedure TStringServerForm.IdTCPServer1Exception(AContext: TIdContext;
  AException: Exception);
begin
   Memo1.Lines.Add('A exception happend !');
end;


procedure TStringServerForm.ShowStartServerdMessage;
begin
  Memo1.Lines.Add('START SERVER  @' + TimeToStr(now));
end;

procedure TStringServerForm.StopStartServerdMessage;
begin
  Memo1.Lines.Add('STOP SERVER  @' + TimeToStr(now));
end;

procedure TStringServerForm.IdTCPServer1Execute(AContext: TIdContext);
var
  LLine: String;
begin
  TIdNotify.NotifyMethod( ShowStartServerdMessage );
  LLine := AContext.Connection.IOHandler.ReadLn(TIdTextEncoding.Default);
  Memo1.Lines.Add(LLine);
  AContext.Connection.IOHandler.WriteLn('OK');
  TIdNotify.NotifyMethod( StopStartServerdMessage );
end;

end.
