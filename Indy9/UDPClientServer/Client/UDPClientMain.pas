{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110714: UDPClientMain.pas 
{
{   Rev 1.0    25/10/2004 23:31:24  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: UDP Client
 Author:    <unknown - please contact me to take credit! - Allen O'Neill>
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------
 Notes:

 Simple UDP client demo

 Verified;
  Indy 9:
    D7: 25th Oct 2004 Andy Neillans
}


unit UDPClientMain;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, IdWinsock2,   stdctrls,
  SysUtils, Classes, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,
  IdComponent, IdUDPBase, IdUDPClient, IdStack;

type
  TUDPMainForm = class(TForm)
    SourceGroupBox: TGroupBox;
    HostNameLabel: TLabel;
    HostAddressLabel: TLabel;
    HostName: TLabel;
    HostAddress: TLabel;
    UDPAntiFreeze: TIdAntiFreeze;
    PortLabel: TLabel;
    Port: TLabel;
    DestinationLabel: TLabel;
    DestinationAddress: TLabel;
    BufferSizeLabel: TLabel;
    BufferSize: TLabel;
    UDPMemo: TMemo;
    SendButton: TButton;
    UDPClient: TIdUDPClient;
    procedure FormCreate(Sender: TObject);
    procedure SendButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UDPMainForm: TUDPMainForm;

implementation

const
  HOSTNAMELENGTH = 80;
  RECIEVETIMEOUT = 5000; // milliseconds

{$R *.DFM}

procedure TUDPMainForm.FormCreate(Sender: TObject);
begin
  Randomize; // remove if you want reproducible results.
  HostName.Caption := UDPClient.LocalName;
  HostAddress.Caption := GStack.LocalAddress;
  Port.Caption := IntToStr(UDPClient.Port);
  DestinationAddress.Caption := UDPClient.Host;
  BufferSize.Caption := IntToStr(UDPClient.BufferSize);
  UDPClient.ReceiveTimeout := RECIEVETIMEOUT;
end;

procedure TUDPMainForm.SendButtonClick(Sender: TObject);
var
  MessageID: Integer;
  ThisMessage: String;
  ReceivedString: String;
begin
  MessageID := Random(MAXINT);
  ThisMessage := 'Message: ' + IntToStr(MessageID);
  UDPMemo.Lines.Add('Sending ' + ThisMessage);
  UDPClient.Send(ThisMessage);
  ReceivedString := UDPClient.ReceiveString();
  if ReceivedString = '' then
    UDPMemo.Lines.Add('No response received from the server after ' + IntToStr(UDPClient.ReceiveTimeout) + ' millseconds.')
  else
    UDPMemo.Lines.Add('Received: ' + ReceivedString)
end;

end.
