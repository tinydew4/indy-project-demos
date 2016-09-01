{
  Demo Name:  SMTP Relay
  Created By: Andy Neillans
          On: 31/12/2004

  Notes:
   Demonstrates sending an email without the use of a local SMTP server

  Version History:
    31st December 2004: Andy Neillans
                        Demo Created.
  Tested:
}

unit fMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdSMTPBase, IdSMTPRelay, IdAntiFreezeBase, IdAntiFreeze,
  IdBaseComponent, IdMessage, StdCtrls, ComCtrls, IdEMailAddress, IdIntercept,
  IdLogBase, IdLogFile;

type
  TfrmMain = class(TForm)
    IdMessage: TIdMessage;
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
    Label9: TLabel;
    Label10: TLabel;
    lbEvents: TListBox;
    IdSMTPRelay1: TIdSMTPRelay;
    cbLogFile: TCheckBox;
    IdLogFile1: TIdLogFile;
    procedure FormCreate(Sender: TObject);
    procedure IdSMTPRelay1DirectSMTPStatus(Sender: TObject;
      AEMailAddress: TIdEMailAddressItem; Action: TIdSMTPRelayStatusAction);
    procedure btnExitClick(Sender: TObject);
    procedure btnSendMailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    fMailServers : TStringList;
    Function ValidData : Boolean;
    Procedure Msg(aMessage:String);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}


procedure TfrmMain.btnExitClick(Sender: TObject);
begin
 close;
end;

procedure TfrmMain.btnSendMailClick(Sender: TObject);
begin
Msg('');
if ValidData then
 Begin
  with IdMessage do
   begin
    Msg('Assigning mail message properties');
    From.Text := edtSender.text;
    Sender.Text := edtSender.text;
    Recipients.EMailAddresses := edtRecipient.text;
    Subject := edtSubject.text;
    Body := mmoMessageText.Lines;
   end;
//  IdSMTPRelay1.
  with IdSMTPRelay1 do
   begin
    DNSServer := edtDNS.Text;
    Caption := 'Trying to sendmail';
    Msg('Trying to sendmail');
    try
     Msg('Attempting connect');
     Connect;
     If cbLogFile.Checked Then
      Begin
       IdLogFile1.Active := True;
       IOHandler.Intercept := IdLogFile1;
      end;
     Msg('Successful connect ... sending message');
     Send(IdMessage);
     Msg('Attempting disconnect');
     Disconnect;
     msg('Successful disconnect');
   except on E : Exception do
    begin
     if connected then
      Begin
       try
        disconnect;
       except
        // Ignore any exceptions
       end;
     Msg('Error sending message');
     ShowMessage(E.Message);
    end;
   end;
  end;
 Caption := '';
 End;
Msg('');
end;
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

procedure TfrmMain.IdSMTPRelay1DirectSMTPStatus(Sender: TObject;
  AEMailAddress: TIdEMailAddressItem; Action: TIdSMTPRelayStatusAction);
begin
 if Action = dmResolveMS Then
  Begin
   Msg('Resolving Mail Servers');
  End;
 If Action = dmSending Then
  Begin
   Msg('Sending Message');
  End;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
 IdLogFile1.Filename := ExtractFilePath(Application.Exename) + 'smtp.log';
end;

end.


