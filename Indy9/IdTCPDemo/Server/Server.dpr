{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110637: Server.dpr 
{
{   Rev 1.0    25/10/2004 23:14:14  ANeillans    Version: 9.0.17
{ Verified
}
program Server;

uses
  Forms,
  ServerFrmMainUnit in 'ServerFrmMainUnit.pas' {ServerFrmMain},
  GlobalUnit in 'GlobalUnit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TServerFrmMain, ServerFrmMain);
  Application.Run;
end.
