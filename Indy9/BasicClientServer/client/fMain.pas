{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110548: fMain.pas 
{
{   Rev 1.0    25/10/2004 22:57:20  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: fMain
 Author:    Allen O'Neill
 Purpose:   Basic TCP client demo
 History:
 Date:      13/07/2002 00:55:23
-----------------------------------------------------------------------------

  Notes:

  Demonstrates the following functions:

  (1) ReadLn, WriteLn, ReadInteger
  (2) Using the OnConnect and OnDisconnect events

  Verified:
  Indy 9:
    D7: 25th Oct 2004 by Andy Neillans  
}


unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edtHost: TEdit;
    Label3: TLabel;
    edtPort: TEdit;
    btnConnect: TButton;
    btnDisconnect: TButton;
    Bevel1: TBevel;
    cboCommands: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    lbCommunication: TListBox;
    btnExit: TButton;
    btnSendCommand: TButton;
    IdTCPClient: TIdTCPClient;
    procedure btnExitClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnSendCommandClick(Sender: TObject);
    procedure IdTCPClientDisconnected(Sender: TObject);
    procedure IdTCPClientConnected(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  procedure LockControls(ALock:Boolean);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
application.terminate;
end;

procedure TfrmMain.LockControls(ALock: Boolean);
var
    i : integer;
begin
for i := 0 to componentcount-1 do
    if TControl(Components[i]).Tag = 99 then
        TControl(Components[i]).Enabled := ALock;
end;

procedure TfrmMain.btnDisconnectClick(Sender: TObject);
begin
if IdTCPClient.Connected then
    try
    IdTCPClient.Disconnect; // we can disconnect from either the server or the client side
    btnConnect.Enabled := true;
    btnDisconnect.Enabled := false;
    except on E : Exception do
        ShowMessage(E.Message);
    end;
end;

procedure TfrmMain.btnConnectClick(Sender: TObject);
begin
lbCommunication.Items.Clear;

with IdTCPClient do
    begin
    Host := edtHost.Text;
    Port := StrToint(edtPort.Text);
      try
      Connect; // add a timeout here if you wish, eg: Connect(3000) = timeout after 3 seconds.

      btnConnect.Enabled := false;
      btnDisconnect.Enabled := true;

      except
      on E : Exception do
          begin
          LockControls(True);
          ShowMessage(E.Message);
          end;
      end;
    end;

end;

procedure TfrmMain.btnSendCommandClick(Sender: TObject);
var
    LCommand, LInString : String;
    LInInteger : integer;
begin
LCommand := cboCommands.Text;
LInInteger := -1;

with IdTCPClient do
    begin
      try
      WriteLn(LCommand);
      case cboCommands.ItemIndex of
        0: LInString := ReadLn;
        1: LInString := ReadLn;
        2: LInInteger := ReadInteger;
        3: LInString := ReadLn;
        4: LInString := ReadLn;
      end;

      if LInInteger <> -1 then
        LInString := IntToStr(LInInteger);

      lbCommunication.Items.Insert(0,'We said -> ' + LCommand);
      lbCommunication.Items.Insert(0,'Server said -> ' + LInString);

      except
      on E : Exception do
          begin
          LockControls(True);
          ShowMessage(E.Message);
          end;
      end;
    end;


end;

procedure TfrmMain.IdTCPClientDisconnected(Sender: TObject);
begin
lbCommunication.Items.Insert(0,'Disconnected from remote server');
LockControls(false);
end;

procedure TfrmMain.IdTCPClientConnected(Sender: TObject);
var
    LString : String;
begin
LString := IdTCPClient.ReadLn;
lbCommunication.Items.Insert(0,'Connected to remote server');
lbCommunication.Items.Insert(0,'Server said -> ' + LString);
LockControls(true);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
if cboCommands.Items.Count > 0 then
    begin
    cboCommands.ItemIndex := 0;
    cboCommands.Text := cboCommands.Items.Strings[cboCommands.ItemIndex];
    end;
end;

end.
