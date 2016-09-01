{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110866: main.pas 
{
{   Rev 1.0    26/10/2004 13:05:04  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: RExec Demo Server
 Author:    JP Mugass
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------
 Notes:

 This is not so much a demo program for a Rexec server
 but a program for testing it with some other client implementations

Verified:
  Indy 9:
    D7: 26th Oct 2004 Andy Neillans
}

unit main;

interface

uses
  Windows, Messages, IdTCPServer, IdRexecServer, IdTCPClient, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdRemoteCMDServer, StdCtrls;

type
  TForm1 = class(TForm)
    IdRexecServer1: TIdRexecServer;
    Button1: TButton;
    procedure IdRexecServer1Command(AThread: TIdPeerThread;
      AStdError: TIdTCPClient; AUserName, APassword, ACommand: String);
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

procedure TForm1.IdRexecServer1Command(AThread: TIdPeerThread;
  AStdError: TIdTCPClient; AUserName, APassword, ACommand: String);
begin
  If ACommand <> 'TEST' then
  begin
    IdRexecServer1.SendError(AThread, AStdError, 'Error: '+AUserName+':'+APassword+':'+ACommand+' is not a valid task');
  end
  else
  begin
    IdRexecServer1.SendResults(AThread, AStdError, 'Success: '+AUserName+':'+APassword+':'+ACommand);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Close;
end;

end.
