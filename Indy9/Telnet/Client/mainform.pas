{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  23294: mainform.pas 
{
{   Rev 1.1    25/10/2004 22:50:26  ANeillans    Version: 9.0.17
{ Verified
}
{
{   Rev 1.0    12/09/2003 22:27:10  ANeillans
{ Initial Checkin
}
{
  Demo Name:  Telnet Client
  Created By: Unknown
          On: 27/10/2002

  Notes:
    Telnet Client Demo.

  Version History:
    None

  Tested:
   Indy 9:
     D5:     Untested
     D6:     Untested
     D7:     25th Oct 2004 by Andy Neillans
}
unit mainform;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, ComCtrls, StdCtrls, Spin,
  SysUtils, Classes,  IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdTelnet;

type
  TfrmTelnetDemo = class(TForm)
    Memo1: TRichEdit;
    edtServer: TEdit;
    lblServer: TLabel;
    spnedtPort: TSpinEdit;
    lblPort: TLabel;
    btnConnect: TButton;
    btnDisconnect: TButton;
    sbrStatus: TStatusBar;
    Label1: TLabel;
    edtSendCommand: TEdit;
    IdTelnetDemo: TIdTelnet;
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
    procedure IdTelnetDemoConnected(Sender: TObject);
    procedure edtSendCommandKeyPress(Sender: TObject; var Key: Char);
    procedure IdTelnetDemoConnect(Sender: TObject);
    procedure IdTelnetDemoDataAvailable(Sender: TIdTelnet;
      const Buffer: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTelnetDemo: TfrmTelnetDemo;

implementation

{$R *.DFM}

procedure TfrmTelnetDemo.btnConnectClick(Sender: TObject);
begin
  btnConnect.Enabled := False;
  btnDisconnect.Enabled := True;
  IDTelnetDemo.Host := edtServer.Text;
  IDTelnetDemo.port := spnedtPort.Value;
  IdTelnetDemo.Connect;
end;

procedure TfrmTelnetDemo.btnDisconnectClick(Sender: TObject);
begin
  btnConnect.Enabled := True;
  btnDisconnect.Enabled := False;
  IdTelnetDemo.Disconnect;
end;

procedure TfrmTelnetDemo.Memo1KeyPress(Sender: TObject;
  var Key: Char);
begin
  {we simply send the key stroke to the server.  It may echo it back to us}
  if IdTelnetDemo.Connected then
    IdTelnetDemo.SendCh(Key);
  Key := #0;
end;

procedure TfrmTelnetDemo.IdTelnetDemoConnected(Sender: TObject);
begin
  sbrStatus.SimpleText := 'Connected';
end;


procedure TfrmTelnetDemo.edtSendCommandKeyPress(Sender: TObject;
  var Key: Char);
var
  i : integer;
  s : string;
begin
if IdTelnetDemo.Connected then
  if (key = #13) then
   begin
    s := edtSendCommand.text;
    for i := 1 to length(s) do
      IdTelnetDemo.SendCh(s[i]);
    IdTelnetDemo.SendCh(#13);
    edtSendCommand.Clear;
    edtSendCommand.SetFocus;
   end;

end;

procedure TfrmTelnetDemo.IdTelnetDemoConnect(Sender: TObject);
begin
sbrStatus.SimpleText := 'Connect';
end;

procedure TfrmTelnetDemo.IdTelnetDemoDataAvailable(Sender: TIdTelnet;
  const Buffer: String);
{This routine comes directly from the ICS TNDEMO code. Thanks to Francois Piette
 It updates the memo control when we get data}
const
    CR = #13;
    LF = #10;
var
    Start, Stop : Integer;
begin
  if Memo1.Lines.Count = 0 then
      Memo1.Lines.Add('');

  Start := 1;
  Stop  := Pos(CR, Buffer);
  if Stop = 0 then
      Stop := Length(Buffer) + 1;
  while Start <= Length(Buffer) do begin
      Memo1.Lines.Strings[Memo1.Lines.Count - 1] :=
          Memo1.Lines.Strings[Memo1.Lines.Count - 1] +
          Copy(Buffer, Start, Stop - Start);
      if Buffer[Stop] = CR then begin
          Memo1.Lines.Add('');
          {$IFNDEF Linux}
          SendMessage(Memo1.Handle, WM_KEYDOWN, VK_UP, 1);
          {$ENDIF}
      end;
      Start := Stop + 1;
      if Start > Length(Buffer) then
          Break;
      if Buffer[Start] = LF then
         Start := Start + 1;
      Stop := Start;
      while (Buffer[Stop] <> CR) and (Stop <= Length(Buffer)) do
          Stop := Stop + 1;
  end;

end;

end.
