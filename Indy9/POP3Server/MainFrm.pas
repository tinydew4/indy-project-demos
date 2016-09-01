{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  22918: MainFrm.pas 
{
{   Rev 1.2    25/10/2004 22:49:28  ANeillans    Version: 9.0.17
{ Verified
}
{
{   Rev 1.1    12/09/2003 21:18:36  ANeillans
{ Verified with Indy 9 on D7.
{ Added instruction memo.
}
{
{   Rev 1.0    10/09/2003 20:40:48  ANeillans
{ Initial Import (Used updated version - not original 9 Demo)
}
{
  Demo Name:  POP3 Server
  Created By: Siamak Sarmady
          On: 27/10/2002

  Notes:
   Demonstrates POP3 server events (by way of comment - NOT functional!)

  Version History:
   12th Sept 03: Andy Neillans
                 Added the comments memo on the form for information.
   8th July 03:  Andy Neillans
                 Fixed the demo for I9.014
   Unknown:      Allen O'Neill
                 Added in some missing command handler comments

  Tested:
   Indy 9:
     D5:     Untested
     D6:     Untested
     D7:     25th Oct 2004 by Andy Neillans
             Tested with Telnet and Outlook Express 6
}
unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPServer, IdPOP3Server, StdCtrls;

type
  TfrmMain = class(TForm)
    btnExit: TButton;
    IdPOP3Server1: TIdPOP3Server;
    moComments: TMemo;
    procedure btnExitClick(Sender: TObject);
    procedure IdPOP3Server1Connect(AThread: TIdPeerThread);
    procedure FormActivate(Sender: TObject);
    procedure IdPOP3Server1CheckUser(AThread: TIdPeerThread;
      LThread: TIdPOP3ServerThread);
    procedure IdPOP3Server1DELE(ASender: TIdCommand; AMessageNum: Integer);
    procedure IdPOP3Server1Exception(AThread: TIdPeerThread;
      AException: Exception);
    procedure IdPOP3Server1LIST(ASender: TIdCommand; AMessageNum: Integer);
    procedure IdPOP3Server1QUIT(ASender: TIdCommand);
    procedure IdPOP3Server1RETR(ASender: TIdCommand; AMessageNum: Integer);
    procedure IdPOP3Server1RSET(ASender: TIdCommand);
    procedure IdPOP3Server1STAT(ASender: TIdCommand);
    procedure IdPOP3Server1TOP(ASender: TIdCommand; AMessageNum,
      ANumLines: Integer);
    procedure IdPOP3Server1UIDL(ASender: TIdCommand; AMessageNum: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

//If user presses exit button close socket and exit
procedure TfrmMain.btnExitClick(Sender: TObject);
begin
 if IdPop3Server1.Active=True then
  IdPop3Server1.Active:=False;
 Application.Terminate;
end;

procedure TfrmMain.IdPOP3Server1Connect(AThread: TIdPeerThread);
begin
// When a clinet connects to our server we must reply with +OK, or -ERR
// Set this via Greeting.Text at runtime, or possibly in OnBeforeCommandHandler?
// You may also wish to initialise some global vars here, set the POP3 box to locked state, etc.
end;

//Activate the server socket when activating server main window.
procedure TfrmMain.FormActivate(Sender: TObject);
begin
 IdPop3Server1.Active:=True;
end;

// This is where you validate the user/pass credentials of the user logging in
procedure TfrmMain.IdPOP3Server1CheckUser(AThread: TIdPeerThread;
  LThread: TIdPOP3ServerThread);
begin
// LThread.Username -> examine this for valid username
// LThread.Password -> examine this for valid password
// if the user/pass pair are valid, then respond with
// LThread.State := Trans
// to reject the user/pass pair, do not change the state
 LThread.State := Trans;
end;

// This is where the client program issues a delete command for a particular message
procedure TfrmMain.IdPOP3Server1DELE(ASender: TIdCommand;
  AMessageNum: Integer);
begin
// if the message has been deleted, then return a success command as follows;
// ASender.Thread.Connection.Writeln('+OK - Message ' + IntToStr(AMessageNum) + ' Deleted')
// otherwise, if there was an error in deleting the message, or the message number
// did not exist in the first place, then return the following:
// ASender.Thread.Connection.Writeln('-ERR - Message ' + IntToStr(AMessageNum) + ' not deleted because.... [reason]')

// Usually, messages are deleted after being retrieved from pop3 server
// This is done when client sents DELE command after retrieving a message
// Client command is something like DELE 1 which means delete message 1

// Note, you should not actually delete the message at this point, just mark it as deleted.
// Deletions should be handled at the QUIT event.

 ASender.Thread.Connection.WriteLn('+OK message 1 deleted');
end;

procedure TfrmMain.IdPOP3Server1Exception(AThread: TIdPeerThread;
  AException: Exception);
begin
// Handle any exceptions given by the thread here
end;

//before retrieving messages, client asks for a list  of messages
//Server responds with a +OK followed by number of deliverable
//messages and length of messages in bytes. After this a separate
//list of each message and its length is sent to client.
//here we have only one message, but we can continue with message
//number and its length , one per line and finally a '.' character.
//Format of client command is  LIST
procedure TfrmMain.IdPOP3Server1LIST(ASender: TIdCommand;
  AMessageNum: Integer);
begin
// Here you return a list of available messages to the client
 ASender.Thread.Connection.WriteLn('+OK 1 40');
 ASender.Thread.Connection.WriteLn('1 40');
 ASender.Thread.Connection.WriteLn('.');
 // The trailing . line is IMPORTANT!!
end;

procedure TfrmMain.IdPOP3Server1QUIT(ASender: TIdCommand);
begin
// This event is triggered on a client QUIT (a correct disconnect)
// Here you should delete any messages that have been marked with DELE.

// NOTE: The +OK response is AUTOMATICALLY sent back to the client, and the connect dropped.
end;

procedure TfrmMain.IdPOP3Server1RETR(ASender: TIdCommand;
  AMessageNum: Integer);
begin
 // Client initiates retrieving each message by issuing a RETR command
 // to server. Server will respond by +OK and will continue by sending
 // message itself. Each message is saved in a database uppon arival
 // by smtp server and is now delivered to user mail agent by pop3 server.
 // Here we do not read mail from a storage but we deliver a sample
 // mail from inside program. We can deliver multiple mails using
 // this method.  Format of RETR command is something like
 // RETR 1 or RETR 2 etc.
 ASender.Thread.Connection.WriteLn('+OK 40 octets');
 ASender.Thread.Connection.WriteLn('From: demo@projectindy.org');
 ASender.Thread.Connection.WriteLn('To: you@yourdomain.com ');
 ASender.Thread.Connection.WriteLn('Subject: Hello ');
 ASender.Thread.Connection.WriteLn('');
 ASender.Thread.Connection.WriteLn('Hello world! This is email body.');
 ASender.Thread.Connection.WriteLn('.');
end;

procedure TfrmMain.IdPOP3Server1RSET(ASender: TIdCommand);
begin
// here is where the client wishes to reset the current state
// This may be used to reset a list of pending deletes, etc.
end;

procedure TfrmMain.IdPOP3Server1STAT(ASender: TIdCommand);
begin
// here is where the client has asked for the Status of the mailbox
//When client asks for a statistic of messages server will answer
//by sending an +OK followed by number of messages and length of them
//Format of client message is STAT
 ASender.Thread.Connection.WriteLn('+OK 1 40');
end;

procedure TfrmMain.IdPOP3Server1TOP(ASender: TIdCommand; AMessageNum,
  ANumLines: Integer);
begin
// This is where the cleint has requested the TOP X lines of a particular
// message to be sent to them
end;

procedure TfrmMain.IdPOP3Server1UIDL(ASender: TIdCommand;
  AMessageNum: Integer);
begin
// This is where the client has requested the unique identifier (UIDL) of each
// message, or a particular message to be sent to them.
end;

end.
