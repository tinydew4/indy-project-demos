unit Unit_StreamClient;

{ ------------------------------------------------------------------------------

  Stream Exchange Client Demo Indy 10.5.5

  It just shows how to send/receive Record/Buffer/STREAMS/FILES.

  No error handling.

  version march 2012

  by BDLM

  ------------------------------------------------------------------------------- }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, StdCtrls,
  Vcl.ExtCtrls;

type
  TStreamExchangeClientForm = class(TForm)
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Button_SendStream: TButton;
    IdTCPClient1: TIdTCPClient;
    BuildButton: TButton;
    Image1: TImage;
    ClientSendFileEdit: TEdit;
    ClientReceiveFileEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure CheckBox1Click(Sender: TObject);
    procedure IdTCPClient1Connected(Sender: TObject);
    procedure IdTCPClient1Disconnected(Sender: TObject);
    procedure Button_SendStreamClick(Sender: TObject);
    procedure BuildButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClientSendFileEditExit(Sender: TObject);
    procedure ClientReceiveFileEditExit(Sender: TObject);
  private
    procedure SetClientState(aState: Boolean);

    { Private declarations }
  public
    { Public declarations }
    aFs_s: TFileStream;
    aFs_r: TFileStream;

    file_send: String;
    file_receive: String;
  end;

var
  StreamExchangeClientForm: TStreamExchangeClientForm;

implementation

uses Unit_Indy_Classes, Unit_Indy_Functions, Unit_DelphiCompilerversionDLG;

{$R *.dfm}

procedure TStreamExchangeClientForm.BuildButtonClick(Sender: TObject);
begin
  OKRightDlgDelphi.Show;
end;

procedure TStreamExchangeClientForm.Button_SendStreamClick(Sender: TObject);
begin

  Memo1.Lines.Add('Try send stream to server.....');

  if (SendStream(IdTCPClient1, TStream(aFs_s)) = False) then
  begin
    Memo1.Lines.Add('Cannot send STREAM to server, Unknown error occured');
    Exit;
  end;

  Memo1.Lines.Add('Stream successfully sent');

  if (ReceiveStream(IdTCPClient1, TStream(aFs_r)) = False) then
  begin
    Memo1.Lines.Add('Cannot get STREAM from server, Unknown error occured');
    Exit;
  end;

  Memo1.Lines.Add('Stream received: ' + IntToStr(aFs_r.Size));

  SetClientState(False);

  aFs_r.Position := 0;
  Image1.Picture.Bitmap.LoadFromStream(aFs_r);

end;

procedure TStreamExchangeClientForm.CheckBox1Click(Sender: TObject);
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

procedure TStreamExchangeClientForm.ClientReceiveFileEditExit(Sender: TObject);
begin
  file_receive := ClientReceiveFileEdit.text;
end;

procedure TStreamExchangeClientForm.ClientSendFileEditExit(Sender: TObject);
begin
  ///
  file_send := ClientSendFileEdit.text;

  if fileexists(file_send) then
  begin

    Image1.Picture.LoadFromFile(file_send);
  end
  else
  begin
    Memo1.Lines.Add('uups the file for sending does not exist... ')
  end;
end;

procedure TStreamExchangeClientForm.SetClientState(aState: Boolean);
begin
  if (aState = True) then
  begin
    IdTCPClient1.Connect;
    CheckBox1.Checked := True;
  end
  else
  begin
    IdTCPClient1.Disconnect;
    CheckBox1.Checked := False;
  end;
end;

procedure TStreamExchangeClientForm.FormCreate(Sender: TObject);
begin

  ClientReceiveFileEdit.text := 'C:\temp\test_c_r.bmp';

  ClientSendFileEdit.text := 'C:\temp\test_c_s.bmp';

  ClientReceiveFileEditExit(Sender);

  ClientSendFileEditExit(Sender);

  aFs_s := TFileStream.Create(file_send, fmOpenReadWrite);

  aFs_r := TFileStream.Create(file_receive, fmCreate);

end;

procedure TStreamExchangeClientForm.IdTCPClient1Connected(Sender: TObject);
begin
  Memo1.Lines.Add('Client has connected to server');
end;

procedure TStreamExchangeClientForm.IdTCPClient1Disconnected(Sender: TObject);
begin
  Memo1.Lines.Add('Client has disconnected from server');
end;

end.
