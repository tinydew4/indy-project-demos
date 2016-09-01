{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110627: main.pas 
{
{   Rev 1.0    25/10/2004 23:14:10  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: Echo server
 Author:    <unknown - please contact me to take credit! - Allen O'Neill>
 Copyright: Indy Pit Crew
 Purpose:
 History:
 Date:      27/10/2002 00:51:54
-----------------------------------------------------------------------------
 Notes:

 Basic demo to show echo client in use

Verified:
  Indy 9:
    D7: 25th Oct 2004 by Andy Neillans
}

unit main;

interface

uses

  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls, 
  SysUtils, Classes, IdComponent, IdTCPConnection, IdTCPClient, IdEcho,
  IdBaseComponent;

type
  TformEchoTest = class(TForm)
    edtSendText: TEdit;
    lblTextToEcho: TLabel;
    lblTotalTime: TLabel;
    edtEchoServer: TEdit;
    lblEchoServer: TLabel;
    btnConnect: TButton;
    btnDisconnect: TButton;
    IdEcoTestConnection: TIdEcho;
    lblReceivedText: TLabel;
    Button1: TButton;
    lablTime: TLabel;
    lablReceived: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure edtEchoServerChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  formEchoTest: TformEchoTest;

implementation

{$R *.DFM}

procedure TformEchoTest.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  IdEcoTestConnection.Disconnect;
end;

procedure TformEchoTest.btnConnectClick(Sender: TObject);
begin
  try
    IdEcoTestConnection.Connect;
    {we only can echo after we connect to the server}
    edtSendText.Enabled := True;
    edtSendText.color := clWhite;
    btnConnect.Enabled := False;
    btnDisconnect.Enabled := True;
  except
    IdEcoTestConnection.Disconnect;
  end; //try..except
end;

procedure TformEchoTest.btnDisconnectClick(Sender: TObject);
begin
  IdEcoTestConnection.Disconnect;
  btnConnect.Enabled := True;
  edtSendText.Enabled := False;
  edtSendText.color := clSilver;
  btnDisconnect.Enabled := False;
end;

procedure TformEchoTest.edtEchoServerChange(Sender: TObject);
begin
  IdEcoTestConnection.Host := edtEchoServer.Text;
end;

procedure TformEchoTest.Button1Click(Sender: TObject);
begin
  {This echos the text to the server}
  lablReceived.Caption := IdEcoTestConnection.Echo ( edtSendText.Text );
  {This displays the round trip time}
  lablTime.Caption := IntToStr ( IdEcoTestConnection.EchoTime );
end;

end.
