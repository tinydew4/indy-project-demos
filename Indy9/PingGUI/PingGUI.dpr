{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  23315: PingGUI.dpr 
{
{   Rev 1.0    12/09/2003 23:02:58  ANeillans
{ Initial Checkin.
{ Minor GUI Updates
{ Verified against Indy 9 and D7
}
program PingGUI;

uses
  {$IFDEF Linux}
  QForms,
  {$ELSE}
  Forms,
  {$ENDIF}
  Main in 'Main.pas' {frmPing};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPing, frmPing);
  Application.Run;
end.
