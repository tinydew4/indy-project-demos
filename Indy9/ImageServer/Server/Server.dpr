{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110840: Server.dpr 
{
{   Rev 1.0    26/10/2004 13:04:58  ANeillans    Version: 9.0.17
{ Verified
}
// NOTE: This demo ONLY runs under Windows.

program Server;

uses
  Forms,
  fServer in 'fServer.pas' {frmServer};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Image Server';
  Application.CreateForm(TfrmServer, frmServer);
  Application.Run;
end.
