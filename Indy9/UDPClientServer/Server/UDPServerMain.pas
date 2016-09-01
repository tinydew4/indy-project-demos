{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110720: UDPServerMain.pas 
{
{   Rev 1.0    25/10/2004 23:31:26  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: UDP Server
 Author:    <unknown - please contact me to take credit! - Allen O'Neill>
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------
 Notes:

 Simple UDP server demo

Verified:
  Indy 9:
    D7: 25th Oct 2004 Andy Neillans

}

unit UDPServerMain;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, IdWinsock2, stdctrls,
  SysUtils, Classes, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,
  IdComponent, IdUDPBase, IdUDPClient, IdStack, IdUDPServer, IdSocketHandle;


type
  TUDPMainForm = class(TForm)
    SourceGroupBox: TGroupBox;
    HostNameLabel: TLabel;
    HostAddressLabel: TLabel;
    HostName: TLabel;
    HostAddress: TLabel;
    UDPServer: TIdUDPServer;
    UDPAntiFreeze: TIdAntiFreeze;
    PortLabel: TLabel;
    Port: TLabel;
    BufferSizeLabel: TLabel;
    BufferSize: TLabel;
    UDPMemo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure UDPServerUDPRead(Sender: TObject; AData: TStream; ABinding: TIdSocketHandle);
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

{$R *.DFM}

procedure TUDPMainForm.FormCreate(Sender: TObject);
begin
  HostName.Caption := UDPServer.LocalName;
  HostAddress.Caption := GStack.LocalAddress;
  Port.Caption := IntToStr(UDPServer.DefaultPort);
  BufferSize.Caption := IntToStr(UDPServer.BufferSize);
  UDPServer.Active := True;
end;

procedure TUDPMainForm.UDPServerUDPRead(Sender: TObject; AData: TStream; ABinding: TIdSocketHandle);
var
  DataStringStream: TStringStream;
  s: String;
begin
  DataStringStream := TStringStream.Create('');
  try
    DataStringStream.CopyFrom(AData, AData.Size);
    UDPMemo.Lines.Add('Received "' + DataStringStream.DataString + '" from ' + ABinding.PeerIP + ' on port ' + IntToStr(ABinding.PeerPort));
    s := 'Replied from ' + UDPServer.LocalName + ' to "' + DataStringStream.DataString + '"';
    ABinding.SendTo(ABinding.PeerIP, ABinding.PeerPort, s[1], Length(s));
  finally
    DataStringStream.Free;
  end;
end;


end.
