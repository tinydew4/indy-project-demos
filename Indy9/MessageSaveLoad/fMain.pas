{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110665: fMain.pas 
{
{   Rev 1.0    25/10/2004 23:20:18  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: fMain
 Author:    Allen O'Neill
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------
 Notes:

 Simple demo of loading / saving an RFC message.
 IMPORTANT - there MUST be a CRLF + period + CRLF at
        the end of the file for it to load correctly.
        This is according to RFC standards.

Verified:
  Indy 9:
    D7: 25th Oct 2004 by Andy Neillans
}

unit fMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, IdBaseComponent, IdMessage, IdEmailAddress, IdException;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    edtSender: TEdit;
    Label2: TLabel;
    edtSubject: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    lbHeaders: TListBox;
    lbTo: TListBox;
    edtToAddress: TEdit;
    btnAddTo: TButton;
    edtCCAddress: TEdit;
    btnAddCC: TButton;
    lbCC: TListBox;
    edtBCCAddress: TEdit;
    btnAddBCC: TButton;
    lbBCC: TListBox;
    mmoBody: TMemo;
    btnAddFile: TButton;
    lbAttach: TListBox;
    btnSaveToFile: TButton;
    btnLoadFromFile: TButton;
    IdMessage: TIdMessage;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    edtAddHeader: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure btnLoadFromFileClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnAddToClick(Sender: TObject);
    procedure btnAddCCClick(Sender: TObject);
    procedure btnAddBCCClick(Sender: TObject);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure edtSenderChange(Sender: TObject);
    procedure edtSubjectChange(Sender: TObject);
    procedure mmoBodyChange(Sender: TObject);
    procedure btnAddFileClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  Procedure ClearControls;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnLoadFromFileClick(Sender: TObject);
var
  i : integer;
begin
ClearControls;
if OpenDialog.execute then
  begin
  try
  IdMessage.Clear;
  IdMessage.LoadFromFile(OpenDialog.FileName);
  edtSender.text := IdMessage.From.Text;
  edtSubject.text := IdMessage.Subject;
  lbHeaders.Items.AddStrings(IdMessage.Headers);
  // To
  for i := 0 to IdMessage.Recipients.Count - 1 do
    lbTo.items.Append(IdMessage.Recipients.Items[i].Text);
  if IdMessage.Recipients.Count > 0 then
    edtToAddress.text := IdMessage.Recipients.Items[0].Text;
  // CC
  for i := 0 to IdMessage.CCList.Count - 1 do
    lbCC.items.Append(IdMessage.CCList.Items[i].Text);
  if IdMessage.CCList.Count > 0 then
    edtCCAddress.text := IdMessage.CCList.Items[0].Text;
  // BCC
  for i := 0 to IdMessage.BCCList.Count - 1 do
    lbBCC.items.Append(IdMessage.BCCList.Items[i].Text);
  if IdMessage.BCCList.Count > 0 then
    edtBCCAddress.text := IdMessage.BCCList.Items[0].Text;
  for i := 0 to IdMessage.MessageParts.Count - 1 do
    if IdMessage.MessageParts.Items[i] is TidText then
      mmoBody.Lines.AddStrings(TidText(IdMessage.MessageParts.Items[i]).Body)
  else if IdMessage.MessageParts.Items[i] is TidAttachment then
      lbAttach.items.Append(TidAttachment(IdMessage.MessageParts.Items[i]).FileName);
  except
  on E : EIdReadTimeout do
  MessageDlg('Message does not conform to RFC standards.'+#13+#10+'Must have " . " terminator to signify end of message.', mtError, [mbOK], 0);
  end;
  end;
end;

procedure TForm1.ClearControls;
begin
edtAddHeader.text := '';
edtSender.text := '';
edtSubject.text := '';
edtToAddress.text := '';
edtCCAddress.text := '';
edtBCCAddress.text := '';
lbHeaders.Clear;
lbTo.Clear;
lbCC.Clear;
lbBCC.Clear;
mmoBody.Clear;
lbAttach.Clear;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if trim(edtAddHeader.text) <> '' then
  lbHeaders.items.Append(edtAddHeader.text);
IdMessage.Headers.Add(edtAddHeader.text);
end;

procedure TForm1.btnAddToClick(Sender: TObject);
var
  AnItem : TidEmailAddressItem;
begin
if trim(edtToAddress.text) <> '' then
  lbTo.items.Append(edtToAddress.text);
AnItem := IdMessage.Recipients.Add;
AnItem.Text := edtToAddress.text;
end;

procedure TForm1.btnAddCCClick(Sender: TObject);
var
  AnItem : TidEmailAddressItem;
begin
if trim(edtCCAddress.text) <> '' then
  lbCC.items.Append(edtCCAddress.text);
AnItem := IdMessage.CCList.Add;
AnItem.Text := edtCCAddress.text;
end;

procedure TForm1.btnAddBCCClick(Sender: TObject);
var
  AnItem : TidEmailAddressItem;
begin
if trim(edtBCCAddress.text) <> '' then
  lbBCC.items.Append(edtBCCAddress.text);
AnItem := IdMessage.BCCList.Add;
AnItem.Text := edtBCCAddress.text;
end;

procedure TForm1.btnSaveToFileClick(Sender: TObject);
begin
if SaveDialog.execute then
  IdMessage.SaveToFile(SaveDialog.FileName);
end;

procedure TForm1.edtSenderChange(Sender: TObject);
begin
IdMessage.From.Address := edtSender.text;
end;

procedure TForm1.edtSubjectChange(Sender: TObject);
begin
IdMessage.Subject := edtSubject.text;
end;

procedure TForm1.mmoBodyChange(Sender: TObject);
begin
IdMessage.Body.Text := mmoBody.Text;
end;

procedure TForm1.btnAddFileClick(Sender: TObject);
begin
if OpenDialog.Execute then
  begin
  lbAttach.Items.Append(OpenDialog.FileName);
  TIdAttachment.Create(IdMessage.MessageParts,OpenDialog.FileName);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
ClearControls;
IdMessage.Clear;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
application.terminate;
end;

end.
