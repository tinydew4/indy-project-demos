unit Unit1;

{ ------------------------------------------------------------------------------

  Record/Buffer Exchange Server Demo Indy 10.5.5


  It just shows how to send/receive Record/Buffer.


  No error handling.


  ****  GENERIC RECORD HANDLING *****

      Instruction : select correct means corresponding recordtype for
         client send = server get and server send = client get


  version march 2012 & April 2012

  ------------------------------------------------------------------------------- }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdContext, StdCtrls, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdTCPServer, IdSync, Unit_Indy_Classes, Unit_Indy_Functions;

type
  TForm1 = class(TForm)
    IdTCPServer1: TIdTCPServer;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ClientConnected;
    procedure ClientDisconnected;
    procedure IdTCPServer1Execute(AContext: TIdContext);
    procedure RecordReceived;
    procedure IdTCPServer1Connect(AContext: TIdContext);
    procedure IdTCPServer1Disconnect(AContext: TIdContext);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

    procedure ShowCannotGetBufferErrorMessage;
    procedure ShowCannotSendBufferErrorMessage;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  MyRecord: TMyThreadSafeRecord;

  MyErrorMessage: string;

implementation

{$R *.dfm}

uses Unit_DelphiCompilerversionDLG;

procedure TForm1.Button1Click(Sender: TObject);
begin
  OKRightDlgDelphi.Show;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  IdTCPServer1.Active := CheckBox1.Checked;
end;

procedure TForm1.ClientConnected;
begin
  Memo1.Lines.Add('A Client connected');
end;

procedure TForm1.ClientDisconnected;
begin
  Memo1.Lines.Add('A Client disconnected');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  IdTCPServer1.Bindings.Add.IP := '127.0.0.1';
  IdTCPServer1.Bindings.Add.Port := 6000;

  MyRecord := TMyThreadSafeRecord.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  IdTCPServer1.Active := False;
  MyRecord.Free;
end;

procedure TForm1.IdTCPServer1Connect(AContext: TIdContext);
begin
  TIdNotify.NotifyMethod(ClientConnected);
end;

procedure TForm1.IdTCPServer1Disconnect(AContext: TIdContext);
begin
  TIdNotify.NotifyMethod(ClientDisconnected);
end;

procedure TForm1.IdTCPServer1Execute(AContext: TIdContext);
var
  LBuffer: TBytes;
  MyLRecord: TMyRecord;
  aINDYCMD: TGenericRecord<TMyRecord>;
  LSize: LongInt;
begin

   Memo1.Lines.Add('svr start execute !');


  aINDYCMD := TGenericRecord<TMyRecord>.Create;

  AContext.Connection.IOHandler.ReadTimeout := 9000;

  if (ReceiveBuffer(AContext, LBuffer) = False) then
  begin
    TIdNotify.NotifyMethod(ShowCannotGetBufferErrorMessage);
    Exit;
  end
  else
  begin

  end;

  aINDYCMD.value := aINDYCMD.ByteArrayToMyRecord(LBuffer);

  // MyRecord.Lock;

  // MyRecord.value := aINDYCMD.value;

  TIdNotify.NotifyMethod(RecordReceived);

  // MyRecord.Unlock;



  MyLRecord.FileName := 'SERVERSIDE-TXT';
  MyLRecord.Details := 'OK';
  MyLRecord.FileSize := random(123);
  MyLRecord.Recordsize := random(10) - 5;
  MyLRecord.FileDate := now;

  aINDYCMD.value := MyLRecord;


  LBuffer := aINDYCMD.MyRecordToByteArray(aINDYCMD.value);

  if (SendBuffer(AContext, LBuffer) = False) then
  begin
    TIdNotify.NotifyMethod(ShowCannotSendBufferErrorMessage);
    Exit;
  end;


    Memo1.Lines.Add('svr end execute !');
end;

procedure TForm1.RecordReceived;
begin
  Memo1.Lines.Add('Details ' + MyRecord.value.Details);
  Memo1.Lines.Add('FileName = ' + MyRecord.value.FileName);
  Memo1.Lines.Add('FileSize = ' + INtToStr(MyRecord.value.FileSize));
  Memo1.Lines.Add('Date = ' + DateToStr(MyRecord.value.FileDate));
  Memo1.Lines.Add('Time = ' + TimeToStr(MyRecord.value.FileDate));
  Memo1.Lines.Add('RecordSize = ' + INtToStr(MyRecord.value.Recordsize));
end;

procedure TForm1.ShowCannotGetBufferErrorMessage;
begin
  Memo1.Lines.Add
    ('Cannot get record/buffer from client, Unknown error occured');
end;

procedure TForm1.ShowCannotSendBufferErrorMessage;
begin
  Memo1.Lines.Add('Cannot send record/buffer to client, Unknown error occured');
end;

end.
