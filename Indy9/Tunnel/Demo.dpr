{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110892: Demo.dpr 
{
{   Rev 1.0    26/10/2004 13:05:12  ANeillans    Version: 9.0.17
{ Verified
}
program Demo;

uses
  {$IFDEF Linux}
  QForms,
  {$ELSE}
  Forms,
  {$ENDIF}
  Main in 'Main.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
