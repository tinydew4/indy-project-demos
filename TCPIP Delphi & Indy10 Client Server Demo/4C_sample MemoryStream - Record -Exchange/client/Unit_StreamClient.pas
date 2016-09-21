unit Unit_StreamClient;

{ ------------------------------------------------------------------------------

  Stream Exchange Client Demo Indy 10.5.5

  It just shows how to send/receive Record/Buffer/STREAMS/FILES.

  No error handling.

  version march 2012

  by BDLM


  only use  *.bmp with TImage and loadformstream savetostream

  ------------------------------------------------------------------------------- }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, StdCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.jpeg;

type
  TStreamExchangeClientForm = class(TForm)
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Button_SendStream: TButton;
    IdTCPClient1: TIdTCPClient;
    BuildButton: TButton;
    Image1: TImage;
    procedure CheckBox1Click(Sender: TObject);
    procedure IdTCPClient1Connected(Sender: TObject);
    procedure IdTCPClient1Disconnected(Sender: TObject);
    procedure Button_SendStreamClick(Sender: TObject);
    procedure BuildButtonClick(Sender: TObject);
  private
    procedure SetClientState(aState: Boolean);

    { Private declarations }
  public
    { Public declarations }
    aFs_r: TmemoryStream;


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
var  LBuffer : TBytes;
     LIndyCMD : TIndyCMD;
     aINDYCMD :  TGenericRecord<TINDYCMD>;
begin


  aFs_r := TmemoryStream.Create;

  Image1.Picture.Bitmap.SaveToStream(aFs_r);
  aFs_r.Seek(0,soFromBeginning);


  Memo1.Lines.Add('Try send stream to server.....');


  /// create generic records
  aINDYCMD := TGenericRecord<TINDYCMD>.Create;


  LIndyCMD.CMD_CLASS := random(4);
  LIndyCMD.CMD_VALUE := ' data from the client';
  LIndyCMD.CMD_TIMESTAMP := now;


  aINDYCMD.Value := LINDYCMD;

  LBuffer := aINDYCMD.MyRecordToByteArray(aINDYCMD.Value);




  if (SendBuffer(IdTCPClient1, LBuffer) = False) then
  begin
    Memo1.Lines.Add('Cannot send record/buffer to server.');
    Exit;
  end
  else
  begin
    Memo1.Lines.Add('Succesfully send record/buffer to server.');
  end;



  if (ReceiveStream(IdTCPClient1, TStream(aFs_r)) = False) then
  begin
    Memo1.Lines.Add('Cannot get STREAM from server, Unknown error occured');
    Exit;
  end;

  Memo1.Lines.Add('Stream received: ' + IntToStr(aFs_r.Size));

 //  SetClientState(False);

  aFs_r.Position := 0;
  Image1.Picture.Bitmap.LoadFromStream(aFs_r);




  aFS_r.Free;

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

procedure TStreamExchangeClientForm.IdTCPClient1Connected(Sender: TObject);
begin
  Memo1.Lines.Add('Client has connected to server');
end;

procedure TStreamExchangeClientForm.IdTCPClient1Disconnected(Sender: TObject);
begin
  Memo1.Lines.Add('Client has disconnected from server');
end;

end.
