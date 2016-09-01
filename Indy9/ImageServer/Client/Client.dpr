{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110860: Client.dpr 
{
{   Rev 1.0    26/10/2004 13:05:04  ANeillans    Version: 9.0.17
{ Verified
}
// NOTE: This demo ONLY runs under Windows.

program Client;

uses
  Forms,
  fClient in 'fClient.pas' {frmClient};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Indy Image Client';
  Application.CreateForm(TfrmClient, frmClient);
  Application.Run;
end.
