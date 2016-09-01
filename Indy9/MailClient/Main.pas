{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110660: Main.pas 
{
{   Rev 1.0    25/10/2004 23:18:36  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: Main
 Author:    Hadi Hariri <hadi@hadihariri.com>
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------
 Notes:

 Demonstrates basic email component usage

Verified:
  Indy 9:
    D7: 25th Oct 2004 by Andy Neillans
}


unit Main;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Grids, Menus, ComCtrls, IdSMTP, IdComponent, IdTCPConnection,
   IdTCPClient, IdMessageClient, IdPOP3, IdBaseComponent, IdMessage,
   StdCtrls, ExtCtrls, ToolWin, ActnList, ImgList, Buttons,
   IdAntiFreezeBase, IdAntiFreeze;

type
   TfrmMain = class(TForm)
      ActionList1: TActionList;
      Actions1: TMenuItem;
      Button1: TBitBtn;
      Cc: TLabel;
      CheckMail: TAction;
      Checkmail1: TMenuItem;
      Date: TLabel;
      Delete: TAction;
      Deletecurrentmessage1: TMenuItem;
      Disconnect: TAction;
      Disconnect1: TMenuItem;
      Exit1: TMenuItem;
      From: TLabel;
      IdAntiFreeze1: TIdAntiFreeze;
      ImageList1: TImageList;
      Label1: TLabel;
      Label10: TLabel;
      Label11: TLabel;
      Label4: TLabel;
      Label5: TLabel;
      Label6: TLabel;
      Label7: TLabel;
      Label8: TLabel;
      Label9: TLabel;
      lvHeaders: TListView;
      lvMessageParts: TListView;
      MainMenu1: TMainMenu;
      Memo1: TMemo;
      Msg: TIdMessage;
      N2: TMenuItem;
      N3: TMenuItem;
      Organization: TLabel;
      Panel1: TPanel;
      pnlBottom: TPanel;
      pnlBottomBottom: TPanel;
      pnlMain: TPanel;
      pnlAttachments: TPanel;
      pnlServerName: TPanel;
      pnlTop: TPanel;
      POP: TIdPOP3;
      Priority: TLabel;
      Purge: TAction;
      Purgemarkedmessages1: TMenuItem;
      Receipt: TLabel;
      Recipients: TLabel;
      Retrieve: TAction;
      Retrievecurrentmessage1: TMenuItem;
      SaveDialog1: TSaveDialog;
      Send: TAction;
      Send1: TMenuItem;
      Setup: TAction;
      Setup1: TMenuItem;
      Splitter1: TSplitter;
      StatusBar1: TStatusBar;
      StatusBar2: TStatusBar;
      Subject: TLabel;
      ToolBar1: TToolBar;
      ToolButton1: TToolButton;
      ToolButton10: TToolButton;
      ToolButton11: TToolButton;
      ToolButton12: TToolButton;
      ToolButton2: TToolButton;
      ToolButton3: TToolButton;
      ToolButton4: TToolButton;
      ToolButton5: TToolButton;
      ToolButton6: TToolButton;
      ToolButton7: TToolButton;
      ToolButton8: TToolButton;
      ToolButton9: TToolButton;
    Selectfromdeletion1: TMenuItem;
      function FindAttachment(stFilename: string): integer;
      procedure Button1Click(Sender: TObject);
      procedure CheckMailExecute(Sender: TObject);
      procedure DeleteExecute(Sender: TObject);
      procedure DisconnectExecute(Sender: TObject);
      procedure Exit1Click(Sender: TObject);
      procedure FormActivate(Sender: TObject);
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      procedure FormCreate(Sender: TObject);
      procedure lvMessagePartsClick(Sender: TObject);
      procedure pnlServerNameClick(Sender: TObject);
      procedure PurgeExecute(Sender: TObject);
      procedure RetrieveExecute(Sender: TObject);
      procedure SendExecute(Sender: TObject);
      procedure SetupExecute(Sender: TObject);
      procedure ShowBusy(blBusy: boolean);
      procedure ShowFileStatus;
      procedure ShowStatus(stStatus: string);
    procedure lvHeadersDblClick(Sender: TObject);
    procedure Selectfromdeletion1Click(Sender: TObject);
   private
    { Private declarations }
      procedure RetrievePOPHeaders(inMsgCount: Integer);
      procedure ResetHeadersGrid;
      procedure ToggleStatus(const Status: Boolean);
      procedure ReadConfiguration;
   public
    { Public declarations }
    FAttachPath: string;
    FMsgCount, FMailBoxSize: integer;
   end;

var
   frmMain: TfrmMain;
   Pop3ServerName: String;
   Pop3ServerPort: Integer;
   Pop3ServerUser: String;
   Pop3ServerPassword: String;
   SmtpServerName: String;
   SmtpServerPort: Integer;
   SmtpServerUser: String;
   SmtpServerPassword: String;
   SmtpAuthType: Integer;
   UserEmail: String;

implementation

uses Setup, MsgEditor, inifiles; //, smtpauth;

{$R *.DFM}

procedure TfrmMain.ShowBusy(blBusy: boolean);
begin
   if blBusy then
      screen.cursor := crHourglass
   else
      screen.cursor := crDefault;
end; (*  *)

procedure TfrmMain.ShowStatus(stStatus: string);
begin
   Statusbar1.Panels[1].text := stStatus;
   StatusBar1.Refresh;
end; (*  *)

procedure TfrmMain.ShowFileStatus;
begin
   Statusbar2.Panels[0].text := IntToStr(FMsgCount);
   Statusbar2.Panels[1].text := format('Mail takes up %dK on the server', [FMailBoxSize]);
   StatusBar1.Refresh;
end; (*  *)

function TfrmMain.FindAttachment(stFilename: string): integer;
var
   intIndex: Integer;
   found: boolean;
begin
   intIndex := -1;
   result := -1;
   if (Msg.MessageParts.Count < 1) then exit; //no attachments (or anything else)
   found := false;
   stFilename := uppercase(stFilename);
   repeat
      inc(intIndex);
      if (Msg.MessageParts.Items[intIndex] is TIdAttachment) then
         begin //general attachment
            if stFilename = uppercase(TIdAttachment(Msg.MessageParts.Items[intIndex]).Filename) then
               found := true;
         end;
   until found or (intIndex > Pred(Msg.MessageParts.Count));
   if found then
      result := intIndex
   else
      result := -1;
end; (*  *)

procedure TfrmMain.Button1Click(Sender: TObject);
var
   intIndex: integer;
   fname: string;
   intMSGIndex: integer;
begin
  // Find selected
   for intIndex := 0 to lvMessageParts.Items.Count - 1 do
      if lvMessageParts.Items[intIndex].Selected then
         begin
            //now find which TIdAttachment it is in MSG
            intMSGIndex := FindAttachment(lvMessageParts.Items[intIndex].caption);
            if intMSGIndex > 0 then
               begin
                  fname := FAttachPath + TIdAttachment(Msg.MessageParts.Items[intMSGIndex]).filename;
                  SaveDialog1.FileName := fname;
                  if SaveDialog1.Execute then
                     begin
                        Showbusy(true);
                        TIdAttachment(Msg.MessageParts.Items[intMSGIndex]).SaveToFile(SaveDialog1.FileName);
                        Showbusy(false);
                     end;
               end;
         end;
end;

procedure TfrmMain.RetrievePOPHeaders(inMsgCount: Integer);
var
   stTemp: string;
   intIndex: integer;
   itm: TListItem;
begin
   stTemp := Statusbar1.Panels[1].text;
   lvHeaders.Items.Clear;
   for intIndex := 1 to inMsgCount do
      begin
         // Clear the message properties
         ShowStatus(format('Messsage %d of %d', [intIndex, inMsgCount]));
         Application.ProcessMessages;
         Msg.Clear;
         POP.RetrieveHeader(intIndex, Msg);
         // Add info to ListView
         itm := lvHeaders.Items.Add;
         itm.ImageIndex := 5;
         itm.Caption := Msg.Subject;
         itm.SubItems.Add(Msg.From.Text);
         itm.SubItems.Add(DateToStr(Msg.Date));
         itm.SubItems.Add(IntToStr(POP.RetrieveMsgSize(intIndex)));
         itm.SubItems.Add('n/a');
//         itm.SubItems.Add(POP.RetrieveUIDL(intIndex));
      end;
   ShowStatus(stTemp);
end;

procedure TfrmMain.ResetHeadersGrid;
begin
   lvHeaders.Items.Clear;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  {Set up authentication dialog-box}
//  frmSMTPAuthentication.cboAuthType.ItemIndex := Ord( frmMessageEditor.SMTP.AuthenticationType );
//  frmSMTPAuthentication.edtAccount.Text := fmSetup.Account.Text;
//  frmSMTPAuthentication.edtPassword.Text := fmSetup.Password.Text;
//  frmSMTPAuthentication.EnableControls;

   ResetHeadersGrid;
   ToggleStatus(False);
end;

procedure TfrmMain.ToggleStatus(const Status: Boolean);
begin
   CheckMail.Enabled := not Status;
   Retrieve.Enabled := Status;
   Delete.Enabled := Status;
   Purge.Enabled := Status;
   Disconnect.Enabled := Status;
   if Status then
      ShowStatus('Connected')
   else
      ShowStatus('Not connected');
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Disconnect.Execute;
end;

procedure TfrmMain.CheckMailExecute(Sender: TObject);
begin
   Showbusy(true);
   ShowStatus('Connecting....');
   if POP.Connected then
      begin
         POP.Disconnect;
      end;
   POP.Host := Pop3ServerName;
   POP.Port := Pop3ServerPort;
   POP.Username := Pop3ServerUser;
   POP.Password := Pop3ServerPassword;
   POP.Connect;
   ToggleStatus(True);
   FMsgCount := POP.CheckMessages;
   FMailBoxSize := POP.RetrieveMailBoxSize div 1024;
   ShowFileStatus;
   if FMsgCount > 0 then
      begin
         ShowFileStatus;
         RetrievePOPHeaders(FMsgCount);
      end
   else
      begin
         ShowStatus('No messages on server');
      end;
   Showbusy(false);
end;

procedure TfrmMain.RetrieveExecute(Sender: TObject);
var
   stTemp: string;
   intIndex: Integer;
   li: TListItem;
begin
   stTemp := Statusbar1.Panels[1].text;
   if lvHeaders.Selected = nil then
      begin
         Exit;
      end;
   //initialise
   Showbusy(true);
   Msg.Clear;
   Memo1.Clear;
   lvMessageParts.Items.Clear;
   From.Caption := '';
   Cc.Caption := '';
   Subject.Caption := '';
   Date.Caption := '';
   Receipt.Caption := '';
   Organization.Caption := '';
   Priority.Caption := '';
   pnlAttachments.visible := false;

   //get message and put into MSG
   ShowStatus('Retrieving message "' + lvHeaders.Selected.SubItems.Strings[3] + '"');
   POP.Retrieve(lvHeaders.Selected.Index + 1, Msg);
   statusbar1.Panels[0].text := lvHeaders.Selected.SubItems.Strings[3];

   //Setup fields on screen from MSG
   From.Caption := Msg.From.Text;
   Recipients.Caption := Msg.Recipients.EmailAddresses;
   Cc.Caption := Msg.CCList.EMailAddresses;
   Subject.Caption := Msg.Subject;
   Date.Caption := FormatDateTime('dd mmm yyyy hh:mm:ss', Msg.Date);
   Receipt.Caption := Msg.ReceiptRecipient.Text;
   Organization.Caption := Msg.Organization;
   Priority.Caption := IntToStr(Ord(Msg.Priority) + 1);

   //Setup attachments list
   ShowStatus('Decoding attachments (' + IntToStr(Msg.MessageParts.Count) + ')');
   for intIndex := 0 to Pred(Msg.MessageParts.Count) do
      begin
         if (Msg.MessageParts.Items[intIndex] is TIdAttachment) then
            begin //general attachment
               pnlAttachments.visible := true;
               li := lvMessageParts.Items.Add;
               li.ImageIndex := 8;
               li.Caption := TIdAttachment(Msg.MessageParts.Items[intIndex]).Filename;
               li.SubItems.Add(TIdAttachment(Msg.MessageParts.Items[intIndex]).ContentType);
            end
         else
            begin //body text
               if Msg.MessageParts.Items[intIndex] is TIdText then
                  begin
                     Memo1.Lines.Clear;
                     Memo1.Lines.AddStrings(TIdText(Msg.MessageParts.Items[intIndex]).Body);
                  end
            end;
      end;
   ShowStatus(stTemp);
   Showbusy(false);
end;

procedure TfrmMain.DeleteExecute(Sender: TObject);
begin
   if lvHeaders.Selected <> nil then
      begin
         Showbusy(true);
         POP.Delete(lvHeaders.Selected.Index + 1);
         lvHeaders.Selected.ImageIndex := 3;
         Showbusy(false);
      end;
end;

procedure TfrmMain.PurgeExecute(Sender: TObject);
begin
   POP.Disconnect;
   ToggleStatus(False);
   CheckMailExecute(Sender);
end;

procedure TfrmMain.DisconnectExecute(Sender: TObject);
begin
   if POP.Connected then
      begin
         try
            POP.Reset;
         except
            ShowStatus('Your POP server doesn''t have Reset feature');
         end;
         POP.Disconnect;
         ToggleStatus(False);
      end;
end;

procedure TfrmMain.SetupExecute(Sender: TObject);
begin
  Application.CreateForm(TfmSetup, fmSetup);
  fmSetup.ShowModal;
end;

procedure TfrmMain.SendExecute(Sender: TObject);
begin
   frmMessageEditor.ShowModal;
end;

procedure TfrmMain.lvMessagePartsClick(Sender: TObject);
begin
  {display message parts we selected}
   if lvMessageParts.Selected <> nil then
      begin
         if lvMessageParts.Selected.Index > Msg.MessageParts.Count then
            begin
               MessageDlg('Unknown index', mtInformation, [mbOK], 0);
            end
         else
            begin
            showmessage(TIdAttachment(Msg.MessageParts.Items[lvMessageParts.Selected.Index]).Filename);
            end;
      end;
end;
//      Memo1.Lines.AddStrings(TIdText(Msg.MessageParts.Items[lvMessageParts.Selected.Index]).Body);

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
   close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // read the configuration from ini file
  ReadConfiguration;

   name := 'frmMain';

   //setup path to put attachments into
   FAttachPath := IncludeTrailingPathDelimiter(ExtractFileDir(Application.exename)); //starting directory
   FAttachPath := FAttachPath + 'Attach\';
   if not DirectoryExists(FAttachPath) then ForceDirectories(FAttachPath);

   FMsgCount := 0; FMailBoxSize := 0;
   Showbusy(false);
end;

procedure TfrmMain.pnlServerNameClick(Sender: TObject);
begin
   SetupExecute(Sender); //show setup screen
end;

procedure TfrmMain.ReadConfiguration;
var
  MailIni: TIniFile;
begin
  MailIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Mail.ini');
  with MailIni do begin
    Pop3ServerName := ReadString('Pop3', 'ServerName', 'pop3.server.com');
    Pop3ServerPort := StrToInt(ReadString('Pop3', 'ServerPort', '110'));
    Pop3ServerUser := ReadString('Pop3', 'ServerUser', 'your_login');
    Pop3ServerPassword := ReadString('Pop3', 'ServerPassword', 'your_password');

    SmtpServerName := ReadString('Smtp', 'ServerName', 'smtp.server.com');
    SmtpServerPort := StrToInt(ReadString('Smtp', 'ServerPort', '25'));
    SmtpServerUser := ReadString('Smtp', 'ServerUser', 'your_login');
    SmtpServerPassword := ReadString('Smtp', 'ServerPassword', 'your_password');
    SmtpAuthType := ReadInteger('Smtp', 'SMTPAuthenticationType', 0);

    UserEmail := ReadString('Email', 'PersonalEmail', 'someaddress@somewhere.com');
  end;
  MailIni.Free;
end;

procedure TfrmMain.lvHeadersDblClick(Sender: TObject);
begin
  RetrieveExecute(Sender);
end;

procedure TfrmMain.Selectfromdeletion1Click(Sender: TObject);
var i : integer;
begin
for i := 0 to lvHeaders.Items.Count - 1 do
  begin
  Showbusy(true);
  POP.Delete(i+1);
  lvHeaders.Items[i].ImageIndex := 3;
  Showbusy(false);
  end;
end;

end.

