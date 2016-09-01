{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110625: echoclient.dpr 
{
{   Rev 1.0    25/10/2004 23:14:10  ANeillans    Version: 9.0.17
{ Verified
}
program echoclient;

uses
  {$IFDEF Linux}
  QForms,
  {$ELSE}
  Forms,
  {$ENDIF}
  main in 'main.pas' {formEchoTest};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformEchoTest, formEchoTest);
  Application.Run;
end.
