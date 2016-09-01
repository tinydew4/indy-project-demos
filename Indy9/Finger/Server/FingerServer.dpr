{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110688: FingerServer.dpr 
{
{   Rev 1.0    25/10/2004 23:31:16  ANeillans    Version: 9.0.17
{ Verified
}
program fingerserver;

uses
  {$IFDEF Linux}
  QForms,
  {$ELSE}
  Forms,
  {$ENDIF}
  mainform in 'mainform.pas' {frmFingerServer};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFingerServer, frmFingerServer);
  Application.Run;
end.
