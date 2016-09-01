{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110546: Client.dpr 
{
{   Rev 1.0    25/10/2004 22:57:18  ANeillans    Version: 9.0.17
{ Verified
}
{
{   Rev 1.0    25/10/2004 22:55:40  ANeillans    Version: 9.0.17
{ Verified
}
program Client;

uses
  Forms,
  fMain in 'fMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
