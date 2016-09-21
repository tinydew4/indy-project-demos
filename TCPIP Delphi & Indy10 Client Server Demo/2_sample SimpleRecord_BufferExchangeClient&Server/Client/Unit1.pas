unit Unit1;

{
      Record/Buffer Exchange Client Demo Indy 10.5.5

      It just shows how to send/receive Record/Buffer.

      No error handling.

      helloy72@yahoo.com
      Adnan


      version november 2011 & march 2012
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
  LBuffer: TBytes;
  LMyRecord: TMyRecord;
  LSize: LongInt;
begin
  LMyRecord.Details := 'My personal data';
  LMyRecord.FileName := 'MyFile.txt';
  LMyRecord.FileSize := 55;
  LMyRecord.FileDate := now;
  LMyRecord.Recordsize := sizeof(LMyRecord);
  LBuffer := MyRecordToByteArray(LMyRecord);

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

  LMyRecord := ByteArrayToMyRecord(LBuffer);
  if LMyRecord.Details = 'OK' then
  begin
    Memo1.Lines.Add('Server says it has received your record, "OK" message received.');
    Memo1.Lines.Add('  ->' + LMyrecord.FileName);
    Memo1.Lines.Add('  ->' + INtToStr(LMyrecord.FileSize));
    Memo1.Lines.Add('  ->' + INtToStr(LMyrecord.Recordsize));
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
