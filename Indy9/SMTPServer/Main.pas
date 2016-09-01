{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  23278: Main.pas 
{
{   Rev 1.0.1.0    25/10/2004 22:49:48  ANeillans    Version: 9.0.17
{ Verified
}
{
{   Rev 1.0    12/09/2003 21:41:36  ANeillans
{ Initial Checking.
{ Verified with Indy 9 and D7
}
{
  Demo Name:  SMTP Server
  Created By: Andy Neillans
          On: 27/10/2002

  Notes:
   Demonstration of SMTPServer (by use of comments only!!)
   Read the RFC to understand how to store and manage server data, and
   therefore be able to use this component effectivly.

  Version History:
    12th Sept 03: Andy Neillans
                  Cleanup. Added some basic syntax checking for example.
     
  Tested:
   Indy 9:
     D5:     Untested
     D6:     Untested
     D7:     25th Oct 2004 by Andy Neillans
             Tested with Telnet and Outlook Express 6
}
unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPServer, IdSMTPServer, StdCtrls,
  IdMessage, IdEMailAddress;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ToLabel: TLabel;
    FromLabel: TLabel;
    SubjectLabel: TLabel;
    IdSMTPServer1: TIdSMTPServer;
    Label4: TLabel;
    btnServerOn: TButton;
    btnServerOff: TButton;
    procedure IdSMTPServer1CommandAUTH(AThread: TIdPeerThread;
      const CmdStr: String);
    procedure IdSMTPServer1CommandCheckUser(AThread: TIdPeerThread;
      const Username, Password: String; var Accepted: Boolean);
    procedure IdSMTPServer1CommandQUIT(AThread: TIdPeerThread);
    procedure IdSMTPServer1CommandX(AThread: TIdPeerThread;
      const CmdStr: String);
    procedure IdSMTPServer1CommandMAIL(const ASender: TIdCommand;
      var Accept: Boolean; EMailAddress: String);
    procedure IdSMTPServer1CommandRCPT(const ASender: TIdCommand;
      var Accept, ToForward: Boolean; EMailAddress: String;
      var CustomError: String);
    procedure IdSMTPServer1ReceiveRaw(ASender: TIdCommand;
      var VStream: TStream; RCPT: TIdEMailAddressList;
      var CustomError: String);
    procedure IdSMTPServer1ReceiveMessage(ASender: TIdCommand;
      var AMsg: TIdMessage; RCPT: TIdEMailAddressList;
      var CustomError: String);
    procedure IdSMTPServer1ReceiveMessageParsed(ASender: TIdCommand;
      var AMsg: TIdMessage; RCPT: TIdEMailAddressList;
      var CustomError: String);
    procedure IdSMTPServer1CommandHELP(ASender: TIdCommand);
    procedure IdSMTPServer1CommandSAML(ASender: TIdCommand);
    procedure IdSMTPServer1CommandSEND(ASender: TIdCommand);
    procedure IdSMTPServer1CommandSOML(ASender: TIdCommand);
    procedure IdSMTPServer1CommandTURN(ASender: TIdCommand);
    procedure IdSMTPServer1CommandVRFY(ASender: TIdCommand);
    procedure btnServerOnClick(Sender: TObject);
    procedure btnServerOffClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.IdSMTPServer1CommandAUTH(AThread: TIdPeerThread;
  const CmdStr: String);
begin
 // This is where you would process the AUTH command - for now, we send a error
 AThread.Connection.Writeln(IdSMTPServer1.Messages.ErrorReply);
end;

procedure TForm1.IdSMTPServer1CommandCheckUser(AThread: TIdPeerThread;
  const Username, Password: String; var Accepted: Boolean);
begin
 // This event allows you to 'login' a user - this is used internall in the
 // IdSMTPServer to validate users connecting using the AUTH.
 Accepted := False;
end;

procedure TForm1.IdSMTPServer1CommandQUIT(AThread: TIdPeerThread);
begin
// Process any logoff events here - e.g. clean temp files
end;

procedure TForm1.IdSMTPServer1CommandX(AThread: TIdPeerThread;
  const CmdStr: String);
begin
 // You can use this for debugging :)
 // It should be noted, that no standard clients ever send this command.
end;

procedure TForm1.IdSMTPServer1CommandMAIL(const ASender: TIdCommand;
  var Accept: Boolean; EMailAddress: String);
Var
 IsOK : Boolean;
begin
 // This is required!
 // You check the EMAILADDRESS here to see if it is to be accepted / processed.
 IsOK := False;
 if Pos('@', EMailAddress) > 0 then   // Basic checking for syntax
  IsOK := True;

 // Set Accept := True if its allowed
 if IsOK then
  Accept := True
 Else
  Accept := False;
end;

procedure TForm1.IdSMTPServer1CommandRCPT(const ASender: TIdCommand;
  var Accept, ToForward: Boolean; EMailAddress: String;
  var CustomError: String);
Var
 IsOK : Boolean;
begin
 // This is required!
 // You check the EMAILADDRESS here to see if it is to be accepted / processed.
 // Set Accept := True if its allowed
 // Set ToForward := True if its needing to be forwarded.
 IsOK := False;
 if Pos('@', EMailAddress) > 0 then   // Basic checking for syntax
  IsOK := True
 Else
  CustomError := '500 No at sign'; // If you are going to use the CustomError property, you need to include the error code
                                   // This allows you to use the extended error reporting.

 // Set Accept := True if its allowed
 if IsOK then
  Accept := True
 Else
  Accept := False;
end;

procedure TForm1.IdSMTPServer1ReceiveRaw(ASender: TIdCommand;
  var VStream: TStream; RCPT: TIdEMailAddressList;
  var CustomError: String);
begin
// This is the main event for receiving the message itself if you are using
// the ReceiveRAW method
// The message data will be given to you in VSTREAM
// Capture it using a memorystream, filestream, or whatever type of stream
// is suitable to your storage mechanism.
// The RCPT variable is a list of recipients for the message
end;

procedure TForm1.IdSMTPServer1ReceiveMessage(ASender: TIdCommand;
  var AMsg: TIdMessage; RCPT: TIdEMailAddressList;
  var CustomError: String);
begin
// This is the main event if you have opted to have idSMTPServer present the message packaged as a TidMessage
// The AMessage contains the completed TIdMessage.
// NOTE: Dont forget to add IdMessage to your USES clause!

ToLabel.Caption := AMsg.Recipients.EMailAddresses;
FromLabel.Caption := AMsg.From.Text;
SubjectLabel.Caption := AMsg.Subject;
Memo1.Lines := AMsg.Body;

// Implement your file system here :)
end;

procedure TForm1.IdSMTPServer1ReceiveMessageParsed(ASender: TIdCommand;
  var AMsg: TIdMessage; RCPT: TIdEMailAddressList;
  var CustomError: String);
begin
// This is the main event if you have opted to have the idSMTPServer to do your parsing for you.
// The AMessage contains the completed TIdMessage.
// NOTE: Dont forget to add IdMessage to your USES clause!

ToLabel.Caption := AMsg.Recipients.EMailAddresses;
FromLabel.Caption := AMsg.From.Text;
SubjectLabel.Caption := AMsg.Subject;
Memo1.Lines := AMsg.Body;

// Implement your file system here :)

end;

procedure TForm1.IdSMTPServer1CommandHELP(ASender: TIdCommand);
begin
// here you can send back a lsit of supported server commands
end;

procedure TForm1.IdSMTPServer1CommandSAML(ASender: TIdCommand);
begin
// not really used anymore - see RFC for information
end;

procedure TForm1.IdSMTPServer1CommandSEND(ASender: TIdCommand);
begin
// not really used anymore - see RFC for information
end;

procedure TForm1.IdSMTPServer1CommandSOML(ASender: TIdCommand);
begin
// not really used anymore - see RFC for information
end;

procedure TForm1.IdSMTPServer1CommandTURN(ASender: TIdCommand);
begin
// not really used anymore - see RFC for information
end;

procedure TForm1.IdSMTPServer1CommandVRFY(ASender: TIdCommand);
begin
// not really used anymore - see RFC for information
end;

procedure TForm1.btnServerOnClick(Sender: TObject);
begin
 btnServerOn.Enabled := False;
 btnServerOff.Enabled := True;
 IdSMTPServer1.active := true;
end;

procedure TForm1.btnServerOffClick(Sender: TObject);
begin
 btnServerOn.Enabled := True;
 btnServerOff.Enabled := False;
 IdSMTPServer1.active := false;
end;

end.
