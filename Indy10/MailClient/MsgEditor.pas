{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110652: MsgEditor.pas
{
{   Rev 1.0    25/10/2004 23:18:34  ANeillans    Version: 9.0.17
{ Verified
}
unit MsgEditor;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, ComCtrls, ExtCtrls, Grids, Buttons, Menus, IdBaseComponent,
   IdMessage, IdComponent, IdTCPConnection, IdTCPClient, IdMessageClient,
   IdSMTP, ImgList, IdExplicitTLSClientServerBase, IdSMTPBase, IdAttachmentFile,
   IdText;

type
   TfrmMessageEditor = class(TForm)
      bbtnAdvanced: TBitBtn;
      bbtnCancel: TBitBtn;
      bbtnOk: TBitBtn;
      btnAttachment: TBitBtn;
      btnText: TBitBtn;
      cboPriority: TComboBox;
      chkReturnReciept: TCheckBox;
      Edit1: TEdit;
      edtBCC: TEdit;
      edtCC: TEdit;
      edtSubject: TEdit;
      edtTo: TEdit;
      grpAttachment: TGroupBox;
      IdMsgSend: TIdMessage;
      lblBCC: TLabel;
      lblCC: TLabel;
      lblPriority: TLabel;
      lblSubject: TLabel;
      lblTo: TLabel;
      lvFiles: TListView;
      Memo1: TMemo;
      pnlBottom: TPanel;
      pnlButtons: TPanel;
      pnlMainDetails: TPanel;
      pnlSmallButtons: TPanel;
      pnlTop: TPanel;
      pnlTopLeft: TPanel;
      StatusBar1: TStatusBar;
    SMTP: TIdSMTP;
    OpenDialog1: TOpenDialog;
      procedure bbtnAdvancedClick(Sender: TObject);
      procedure bbtnOkClick(Sender: TObject);
      procedure btnAttachmentClick(Sender: TObject);
      procedure btnTextClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
   private
    { Private declarations }
      procedure ResetAttachmentListView;
   public
    { Public declarations }
   end;

var
   frmMessageEditor: TfrmMessageEditor;

{TODO:  Handle message body which is typed in the RichEdit}

implementation
uses msgEdtAdv, main;

{$R *.DFM}

procedure TfrmMessageEditor.bbtnOkClick(Sender: TObject);
begin
   with IdMsgSend do
      begin
         Body.Assign(Memo1.Lines);
         From.Text := UserEmail;
         ReplyTo.EMailAddresses := UserEmail;
         Recipients.EMailAddresses := edtTo.Text; { To: header }
         Subject := edtSubject.Text; { Subject: header }
         Priority := TIdMessagePriority(cboPriority.ItemIndex); { Message Priority }
         CCList.EMailAddresses := edtCC.Text; {CC}
         BccList.EMailAddresses := edtBCC.Text; {BBC}
         if chkReturnReciept.Checked then
            begin {We set the recipient to the From E-Mail address }
               ReceiptRecipient.Text := From.Text;
            end
         else
            begin {indicate that there is no receipt recipiant}
               ReceiptRecipient.Text := '';
            end;
      end;

  {authentication settings}
   case SmtpAuthType of
      0: SMTP.AuthType := atNone;
      1: SMTP.AuthType := atDefault; {Simple Login}
   end;
   SMTP.Username := SmtpServerUser;
   SMTP.Password := SmtpServerPassword;

   {General setup}
   SMTP.Host := SmtpServerName;
   SMTP.Port := SmtpServerPort;

   {now we send the message}
   SMTP.Connect;
   try
      SMTP.Send(IdMsgSend);
   finally
      SMTP.Disconnect;
   end;
end;

procedure TfrmMessageEditor.bbtnAdvancedClick(Sender: TObject);
begin
   with TfrmAdvancedOptions.Create(Application) do
   try
      edtSender.Text := IdMsgSend.Sender.Text;
      mmoExtraHeaders.Lines := IdMsgSend.ExtraHeaders;
      if ShowModal = mrOk then
         begin
            {Sender header}
            IdMsgSend.Sender.Text := edtSender.Text;
            {Extra header}
            IdMsgSend.ExtraHeaders.Assign(mmoExtraHeaders.Lines);
         end;
   finally
      Free;
   end;
end;

procedure TfrmMessageEditor.FormCreate(Sender: TObject);
begin
   cboPriority.ItemIndex := Ord(IdMsgSend.Priority);
end;

procedure TfrmMessageEditor.btnAttachmentClick(Sender: TObject);
begin
   if OpenDialog1.Execute then
      begin
//         TIdAttachment.Create(IdMsgSend.MessageParts, OpenDialog1.FileName);
//         TIdAttachment should NO LONGER be used. Use IdAttachmentFile or IdAttachmentFile instead.
         TIdAttachmentFile.Create(IdMsgSend.MessageParts, OpenDialog1.FileName);
         ResetAttachmentListView;
      end;
end;

procedure TfrmMessageEditor.ResetAttachmentListView;
var li: TListItem;
   idx: Integer;
begin
   lvFiles.Items.Clear;
   for idx := 0 to Pred(IdMsgSend.MessageParts.Count) do
      begin
         li := lvFiles.Items.Add;
         if IdMsgSend.MessageParts.Items[idx] is TIdAttachmentFile then
            begin
               li.ImageIndex := 0;
               li.Caption := TIdAttachmentFile(IdMsgSend.MessageParts.Items[idx]).Filename;
               li.SubItems.Add(TIdAttachmentFile(IdMsgSend.MessageParts.Items[idx]).ContentType);
            end
         else
            begin
               li.ImageIndex := 1;
               li.Caption := IdMsgSend.MessageParts.Items[idx].ContentType;
            end;
      end;
end;

procedure TfrmMessageEditor.btnTextClick(Sender: TObject);
begin
   if Length(Edit1.Text) = 0 then
      begin
         MessageDlg('Indicate ContentType first', mtError, [mbOk], 0);
      end
   else
      begin
         with TIdText.Create(IdMsgSend.MessageParts, Memo1.Lines) do
            begin
               ContentType := Edit1.Text;
            end;
         Memo1.Clear;
         ResetAttachmentListView;
      end;
end;

end.

