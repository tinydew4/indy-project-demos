{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  23290: Traceroute.dpr 
{
{   Rev 1.0    12/09/2003 22:20:24  ANeillans
{ Initial Checkin
}
program Traceroute;

uses
  {$IFDEF Linux}
  QForms,
  {$ELSE}
  Forms,
  {$ENDIF}
  fmTraceRouteMainU in 'fmTraceRouteMainU.pas' {fmTracertMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmTracertMain, fmTracertMain);
  Application.Run;
end.
