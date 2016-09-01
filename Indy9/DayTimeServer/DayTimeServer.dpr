{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110608: DayTimeServer.dpr 
{
{   Rev 1.0    25/10/2004 23:07:52  ANeillans    Version: 9.0.17
{ Verified
}
program DayTimeServer;

uses
  {$IFDEF Linux}
  QForms,
  {$ELSE}
  Forms,
  {$ENDIF}
  mainform in 'mainform.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
