unit Unit1;

{ ------------------------------------------------------------------------------

  Record/Buffer Exchange Server Demo Indy 10.5.5


  It just shows how to send/receive Record/Buffer using a generic record definition.


  No error handling.

  ****  GENERIC RECORD HANDLING *****

      Instruction : select correct means corresponding recordtype for
         client send = server get and server send = client get

  version march 2012
  ------------------------------------------------------------------------------- }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdContext, StdCtrls, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdTCPServer, IdSync, Unit_Indy_Classes, Unit_Indy_Functions, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    IdTCPServer1: TIdTCPServer;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Button1: TButton;
    RecordTypeRadioGroup: TRadioGroup;
    RadioGroup1: TRadioGroup;
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
    procedure RecordTypeRadioGroupClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private

    procedure ShowCannotGetBufferErrorMessage;
    procedure ShowCannotSendBufferErrorMessage;
    procedure ShowTINDYCMD(aINDYCMD: TINDYCMD);
    procedure ShowTMyRecord(aRecord: TMyrecord);
    { Private declarations }
  public
    { Public declarations }
    RecordTypeIndex : Integer;
    RecordTypeIndex2 : Integer;
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
  IdTCPServer1.Bindings.Add.Port := 5000;

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
  MyLIndy   : TINDYCMD;
  aINDYCMD : TGenericRecord<TINDYCMD>;
  aMyRecord :TGenericRecord<TMyRecord>;


  LSize: LongInt;
begin

   Memo1.Lines.Add('svr start execute !');


  aINDYCMD := TGenericRecord<TINDYCMD>.Create;
  aMyRecord :=TGenericRecord<TMyRecord>.Create;

  AContext.Connection.IOHandler.ReadTimeout := 9000;

  if (ReceiveBuffer(AContext, LBuffer) = False) then
  begin
    TIdNotify.NotifyMethod(ShowCannotGetBufferErrorMessage);
    Exit;
  end
  else
  begin

  end;



  case RecordTypeIndex of
  0:  begin
      aMyRecord.Value := aMyRecord.ByteArrayToMyRecord(LBuffer);
      ShowTMyRecord(aMyRecord.Value);
      end;
  1:  begin
      aINDYCMD.Value := aINDYCMD.ByteArrayToMyRecord(LBuffer);
      ShowTINDYCMD( aINDYCMD.Value);
  end
  else

  end;


  // MyRecord.Lock;

  // MyRecord.value := aINDYCMD.value;

  // TIdNotify.NotifyMethod(RecordReceived);

  // MyRecord.Unlock;



  MyLRecord.FileName := 'SERVERSIDE-TXT';
  MyLRecord.Details := 'OK';
  MyLRecord.FileSize := random(123);
  MyLRecord.Recordsize := random(10) - 5;
  MyLRecord.FileDate := now;

  aMyRecord.Value:= MyLRecord;


  MyLIndy.CMD_CLASS := 9999;
  MyLIndy.CMD_VALUE:='the server has a bit to explain ... to you :-)';
  MyLIndy.CMD_TIMESTAMP := now;

  aINDYCMD.value :=  MyLIndy;

  case RecordTypeIndex2 of
  0:  LBuffer := aMyRecord.MyRecordToByteArray(aMyRecord.Value);
  1:  LBuffer := aINDYCMD.MyRecordToByteArray(aINDYCMD.Value);
  else

  end;



  if (SendBuffer(AContext, LBuffer) = False) then
  begin
    TIdNotify.NotifyMethod(ShowCannotSendBufferErrorMessage);
    Exit;
  end;


    Memo1.Lines.Add('svr end execute !');
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
    RecordTypeIndex2 := RadioGroup1.ItemIndex
end;

procedure TForm1.RecordReceived;
begin
  Memo1.Lines.Add('-------------------<START>----------------');
  Memo1.Lines.Add('Details ' + MyRecord.value.Details);
  Memo1.Lines.Add('FileName = ' + MyRecord.value.FileName);
  Memo1.Lines.Add('FileSize = ' + INtToStr(MyRecord.value.FileSize));
  Memo1.Lines.Add('Date = ' + DateToStr(MyRecord.value.FileDate));
  Memo1.Lines.Add('Time = ' + TimeToStr(MyRecord.value.FileDate));
  Memo1.Lines.Add('RecordSize = ' + INtToStr(MyRecord.value.Recordsize));
  Memo1.Lines.Add('-------------------<END>----------------');
end;

procedure TForm1.RecordTypeRadioGroupClick(Sender: TObject);
begin
    RecordTypeIndex := RecordTypeRadioGroup.ItemIndex;
end;

procedure TForm1.ShowTMyRecord (aRecord : TMyrecord);
begin
    Memo1.Lines.Add('-------------------<START>----------------');
    Memo1.Lines.Add('Server says it has received your record, "OK" message received.');
    Memo1.Lines.Add('received data ' + aRecord .Details );
    Memo1.Lines.Add('received data ' + aRecord .FileName );
    Memo1.Lines.Add('received data ' + IntToStr(aRecord .FileSize) );
    Memo1.Lines.Add('received data ' + IntToStr(aRecord .Recordsize) );
    Memo1.Lines.Add('received data ' + dateToStr(aRecord.FileDate) );
    Memo1.Lines.Add('received data ' + TimeToStr(aRecord.FileDate) );
    Memo1.Lines.Add('-------------------<END>----------------');

end;


procedure TForm1.ShowTINDYCMD (aINDYCMD : TINDYCMD);
begin
    Memo1.Lines.Add('-------------------<START>----------------');
    Memo1.Lines.Add('Server says it has received your record, "OK" message received.');
    Memo1.Lines.Add('received data ' + IntToStr( aINDYCMD.CMD_CLASS ));
    Memo1.Lines.Add('received data ' + aINDYCMD.CMD_VALUE);
    Memo1.Lines.Add('received data ' + Datetostr(aINDYCMD.CMD_TIMESTAMP));
    Memo1.Lines.Add('received data ' + Timetostr(aINDYCMD.CMD_TIMESTAMP));
     Memo1.Lines.Add('-------------------<END>----------------');
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
