{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110610: mainform.pas 
{
{   Rev 1.0    25/10/2004 23:07:54  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: mainform
 Author:    <unknown - please contact me to take credit ! - Allen O'Neill >
 Copyright: Indy Pit Crew
-----------------------------------------------------------------------------
 Notes:

 Demonstrates the use of DayTimeServer ... objective is simply to issue the current
 date and time to any client who connects. All functionality is inbuilt into component

Verified:
  Indy 9:
    D7: 25th Oct 2004 by Andy Neillans 
}

unit mainform;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs,
  SysUtils, Classes,
  IdComponent, IdTCPServer, IdDayTimeServer, IdBaseComponent, StdCtrls;

type
  TfrmMain = class(TForm)
    IdDayTimeServer1: TIdDayTimeServer;
    Button1: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  frmMain: TfrmMain;

implementation
{$R *.DFM}

// No Code required - DayTimeServer is functional as is.
 procedure TfrmMain.FormActivate(Sender: TObject);
begin
  try
    IdDayTimeServer1.Active := True;
    ShowMessage('Daytime server active - use telnet to connect to port 13 on this machine to test !');
  except
  on E : Exception do
    ShowMessage('Permission Denied. Cannot bind reserved port.' + #13+#13 + '');
  end;
end;


procedure TfrmMain.Button1Click(Sender: TObject);
begin
 Close;
end;

end.
