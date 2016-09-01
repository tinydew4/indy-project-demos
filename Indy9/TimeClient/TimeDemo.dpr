{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110731: TimeDemo.dpr 
{
{   Rev 1.0    25/10/2004 23:43:38  ANeillans    Version: 9.0.17
{ Verified
}
program timedemo;

uses
  {$IFDEF Linux}
  QForms,
  {$ELSE}
  Forms,
  {$ENDIF}
  Main in 'Main.pas' {frmTimeDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTimeDemo, frmTimeDemo);
  Application.Run;
end.
