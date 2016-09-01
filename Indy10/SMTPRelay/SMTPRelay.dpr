{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  23285: SMTPRelay.dpr 
{
{   Rev 1.0    12/09/2003 21:50:24  ANeillans
{ Intial Checkin
{ Verified with D7 and Indy 9
{ Added an event log and a few more comments
}
program SMTPRelay;

uses
  Forms,
  fMain in 'fMain.pas' {frmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
