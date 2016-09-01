{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110600: MainForm.pas 
{
{   Rev 1.0    25/10/2004 23:04:28  ANeillans    Version: 9.0.17
{ Verified
}
{
Verified:
  Indy 9:
  D7: 25th Oct 2004 by Andy Neillans
}

unit MainForm;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, ToolWin, ComCtrls,
  Menus, Buttons, Spin, SysUtils, Classes, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    edUserName: TEdit;
    Label2: TLabel;
    edServer: TEdit;
    Label3: TLabel;
    lbClients: TListBox;
    Label4: TLabel;
    memLines: TMemo;
    Label5: TLabel;
    edMessage: TEdit;
    SpeedButton1: TSpeedButton;
    IdTCPClient1: TIdTCPClient;
    Timer1: TTimer;
    Label6: TLabel;
    sePort: TSpinEdit;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure IdTCPClient1Connected(Sender: TObject);
    procedure edMessageKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormShow(Sender: TObject);
begin
  width := width + 1;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Com,
  Msg : String;
begin
  if not IdTcpClient1.Connected then
    exit;

  Msg := IdTCPClient1.ReadLn('', 5);

  if Msg <> '' then
    if Msg[1] <> '@' then
      begin
      { Not a system command }
        memLines.Lines.Add(Msg);
      end
    else
      begin
      { System command }
        Com := UpperCase(Trim(Copy(Msg, 2, Pos(':', Msg) -2)));
        Msg := UpperCase(Trim(Copy(Msg, Pos(':', Msg) +1, Length(Msg))));
        if Com = 'CLIENTS' then
          lbClients.Items.CommaText := Msg;
      end;

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if (edUserName.Text <> '') and
     (edServer.Text <> '')   and
     SpeedButton1.Down then
    begin
      IdTCPClient1.Host := edServer.Text;
      IdTCPClient1.Port := sePort.Value;
      if SpeedButton1.Down then
        IdTCPClient1.Connect;
    end
  else
    begin
      if (edUserName.Text = '') or
         (edServer.Text = '')   then
        ShowMessage('You must put in a User Name and server name to connect.');
      SpeedButton1.Down := false;
    end;
end;

procedure TForm1.IdTCPClient1Connected(Sender: TObject);
begin
  IdTCPClient1.WriteLn(edUserName.Text);
end;

procedure TForm1.edMessageKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      IdTCPClient1.WriteLn(edMessage.Text);
      edMessage.Text := '';
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  IdTCPClient1.WriteLn('@' + 'CLIENTS:REQUEST');
end;

end.
