unit Unit_FileExchangeServer;

{ ******************************************************************************

      File Exchange Server Demo Indy 10.5.5

      It just shows how to send/receive Record/Buffer/File.

      No error handling.

      by BdLm

********************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdContext, StdCtrls, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdTCPServer, IdSync, Unit_Indy_Classes, Unit_Indy_Functions, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls;

type
  TFileExchangeServerForm = class(TForm)
    IdTCPServer1: TIdTCPServer;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Button1: TButton;
    SaveFileEdit: TEdit;
    Label1: TLabel;
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

    procedure ShowCannotGetFileErrorMessage;
    procedure ShowCannotSendFileErrorMessage;
    procedure FileReceived;
    { Private declarations }
  public
    { Public declarations }

  end;

var
  FileExchangeServerForm: TFileExchangeServerForm;


  MyErrorMessage: string;

implementation


{$R *.dfm}

uses Unit_DelphiCompilerversionDLG;

procedure TFileExchangeServerForm.Button1Click(Sender: TObject);
begin
   OKRightDlgDelphi.Show;
end;

procedure TFileExchangeServerForm.CheckBox1Click(Sender: TObject);
begin
  IdTCPServer1.Active := CheckBox1.Checked;
end;

procedure TFileExchangeServerForm.ClientConnected;
begin
  Memo1.Lines.Add('A Client connected');
end;

procedure TFileExchangeServerForm.ClientDisconnected;
begin
  Memo1.Lines.Add('A Client disconnected');
end;

procedure TFileExchangeServerForm.FormCreate(Sender: TObject);
begin
  IdTCPServer1.Bindings.Add.IP   := '127.0.0.1';
  IdTCPServer1.Bindings.Add.Port := 6000;
end;

procedure TFileExchangeServerForm.FormDestroy(Sender: TObject);
begin
  IdTCPServer1.Active := False;
end;



procedure TFileExchangeServerForm.IdTCPServer1Connect(AContext: TIdContext);
begin
  TIdNotify.NotifyMethod(ClientConnected);
end;

procedure TFileExchangeServerForm.IdTCPServer1Disconnect(AContext: TIdContext);
begin
  TIdNotify.NotifyMethod(ClientDisconnected);
end;

procedure TFileExchangeServerForm.IdTCPServer1Execute(AContext: TIdContext);
var
  LSize: LongInt;
  file1, file2 :  String;
begin

  Memo1.Lines.Add('Server  starting  .... ' );

  AContext.Connection.IOHandler.ReadTimeout  := 9000;

  file1:= SaveFileEdit.Text;

  if ( ServerReceiveFile(AContext, file1, file2) = False ) then
  begin
    TIdNotify.NotifyMethod(ShowCannotGetFileErrorMessage);
    Exit;
  end
  else
  begin
    Memo1.Lines.Add('Server  done, client file -> ' + file2 );
  end;


  TIdNotify.NotifyMethod(FileReceived);




end;

procedure TFileExchangeServerForm.FileReceived;
begin
  Memo1.Lines.Add('File received' );
end;

procedure TFileExchangeServerForm.ShowCannotGetFileErrorMessage;
begin
  Memo1.Lines.Add('Cannot get file from client, Unknown error occured');
end;

procedure TFileExchangeServerForm.ShowCannotSendFileErrorMessage;
begin
  Memo1.Lines.Add('Cannot send file to client, Unknown error occured');
end;



end.
