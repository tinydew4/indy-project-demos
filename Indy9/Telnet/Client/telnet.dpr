{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  23296: telnet.dpr 
{
{   Rev 1.0    12/09/2003 22:27:10  ANeillans
{ Initial Checkin
}
// NOTE: This demo ONLY runs under Windows.

program telnet;

uses
  Forms,
  mainform in 'mainform.pas' {frmTelnetDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTelnetDemo, frmTelnetDemo);
  Application.Run;
end.
