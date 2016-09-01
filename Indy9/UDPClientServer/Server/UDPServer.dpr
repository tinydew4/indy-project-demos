{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110718: UDPServer.dpr 
{
{   Rev 1.0    25/10/2004 23:31:24  ANeillans    Version: 9.0.17
{ Verified
}
program UDPServer;

uses
  {$IFDEF Linux}
  QForms,
  {$ELSe}
  Forms,
  {$ENDIF}
  UDPServerMain in 'UDPServerMain.pas' {UDPMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TUDPMainForm, UDPMainForm);
  Application.Run;
end.
