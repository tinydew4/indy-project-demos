{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  22916: pop3server.dpr 
{
{   Rev 1.1    12/09/2003 21:18:34  ANeillans
{ Verified with Indy 9 on D7.
{ Added instruction memo.
}
{
{   Rev 1.0    10/09/2003 20:40:48  ANeillans
{ Initial Import (Used updated version - not original 9 Demo)
}
{***************************************************************
*
* Project : pop3server
* Unit Name: pop3server
* Purpose : A simple Indy pop3 server demo
* Author : Siamak Sarmady (email: sarmadys@onlineprogrammer.org)
* Date : 07/02/2001 - 17:52:31
* History :
*
****************************************************************}
program pop3server;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {frmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
