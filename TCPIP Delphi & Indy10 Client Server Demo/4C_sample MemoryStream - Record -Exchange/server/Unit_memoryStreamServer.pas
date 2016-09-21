unit Unit_memoryStreamServer;

{ ******************************************************************************


  Stream Exchange Server Demo Indy 10.5.5

  It just shows how to send/receive Record/Buffer.

  No error handling.

  by BdLm

  Version March 2012


  remark : load *.bmp to TImage, other file formats need more code at TImage !!!

      --------  BADMINTON PLAY IT VIA TCP  -------

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
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ClientConnected;
    procedure ClientDisconnected;
    procedure IdTCPServer1Execute(AContext: TIdContext);
    procedure IdTCPServer1Connect(AContext: TIdContext);
    procedure IdTCPServer1Disconnect(AContext: TIdContext);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

    procedure ShowCannotGetBufferErrorMessage;
    procedure ShowCannotSendBufferErrorMessage;
    procedure StreamReceived;
    { Private declarations }
  public
    { Public declarations }
    aFS_s: TmemoryStream;
    aFS_r: TmemoryStream;

    file_send     :  String;
    file_receive  : String;
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
var
       LBuffer  : TBytes;
       MyLIndy  : TINDYCMD;
       aINDYCMD : TGenericRecord<TINDYCMD>;

begin

  ///
  afS_s:= TmemoryStream.Create;
  aINDYCMD := TGenericRecord<TINDYCMD>.Create;


  Memo1.Lines.Add('Server  starting  .... ');

  AContext.Connection.IOHandler.ReadTimeout := 9000;

  if (ReceiveBuffer(AContext, LBuffer) = False) then
  begin
    TIdNotify.NotifyMethod(ShowCannotGetBufferErrorMessage);
    Exit;
  end
  else
  begin
    aINDYCMD.Value := aINDYCMD.ByteArrayToMyRecord(LBuffer);
    // ShowTINDYCMD(aINDYCMD.Value);
    MyLIndy :=  aINDYCMD.Value;
  end ;
  case MyLIndy.CMD_CLASS of
  1: Image1.Picture.Bitmap.SaveToStream(aFS_s);
  2: Image2.Picture.Bitmap.SaveToStream(aFS_s);
  3: Image3.Picture.Bitmap.SaveToStream(aFS_s);
  4: Image4.Picture.Bitmap.SaveToStream(aFS_s);
  else
  Image1.Picture.Bitmap.SaveToStream(aFS_s);
  end;


  aFS_s.Seek(0,soFromBeginning);

  if (SendStream(AContext, TStream(aFS_s)) = False) then
  begin
    TIdNotify.NotifyMethod(ShowCannotSendBufferErrorMessage);
    Exit;
  end;

  Memo1.Lines.Add('sent badminton shuttle ' + IntToStr(MyLIndy.CMD_CLASS));

  Memo1.Lines.Add('Server  done .... ');


  ///
  ///
  ///
  aFS_s.Free;

  aFS_r.Free;

end;

procedure TStreamServerForm.StreamReceived;
begin
  Memo1.Lines.Add('Stream received');
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
