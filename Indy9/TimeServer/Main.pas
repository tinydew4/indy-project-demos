{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110739: Main.pas 
{
{   Rev 1.0    25/10/2004 23:43:42  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: Main
 Author:    <unknown - please contact me to claim credit! - Allen O'Meill>
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------
 Notes:

 Demonstrates basic use of the TimeServer

Verified:
  Indy 9:
    D7 : 25th Oct 2004 Andy Neillans
}


unit Main;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls,
  SysUtils, Classes, IdComponent, IdTCPServer, IdTimeServer, IdBaseComponent;

type
  TfrmMain = class(TForm)
    IdTimeServer1: TIdTimeServer;
    Label1: TLabel;
    lblStatus: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure IdTimeServer1Connect(AThread: TIdPeerThread);
    procedure IdTimeServer1Disconnect(AThread: TIdPeerThread);
  private
  public
  end;

var
  frmMain: TfrmMain;

implementation
{$R *.DFM}

// No Code required - TimeServer is functional as is.
 procedure TfrmMain.FormActivate(Sender: TObject);
begin
  try
    IdTimeServer1.Active := True;
  except
    ShowMessage('Permission Denied. Cannot bind reserved port due to security reasons');
    Application.Terminate;
  end;
end;


procedure TfrmMain.IdTimeServer1Connect(AThread: TIdPeerThread);
begin
lblStatus.caption := '[ Client connected ]';
end;

procedure TfrmMain.IdTimeServer1Disconnect(AThread: TIdPeerThread);
begin
lblStatus.caption := '[ idle ]';
end;

end.
