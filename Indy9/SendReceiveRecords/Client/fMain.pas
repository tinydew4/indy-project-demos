{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110890: fMain.pas 
{
{   Rev 1.0    26/10/2004 13:05:12  ANeillans    Version: 9.0.17
{ Verified
}
unit fMain;

{-----------------------------------------------------------------------------
 Demo Name: Records - client
 Author:    Allen O'Neill
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------
 Notes:

 Demonstrates sending / receiving record data and use of buffers
 Note - sending record data etc can also be done using Streams - this is just another method.

Verified:
  Indy 9:
    D7: 26th Oct 2004 Andy Neillans
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;

type
  Direction = (dirLeft,dirRight);

type
  MyRecord = Packed Record
  MyInteger : Integer;
  MyString : String[250];
  MyBool : Boolean;
  MyDirection : Direction;
  end;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    edtServerIP: TEdit;
    Label2: TLabel;
    edtServerPort: TEdit;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    cboSendDirection: TComboBox;
    Label4: TLabel;
    edtSendMyInteger: TEdit;
    edtSendMyString: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    cboSendMyBoolean: TComboBox;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    cboReceiveDirection: TComboBox;
    edtReceiveMyInteger: TEdit;
    edtReceiveMyString: TEdit;
    cboReceiveMyBoolean: TComboBox;
    Button1: TButton;
    Button2: TButton;
    IdTCPClient: TIdTCPClient;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  MySendingRecord : MyRecord;
  MyReceivingRecord : MyRecord;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
// init
with MySendingRecord do
  begin
  MyInteger := StrToInt(edtSendMyInteger.text);
  MyString := edtSendMyString.text;
  case cboSendDirection.ItemIndex of
    0 : MyDirection := dirLeft;
    1 : MyDirection := dirRight;
    end;
  case cboSendMyBoolean.ItemIndex of
    0 : MyBool := true;
    1 : MyBool := false;
    end;
  end;

cboReceiveDirection.ItemIndex := -1;
edtReceiveMyInteger.text := '';
edtReceiveMyString.text := '';
cboReceiveMyBoolean.ItemIndex := -1;

// send and receive
with IdTCPClient do
  begin
  Host := edtServerIP.text;
  Port := StrToInt(edtServerPort.text);
  Connect;
  WriteBuffer(MySendingRecord,SizeOf(MySendingRecord),true);
  ReadBuffer(MyReceivingRecord,SizeOf(MyReceivingRecord));
  Disconnect;
  end;

// Show record buffer data received back

case MyReceivingRecord.MyDirection of
  dirLeft : cboReceiveDirection.ItemIndex := 0;
  dirRight : cboReceiveDirection.ItemIndex := 1;
  end;

edtReceiveMyInteger.text := IntToStr(MyReceivingRecord.MyInteger);
edtReceiveMyString.text := MyReceivingRecord.MyString;

case MyReceivingRecord.MyBool of
  true : cboReceiveMyBoolean.ItemIndex := 0;
  false : cboReceiveMyBoolean.ItemIndex := 1;
  end;


end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
cboSendDirection.ItemIndex := 0;
cboSendMyBoolean.ItemIndex := 0;
cboReceiveDirection.ItemIndex := -1;
cboReceiveMyBoolean.ItemIndex := -1;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
application.terminate;
end;

end.
