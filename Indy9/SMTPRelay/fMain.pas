{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  23283: fMain.pas 
{
{   Rev 1.1    25/10/2004 22:49:38  ANeillans    Version: 9.0.17
{ Verified
}
{
{   Rev 1.0    12/09/2003 21:50:22  ANeillans
{ Intial Checkin
{ Verified with D7 and Indy 9
{ Added an event log and a few more comments
}
{
  Demo Name:  SMTP Relay
  Created By: Allen O'Neill
          On: 27/10/2002

  Notes:
   Demonstrates sending an email without the use of a local SMTP server
   This works by extracting the domain part form the recipient email address,
   then doing an MX lookup against a DNS server for that domain part,
   and finally connecting directly to the SMTP server that the MX record
   point to, to deliver the message.

  Version History:
    12th Sept 03: Andy Neillans
                  Added an event log and a few more comments
     
  Tested:
   Indy 9:
     D5:     Untested
     D6:     Untested
     D7:     25th Oct 2004 by Andy Neillans
             Tested with Telnet and Outlook Express 6
}

unit fMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP, IdComponent,
  IdUDPBase, IdUDPClient, IdDNSResolver, IdBaseComponent, IdMessage,
  StdCtrls, ExtCtrls, ComCtrls, IdAntiFreezeBase, IdAntiFreeze;

type
  TfrmMain = class(TForm)
    IdMessage: TIdMessage;
    IdDNSResolver: TIdDNSResolver;
    IdSMTP: TIdSMTP;
    Label1: TLabel;
    sbMain: TStatusBar;
    Label2: TLabel;
    edtDNS: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtSender: TEdit;
    Label5: TLabel;
    edtRecipient: TEdit;
    Label6: TLabel;
    edtSubject: TEdit;
    Label7: TLabel;
    mmoMessageText: TMemo;
    btnSendMail: TButton;
    btnExit: TButton;
    IdAntiFreeze: TIdAntiFreeze;
    Label8: TLabel;
    edtTimeOut: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    lbEvents: TListBox;
    procedure btnExitClick(Sender: TObject);
    procedure btnSendMailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  fMailServers : TStringList;
  Function PadZero(s:String):String;
  Function GetMailServers:Boolean;
  Function ValidData : Boolean;
  Procedure SendMail; OverLoad;
  Function SendMail(aHost : String):Boolean; OverLoad;
  Procedure LockControls;
  procedure UnlockControls;
  Procedure Msg(aMessage:String);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}


procedure TfrmMain.btnExitClick(Sender: TObject);
begin
 application.terminate;
end;

procedure TfrmMain.btnSendMailClick(Sender: TObject);
begin
Msg('');
LockControls;
if ValidData then SendMail;
UnlockControls;
Msg('');
end;

function TfrmMain.GetMailServers: Boolean;
var
  i,x : integer;
  LDomainPart : String;
  LMXRecord : TMXRecord;
begin
// This function does the business part of resolving the domain name and fetching
// the mail server list

if not assigned(fmailServers) then fMailServers := TStringList.Create;
fmailServers.clear;

with IdDNSResolver do
  begin
  QueryResult.Clear;
  QueryRecords := [qtMX];
  Msg('Setting up DNS query parameters');
  Host := edtDNS.text;
  ReceiveTimeout := StrToInt(edtTimeOut.text);
  // Extract the domain part from recipient email address
  LDomainPart := copy(edtRecipient.text,pos('@',edtRecipient.text)+1,length(edtRecipient.text)); // the domain name to resolve

  try
  Msg('Resolving DNS for domain: ' + LDomainPart);
  Resolve(LDomainPart);

  if QueryResult.Count > 0 then
    begin
      for i := 0 to QueryResult.Count - 1 do
       begin
        LMXRecord := TMXRecord(QueryResult.Items[i]);
        fMailServers.Append(PadZero(IntToStr(LMXRecord.Preference)) + '=' + LMXRecord.ExchangeServer);
       end;

    // sort in order of priority and then remove extra data
    fMailServers.Sorted := false;
    for i := 0 to fMailServers.count - 1 do
     begin
      x := pos('=',fMailServers.Strings[i]);
      if x > 0 then fMailServers.Strings[i] :=
        copy(fMailServers.Strings[i],x+1,length(fMailServers.Strings[i]));
     end;
    fMailServers.Sorted := true;
    // Ignore duplicate servers
    fMailServers.Duplicates := dupIgnore;
    Result := true;
    end
  else
   begin
    Msg('No response from the DNS server');
    MessageDlg('There is no response from the DNS server !', mtInformation, [mbOK], 0);
    Result := false;
   end;
  except
  on E : Exception do
    begin
    Msg('Error resolving domain ' + LDomainPart);
    MessageDlg('Error resolving domain: ' + e.message, mtInformation, [mbOK], 0);
    Result := false;
    end;
  end;

  end;
end;

// Used in DNS preferance sorting
procedure TfrmMain.LockControls;
begin
edtDNS.enabled := false;
edtSender.enabled := false;
edtRecipient.enabled := false;
edtSubject.enabled := false;
mmoMessageText.enabled := false;
btnExit.enabled := false;
btnSendMail.enabled := false;
end;

procedure TfrmMain.UnlockControls;
begin
edtDNS.enabled := true;
edtSender.enabled := true;
edtRecipient.enabled := true;
edtSubject.enabled := true;
mmoMessageText.enabled := true;
btnExit.enabled := true;
btnSendMail.enabled := true;
end;


function TfrmMain.PadZero(s: String): String;
begin
if length(s) < 2 then
  s := '0' + s;
Result := s;
end;

procedure TfrmMain.SendMail;
var
  i : integer;
begin
if GetMailServers then
  begin
  with IdMessage do
   begin
    Msg('Assigning mail message properties');
    From.Text := edtSender.text;
    Sender.Text := edtSender.text;
    Recipients.EMailAddresses := edtRecipient.text;
    Subject := edtSubject.text;
    Body := mmoMessageText.Lines;
   end;

  for i := 0 to fMailServers.count -1 do
   begin
    Msg('Attempting to send mail');
    if SendMail(fMailServers.Strings[i]) then
     begin
      MessageDlg('Mail successfully sent and available for pickup by recipient !', mtInformation, [mbOK], 0);
      Exit;
     end;
   end;
  // if we are here then something went wrong .. ie there were no available servers to accept our mail!
  MessageDlg('Could not send mail to remote server - please try again later.', mtInformation, [mbOK], 0);
  end;
if assigned(fMailServers) then FreeAndNil(fMailServers);
end;

function TfrmMain.SendMail(aHost: String): Boolean;
begin
with IdSMTP do
  begin
  Caption := 'Trying to sendmail via: ' + aHost;
  Msg('Trying to sendmail via: ' + aHost);
  Host := aHost;
  try
  Msg('Attempting connect');
  Connect;
  Msg('Successful connect ... sending message');
  Send(IdMessage);
  Msg('Attempting disconnect');
  Disconnect;
  msg('Successful disconnect');
  Result := true;
  except on E : Exception do
    begin
    if connected then try disconnect; except end;
    Msg('Error sending message');
    result := false;
    ShowMessage(E.Message);
    end;
  end;
  end;
Caption := '';
end;


function TfrmMain.ValidData: Boolean;
var ErrString:string;
begin
 // Here we do some quick validation of the boxes on the form - just to make sure :)
 
 Result := True;
 ErrString := '';

 if trim(edtDNS.text) = '' then ErrString := ErrString +  #13 + #187 + 'DNS server not filled in';
 if trim(edtSender.text) = '' then ErrString := ErrString + #13 + #187 + 'Sender email not filled in';
 if trim(edtRecipient.text) = '' then ErrString := ErrString +  #13 + #187 + 'Recipient not filled in';

 if ErrString <> '' then
  begin
   lbEvents.Items.Add('Validation Error: ' + ErrString);
   MessageDlg('Cannot proceed due to the following errors:'+#13+#10+ ErrString, mtInformation, [mbOK], 0);
   Result := False;
  end;
end;

procedure TfrmMain.Msg(aMessage: String);
begin
 lbEvents.Items.Add(AMessage);
 sbMain.SimpleText := aMessage;
 application.ProcessMessages;
end;

end.


