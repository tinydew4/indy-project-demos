{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110712: UDPClient.dpr 
{
{   Rev 1.0    25/10/2004 23:31:22  ANeillans    Version: 9.0.17
{ Verified
}
program UDPClient;

uses
  {$IFDEF Linux}
  QForms,
  {$ELSE}
  Forms,
  {$ENDIF}
  UDPClientMain in 'UDPClientMain.pas' {UDPMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TUDPMainForm, UDPMainForm);
  Application.Run;
end.
