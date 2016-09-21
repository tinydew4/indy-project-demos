unit Unit_FileClient;

{*******************************************************************************
  Stream Exchange Client Demo Indy 10.5.5

  It just shows how to send/receive Record/Buffer.

  No error handling.

  Version November 2011 & February 2012
*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, StdCtrls,
  Vcl.ExtCtrls;

type
  TFileExchangeClientForm = class(TForm)
    CheckBox1: TCheckBox;
    Button_SendStream: TButton;
    IdTCPClient1: TIdTCPClient;
    BuildButton: TButton;
    aOpenDialog: TOpenDialog;
    FileNameEdit: TEdit;
    LoadFileButton: TButton;
    Memo1: TMemo;
    procedure CheckBox1Click(Sender: TObject);
    procedure IdTCPClient1Connected(Sender: TObject);
    procedure IdTCPClient1Disconnected(Sender: TObject);
    procedure Button_SendStreamClick(Sender: TObject);
    procedure BuildButtonClick(Sender: TObject);
    procedure LoadFileButtonClick(Sender: TObject);
  private
    procedure SetClientState(aState: Boolean);

    { Private declarations }
  public
    { Public declarations }

  end;

var
  FileExchangeClientForm: TFileExchangeClientForm;

implementation

uses Unit_Indy_Classes, Unit_Indy_Functions, Unit_DelphiCompilerversionDLG;

{$R *.dfm}

procedure TFileExchangeClientForm.BuildButtonClick(Sender: TObject);
begin
  OKRightDlgDelphi.Show;
end;

procedure TFileExchangeClientForm.Button_SendStreamClick(Sender: TObject);
var
  LSize: LongInt;
begin

  LSize := 0;

  Memo1.Lines.Add('Try send stream to server.....');




  if (ClientSendFile(IdTCPClient1, FileNameEdit.Text) = False) then
  begin
    Memo1.Lines.Add('Cannot send record/buffer to server->' +
       FileNameEdit.Text);
    Exit;
  end
  else
  begin
    Memo1.Lines.Add('send record/buffer to server->' +  FileNameEdit.Text);
  end;

  SetClientState(false);

end;

procedure TFileExchangeClientForm.CheckBox1Click(Sender: TObject);
begin
  if (CheckBox1.Checked = True) then
  begin
    IdTCPClient1.Host := '127.0.0.1';
    IdTCPClient1.Port := 6000;
    IdTCPClient1.Connect;
  end
  else
    IdTCPClient1.Disconnect;

end;

procedure TFileExchangeClientForm.SetClientState(aState : Boolean);
begin
  if (aState = True) then
     begin
     IdTCPClient1.Connect;
     CheckBox1.Checked := true;
     end
     else
     begin
     IdTCPClient1.Disconnect;
     CheckBox1.Checked := false;
     end;


end;

procedure TFileExchangeClientForm.IdTCPClient1Connected(Sender: TObject);
begin
  Memo1.Lines.Add('Client has connected to server');
end;

procedure TFileExchangeClientForm.IdTCPClient1Disconnected(Sender: TObject);
begin
  Memo1.Lines.Add('Client has disconnected from server');
end;

procedure TFileExchangeClientForm.LoadFileButtonClick(Sender: TObject);
begin
  if aOpenDialog.Execute then
  begin
      FileNameEdit.Text := aOpenDialog.FileName;
  end;
end;

end.
