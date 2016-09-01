{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  57875: HTTPServer.dpr 
{
{   Rev 1.0    26/03/2004 18:33:20  ANeillans
{ Initial Check in
{ Verified with Indy 9 on D7
}
// NOTE: This demo ONLY runs under Windows.

program HTTPServer;

uses
  Forms,
  Main in 'Main.pas' {fmHTTPServerMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmHTTPServerMain, fmHTTPServerMain);
  Application.Run;
end.
