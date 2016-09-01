{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110876: RSHServer.dpr 
{
{   Rev 1.0    26/10/2004 13:05:08  ANeillans    Version: 9.0.17
{ Verified
}
program RSHServer;

uses
  Forms,
  rshMain in 'rshMain.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
