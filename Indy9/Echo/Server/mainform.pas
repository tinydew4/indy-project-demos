{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110621: mainform.pas 
{
{   Rev 1.0    25/10/2004 23:14:08  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: Echo server
 Author:    <unknown - please contact me to take credit! - Allen O'Neill>
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------
 Notes:

 No coding is required.  Echo server is ready to go by setting Active to True

 Verified:
  Indy 9:
    D7: 25th Oct 2004 by Andy Neillans
}


unit mainform;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls,
  SysUtils, Classes, IdBaseComponent, IdComponent, IdTCPServer,
  IdEchoServer;

type
  TForm1 = class(TForm)
    IdECHOServer1: TIdECHOServer;
    Label1: TLabel;
    lblStatus: TLabel;
    btnExit: TButton;
    procedure FormActivate(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure IdECHOServer1Connect(AThread: TIdPeerThread);
    procedure IdECHOServer1Disconnect(AThread: TIdPeerThread);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

 procedure TForm1.FormActivate(Sender: TObject);
begin
  try
    IdECHOServer1.Active := True;
  except
    ShowMessage('Permission Denied. Cannot bind reserved port due to security reasons');
    Application.Terminate;
  end;
end;


procedure TForm1.btnExitClick(Sender: TObject);
begin
if IdECHOServer1.active then
    IdECHOServer1.active := false;
Application.terminate;
end;

procedure TForm1.IdECHOServer1Connect(AThread: TIdPeerThread);
begin
lblStatus.caption := '[ Serving client ]';
end;

procedure TForm1.IdECHOServer1Disconnect(AThread: TIdPeerThread);
begin
lblStatus.caption := '[ idle - waiting next client ]';
end;

end.
