unit Unit1;

{
    String Exchange Client Demo

    It just shows how to send and receive String.

    No error handling

    Most of the code is bdlm's.

    Adnan
    Email: helloy72@yahoo.com


    HINT : define different ouputfolder for x32 and x64 compiled *.exe's
    outPutFolder C:\12_SourceForgeCode\indy10\buildx32\
    outPutFolder C:\12_SourceForgeCode\indy10\buildx64\


    03.03.2012

}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdGlobal;

type
  TClientForm = class(TForm)
    CheckBoxConnectDisconnet: TCheckBox;
    ButtonSendString: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    IdTCPClient1: TIdTCPClient;
    procedure CheckBoxConnectDisconnetClick(Sender: TObject);
    procedure ButtonSendStringClick(Sender: TObject);
    procedure IdTCPClient1Connected(Sender: TObject);
    procedure IdTCPClient1Disconnected(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClientForm: TClientForm;

implementation

{$R *.dfm}

{ TForm1 }

procedure TClientForm.ButtonSendStringClick(Sender: TObject);
var
  LLine: String;
begin

  IdTCPClient1.IOHandler.WriteLn(Edit1.Text, TIdTextEncoding.Default);
  Edit1.Text := '';
  LLine := IdTCPClient1.IOHandler.ReadLn();
  if ( LLine = 'OK' ) then
      Memo1.Lines.Add('Server says it has received your String');

end;

procedure TClientForm.CheckBoxConnectDisconnetClick(Sender: TObject);
begin
  if ( CheckBoxConnectDisconnet.Checked = True ) then
  begin
    IdTCPClient1.Host := '127.0.0.1';
    IdTCPClient1.Port := 6000;
    IdTCPClient1.Connect;
  end
  else
    IdTCPClient1.Disconnect;
end;

procedure TClientForm.IdTCPClient1Connected(Sender: TObject);
begin
  Memo1.Lines.Add('Client connected with server');
end;

procedure TClientForm.IdTCPClient1Disconnected(Sender: TObject);
begin
  Memo1.Lines.Add('Client disconnected from server');
end;

end.
