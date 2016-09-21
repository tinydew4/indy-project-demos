unit Unit1;

{
      Record/Buffer Exchange Client Demo Indy 10.5.5

      It just shows how to send/receive Record/Buffer.

      No error handling.


      This sample use the function

      version november 2011 & march, april  2012
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, StdCtrls;

type
  TRecordClientForm = class(TForm)
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Button_SendBuffer: TButton;
    IdTCPClient1: TIdTCPClient;
    BuildButton: TButton;
    procedure CheckBox1Click(Sender: TObject);
    procedure IdTCPClient1Connected(Sender: TObject);
    procedure IdTCPClient1Disconnected(Sender: TObject);
    procedure Button_SendBufferClick(Sender: TObject);
    procedure BuildButtonClick(Sender: TObject);
  private
    procedure SetClientState(aState: Boolean);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  RecordClientForm: TRecordClientForm;

implementation

uses Unit_Indy_Classes, Unit_Indy_Functions, Unit_DelphiCompilerversionDLG;

{$R *.dfm}

procedure TRecordClientForm.BuildButtonClick(Sender: TObject);
begin
     OKRightDlgDelphi.Show;
end;

procedure TRecordClientForm.Button_SendBufferClick(Sender: TObject);
var
  aINDYCMD :  TGenericRecord<TMyRecord>  ;
  LBuffer: TBytes;
  LMyRecord: TMyRecord;
  LSize: LongInt;
begin

  aINDYCMD := TGenericRecord<TMyRecord>.Create;
  /// very simple record to send to the server


  LMyRecord.Details := 'My personal data';
  LMyRecord.FileName := 'MyFile.txt  on Client Side ';
  LMyRecord.FileSize := random(20000);
  LMyRecord.FileDate := now;
  LMyRecord.Recordsize := sizeof(LMyRecord);



  aINDYCMD.Value := LMyRecord;


  LBuffer := aINDYCMD.MyRecordToByteArray(aINDYCMD.Value);


  if (SendBuffer(IdTCPClient1, LBuffer) = False) then
  begin
    Memo1.Lines.Add('Cannot send record/buffer to server.');
    Exit;
  end;

  if (ReceiveBuffer(IdTCPClient1, LBuffer) = False) then
  begin
    Memo1.Lines.Add('Cannot get "OK" message from server, Unknown error occured');
    Exit;
  end;

  aINDYCMD.Value := aINDYCMD.ByteArrayToMyRecord(LBuffer);

  if aINDYCMD.Value.Details = 'OK' then
  begin
    Memo1.Lines.Add('Server says it has received your record, "OK" message received.');

    Memo1.Lines.Add('received data ' + aINDYCMD.Value.Details );
    Memo1.Lines.Add('received data ' + aINDYCMD.Value.FileName );
    Memo1.Lines.Add('received data ' + IntToStr(aINDYCMD.Value.FileSize) );
    Memo1.Lines.Add('received data ' + IntToStr(aINDYCMD.Value.Recordsize) );
    Memo1.Lines.Add('received data ' + dateToStr(aINDYCMD.Value.FileDate) );
    Memo1.Lines.Add('received data ' + TimeToStr(aINDYCMD.Value.FileDate) );

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
    IdTCPClient1.Port := 6000;
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




end.
