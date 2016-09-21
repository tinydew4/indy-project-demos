unit Unit1;

{
      Record/Buffer Exchange Client Demo Indy 10.5.5

      It just shows how to send/receive Record/Buffer.

      No error handling.


      ****  GENERIC RECORD HANDLING *****

      Instruction : select correct means corresponding recordtype for
         client send = server get and server send = client get



      version november 2011 & march, april  2012
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, StdCtrls,  Unit_Indy_Classes,
  Vcl.ExtCtrls;

type
  TRecordClientForm = class(TForm)
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Button_SendBuffer: TButton;
    IdTCPClient1: TIdTCPClient;
    BuildButton: TButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    procedure CheckBox1Click(Sender: TObject);
    procedure IdTCPClient1Connected(Sender: TObject);
    procedure IdTCPClient1Disconnected(Sender: TObject);
    procedure Button_SendBufferClick(Sender: TObject);
    procedure BuildButtonClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
  private
    procedure SetClientState(aState: Boolean);

    procedure ShowTMyRecord(aRecord: TMyrecord);
    procedure ShowTINDYCMD(aINDYCMD: TINDYCMD);

    { Private declarations }
  public
    { Public declarations }

    RecordTypeIndex  : Integer;
    RecordTypeIndex2 : Integer;
  end;

var
  RecordClientForm: TRecordClientForm;

implementation

uses  Unit_Indy_Functions, Unit_DelphiCompilerversionDLG;

{$R *.dfm}

procedure TRecordClientForm.BuildButtonClick(Sender: TObject);
begin
     OKRightDlgDelphi.Show;
end;

procedure TRecordClientForm.Button_SendBufferClick(Sender: TObject);
var
  aMyRecord :  TGenericRecord<TMyRecord>  ;
  aINDYCMD  :  TGenericRecord<TINDYCMD>  ;

  LBuffer: TBytes;

  LMyRecord: TMyRecord;
  LIndyCMD : TINDYCMD;

  LSize: LongInt;
begin

  /// create generic records
  aINDYCMD := TGenericRecord<TINDYCMD>.Create;
  aMyRecord := TGenericRecord<TMyRecord>.Create;



  LMyRecord.Details := 'My personal data';
  LMyRecord.FileName := 'MyFile.txt  on Client Side ';
  LMyRecord.FileSize := random(20000);
  LMyRecord.FileDate := now;
  LMyRecord.Recordsize := sizeof(LMyRecord);

  LIndyCMD.CMD_CLASS := 1;
  LIndyCMD.CMD_VALUE := ' data from the client';
  LIndyCMD.CMD_TIMESTAMP := now;


  aINDYCMD.Value := LINDYCMD;
  aMyRecord.Value := LMyRecord;

  case RecordTypeIndex of
  0:  LBuffer := aMyRecord.MyRecordToByteArray(aMyRecord.Value);
  1:  LBuffer := aINDYCMD.MyRecordToByteArray(aINDYCMD.Value);
  else

  end;



  if (SendBuffer(IdTCPClient1, LBuffer) = False) then
  begin
    Memo1.Lines.Add('Cannot send record/buffer to server.');
    Exit;
  end
  else
    Memo1.Lines.Add('Succesfully send record/buffer to server.');

  if (ReceiveBuffer(IdTCPClient1, LBuffer) = False) then
  begin
    Memo1.Lines.Add('Cannot get "OK" message from server, Unknown error occured');
    Exit;
  end;



  case RecordTypeIndex2 of
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



  ///  optional : avoid TimeOut Errors
  ///  SetClientState(false)
end;

procedure TRecordClientForm.CheckBox1Click(Sender: TObject);
begin
  if ( CheckBox1.Checked = True ) then
  begin
     SetClientState(true);
  end
  else
     SetClientState(false);

end;


procedure TRecordClientForm.SetClientState (aState : Boolean);
begin

  if ( aState = True ) then
  begin
    IdTCPClient1.Host := '127.0.0.1';
    IdTCPClient1.Port := 5000;
    IdTCPClient1.Connect;
  end
  else
    IdTCPClient1.Disconnect;


  CheckBox1.Checked := aState;

end;

procedure TRecordClientForm.IdTCPClient1Connected(Sender: TObject);
begin
  Memo1.Lines.Add('Client has connected to server');
end;

procedure TRecordClientForm.IdTCPClient1Disconnected(Sender: TObject);
begin
  Memo1.Lines.Add('Client has disconnected from server');
end;



procedure TRecordClientForm.ShowTMyRecord (aRecord : TMyrecord);
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


procedure TRecordClientForm.ShowTINDYCMD (aINDYCMD : TINDYCMD);
begin
    Memo1.Lines.Add('-------------------<start>----------------');
    Memo1.Lines.Add('Server says it has received your record, "OK" message received.');
    Memo1.Lines.Add('received data ' + IntToStr( aINDYCMD.CMD_CLASS ));
    Memo1.Lines.Add('received data ' + aINDYCMD.CMD_VALUE);
    Memo1.Lines.Add('received data ' + Datetostr(aINDYCMD.CMD_TIMESTAMP));
    Memo1.Lines.Add('received data ' + Timetostr(aINDYCMD.CMD_TIMESTAMP));
     Memo1.Lines.Add('-------------------<END>----------------');
end;


procedure TRecordClientForm.RadioGroup1Click(Sender: TObject);
begin
    RecordTypeIndex := RadioGroup1.ItemIndex;
end;

procedure TRecordClientForm.RadioGroup2Click(Sender: TObject);
begin
    RecordTypeIndex2 := RadioGroup2.ItemIndex;
end;

end.
