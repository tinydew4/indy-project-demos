{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110874: rshMain.pas 
{
{   Rev 1.0    26/10/2004 13:05:08  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: RSH Server demo
 Author:    <unknown - please contact me to get credit ! - Allen O'Neill>
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------
 Notes:

Verified
  Indy 9
    D7 26th Oct 2004 Andy Neillans
}

unit rshMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdTCPClient, IdComponent, IdTCPServer, IdRemoteCMDServer, IdRSHServer,
  StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    IdRSHServer1: TIdRSHServer;
    BitBtn1: TBitBtn;
    procedure IdRSHServer1Command(AThread: TIdPeerThread;
      AStdError: TIdTCPClient; AClientUserName, AHostUserName,
      ACommand: String);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.IdRSHServer1Command(AThread: TIdPeerThread;
  AStdError: TIdTCPClient; AClientUserName, AHostUserName,
  ACommand: String);
begin
  IdRSHServer1.SendResults(AThread,AStdError,'RSH Demo Program');
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
 Close;
end;

end.
