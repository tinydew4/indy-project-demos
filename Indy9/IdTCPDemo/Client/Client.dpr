{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110645: Client.dpr 
{
{   Rev 1.0    25/10/2004 23:14:16  ANeillans    Version: 9.0.17
{ Verified
}
program Client;

uses
  Forms,
  ClientFrmMainUnit in 'ClientFrmMainUnit.pas' {ClientFrmMain},
  GlobalUnit in 'GlobalUnit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TClientFrmMain, ClientFrmMain);
  Application.Run;
end.
