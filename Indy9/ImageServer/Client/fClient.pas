{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110862: fClient.pas 
{
{   Rev 1.0    26/10/2004 13:05:04  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: ImageClient
 Author:    Allen O'Neill
 Copyright: Indy Pit Crew
 Purpose: *** WINDOWS DEMO ONLY ***
 History:
-----------------------------------------------------------------------------
 Notes:

 Demonstrates sending images / data using streams using TCP server / client

Verified:
  Indy 9:
    D7: 26th Oct 2004 Andy Neillans
}



unit fClient;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient,IdGlobal;

type
  TfrmClient = class(TForm)
    btnGetImageList: TButton;
    lstAvailableImages: TListBox;
    Label1: TLabel;
    Shape1: TShape;
    imgMain: TImage;
    btnGetSelectedImage: TButton;
    btnExit: TButton;
    Label2: TLabel;
    edtServerHost: TEdit;
    IdTCPClient: TIdTCPClient;
    Label3: TLabel;
    btnServerScreenShot: TButton;
    Label4: TLabel;
    edtServerPort: TEdit;
    procedure btnExitClick(Sender: TObject);
    procedure btnGetImageListClick(Sender: TObject);
    procedure btnGetSelectedImageClick(Sender: TObject);
    procedure btnServerScreenShotClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  Procedure LoadItems(S : String);
  end;

var
  frmClient: TfrmClient;

implementation

{$R *.DFM}

procedure TfrmClient.btnExitClick(Sender: TObject);
begin
if MessageDlg('Are you sure you wish to exit?', mtInformation, [mbYes, mbNo], 0)
= mrYes then application.terminate;
end;

// Get list of available images form server
procedure TfrmClient.btnGetImageListClick(Sender: TObject);
begin
try
with IdTCPClient do
    begin
    if connected then DisConnect;
    Host := edtServerHost.text;
    Port := StrToInt(edtServerPort.text);
    Connect;
    WriteLn('LST:');
    lstAvailableImages.Clear;
    LoadItems(ReadLn);
    Disconnect;
    end;
except
on E : Exception do
    ShowMessage(E.Message);
end;
end;

//get selected image in listbox from server
procedure TfrmClient.btnGetSelectedImageClick(Sender: TObject);
var
    ftmpStream : TFileStream;
begin
Try
if lstAvailableImages.itemindex = -1 then
MessageDlg('Cannot proceed until you select an image from the list !', mtInformation, [mbOK], 0)
else
with IdTCPClient do
    begin
    if connected then DisConnect;
    Host := edtServerHost.text;
    Port := StrToInt(edtServerPort.text);
    Connect;
    WriteLn('PIC:' + lstAvailableImages.Items[lstAvailableImages.itemindex]);
    // delete if exists
    // in production situation you might store binary downloads like this in a cache folder
    if FileExists(ExtractFileDir(ParamStr(0)) + '\' + lstAvailableImages.Items[lstAvailableImages.itemindex]) then
        DeleteFile(ExtractFileDir(ParamStr(0)) + '\' + lstAvailableImages.Items[lstAvailableImages.itemindex]);
    ftmpStream := TFileStream.Create(ExtractFileDir(ParamStr(0)) + '\' + lstAvailableImages.Items[lstAvailableImages.itemindex],fmCreate);
    while connected do
        ReadStream(fTmpStream,-1,true);
    FreeAndNil(fTmpStream);
    Disconnect;
    imgMain.Picture.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\' + lstAvailableImages.Items[lstAvailableImages.itemindex]);
end;
except
on E : Exception do
    ShowMessage(E.Message);
end;
end;

// Procedure to break up items in input string
Procedure TfrmClient.LoadItems(S : String);
var
    iPosComma : integer;
    sTmp : string;
begin
try
lstAvailableImages.Clear;
s := trim(s);
while pos(',',s) > 0 do
    Begin
    iPosComma := pos(',',s); // locate commas
    sTmp := copy(s,1,iPosComma - 1); // copy item to tmp string
    lstAvailableImages.items.Add(sTmp); // add to list
    s := copy(s,iPosComma + 1,Length(s)); // delete item from string
    End;
// trap for trailing filename
if length(s) <> 0 then lstAvailableImages.items.Add(s);
except
on E : Exception do
    ShowMessage(E.Message);
end;
End;

// Request screenshot bitmap from server
procedure TfrmClient.btnServerScreenShotClick(Sender: TObject);
var
    ftmpStream : TFileStream;
begin
try
with IdTCPClient do
    begin
    if connected then DisConnect;
    Host := edtServerHost.text;
    Port := StrToInt(edtServerPort.text);
    Connect;
    WriteLn('SRN');
    // delete if exists
    // in production situation you might store binary downloads like this in a cache folder
    if FileExists(ExtractFileDir(ParamStr(0)) + '\ServerScreen.bmp') then
        DeleteFile(ExtractFileDir(ParamStr(0)) + '\ServerScreen.bmp');
    ftmpStream := TFileStream.Create(ExtractFileDir(ParamStr(0)) + '\ServerScreen.bmp',fmCreate);
    while connected do
        ReadStream(fTmpStream,-1,true);
    FreeAndNil(fTmpStream);
    Disconnect;
    imgMain.Picture.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\ServerScreen.bmp');
    end;
except
on E : Exception do
    ShowMessage(E.Message);
end;
end;

end.

