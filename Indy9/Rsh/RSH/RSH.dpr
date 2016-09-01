{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110878: RSH.dpr 
{
{   Rev 1.0    26/10/2004 13:05:08  ANeillans    Version: 9.0.17
{ Verified
}
program RSH;

uses
  Forms,
  rshmain in 'rshmain.pas' {frmMainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMainForm, frmMainForm);
  Application.Run;
end.
