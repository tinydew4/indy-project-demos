{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  23299: telnetsrv.dpr 
{
{   Rev 1.0    12/09/2003 22:34:46  ANeillans
{ Initial Checking
{ Verified with Indy 9 and D7
}
{***************************************************************
*
* Project : Telnet Server
* Unit Name: telnetsrv
* Purpose : A simple Indy Telnet Server Demo
* Author : Siamak Sarmady (email: sarmadys@onlineprogrammer.org)
* Date : 07/02/2001 - 17:52:31
* History :
*
****************************************************************}

program telnetsrv;

uses
  Forms,
  telnetsrvmain in 'telnetsrvmain.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
