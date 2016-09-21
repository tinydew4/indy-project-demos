unit Unit_StreamServer;

{ ******************************************************************************


  Stream Exchange Server Demo Indy 10.5.5

  It just shows how to send/receive Record/Buffer/STREAMS/FILES.

  No error handling.

  by BdLm

  Version March 2012


  ******************************************************************************* }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdContext, StdCtrls, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdTCPServer, IdSync, Unit_Indy_Classes, Unit_Indy_Functions, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls;

type
  TStreamServerForm = class(TForm)
    IdTCPServer1: TIdTCPServer;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Button1: TButton;
    Image1: TImage;
    Receive_Edit: TEdit;
    Send_Edit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ClientConnected;
    procedure ClientDisconnected;
    procedure IdTCPServer1Execute(AContext: TIdContext);
    procedure IdTCPServer1Connect(AContext: TIdContext);
    procedure IdTCPServer1Disconnect(AContext: TIdContext);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Send_EditExit(Sender: TObject);
    procedure Receive_EditExit(Sender: TObject);
  private

    procedure ShowCannotGetBufferErrorMessage;
    procedure ShowCannotSendBufferErrorMessage;
    procedure StreamReceived;
    { Private declarations }
  public
    { Public declarations }
    aFS_s: TFileStream;
    aFS_r: TFileStream;

    file_send: String;
    file_receive: String;
  end;

var
  StreamServerForm: TStreamServerForm;

  MyErrorMessage: string;

implementation

{$R *.dfm}

uses Unit_DelphiCompilerversionDLG;

procedure TStreamServerForm.Button1Click(Sender: TObject);
begin
  OKRightDlgDelphi.Show;
end;

procedure TStreamServerForm.CheckBox1Click(Sender: TObject);
begin
  try
    IdTCPServer1.Active := CheckBox1.Checked;
  finally

  end;
end;

procedure TStreamServerForm.ClientConnected;
begin
  Memo1.Lines.Add('A Client connected');
end;

procedure TStreamServerForm.ClientDisconnected;
begin
  Memo1.Lines.Add('A Client disconnected');
end;

procedure TStreamServerForm.FormCreate(Sender: TObject);
begin
  IdTCPServer1.Bindings.Add.IP := '127.0.0.1';

  IdTCPServer1.Bindings.Add.Port := 6000;

  Receive_EditExit(Sender);

  Send_EditExit(Sender);

end;

procedure TStreamServerForm.FormDestroy(Sender: TObject);
begin
  IdTCPServer1.Active := False;

end;

procedure TStreamServerForm.IdTCPServer1Connect(AContext: TIdContext);
begin
  TIdNotify.NotifyMethod(ClientConnected);
end;

procedure TStreamServerForm.IdTCPServer1Disconnect(AContext: TIdContext);
begin
  TIdNotify.NotifyMethod(ClientDisconnected);
end;

procedure TStreamServerForm.IdTCPServer1Execute(AContext: TIdContext);
begin

  ///
  aFS_s := TFileStream.Create(file_send, fmopenread);

  aFS_r := TFileStream.Create(file_receive, fmCreate);

  Memo1.Lines.Add('Server  starting  .... ');

  AContext.Connection.IOHandler.ReadTimeout := 9000;

  if (ReceiveStream(AContext, TStream(aFS_r)) = False) then
  begin
    TIdNotify.NotifyMethod(ShowCannotGetBufferErrorMessage);
    Exit;
  end;

  Memo1.Lines.Add(IntToStr(aFS_r.Size));

  aFS_r.Position := 0;

  Image1.Picture.Bitmap.LoadFromStream(aFS_r);

  TIdNotify.NotifyMethod(StreamReceived);

  if (SendStream(AContext, TStream(aFS_s)) = False) then
  begin
    TIdNotify.NotifyMethod(ShowCannotSendBufferErrorMessage);
    Exit;
  end;

  Memo1.Lines.Add('Stream sent');

  Memo1.Lines.Add('Server  done .... ');

  ///
  ///
  ///
  aFS_s.Free;

  aFS_r.Free;

end;

procedure TStreamServerForm.Receive_EditExit(Sender: TObject);
begin
  file_receive := Receive_Edit.Text;
end;

procedure TStreamServerForm.StreamReceived;
begin
  Memo1.Lines.Add('Stream received');
end;

procedure TStreamServerForm.Send_EditExit(Sender: TObject);
begin
  file_send := Send_Edit.Text;

  if fileexists(file_send) then
  begin
    Image1.Picture.LoadFromFile(file_send);

  end;

end;

procedure TStreamServerForm.ShowCannotGetBufferErrorMessage;
begin
  Memo1.Lines.Add('Cannot get stream/file from client, Unknown error occured');
end;

procedure TStreamServerForm.ShowCannotSendBufferErrorMessage;
begin
  Memo1.Lines.Add('Cannot send stream/file to client, Unknown error occured');
end;

end.
