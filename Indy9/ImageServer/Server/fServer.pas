{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110838: fServer.pas 
{
{   Rev 1.0    26/10/2004 13:04:58  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: ImageServer
 Author:    Allen O'Neill
 Copyright: Indy Pit Crew
 Purpose: *** WINDOWS DEMO ONLY ***
 History:
-----------------------------------------------------------------------------
 Notes:

 Demonstrates sending images / data using streams using TCP server / client

 Note - adding items to the list box as per this demo is NOT threadsafe - you should
 use the demo from "NotifyDemo" to learn how to synchronise safely using Indy

Verified:
  Indy 9:
    D7: 26th Oct 2004 Andy Neillans
}


unit fServer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, IdBaseComponent, IdComponent, IdTCPServer, StdCtrls,IdGlobal,
  SyncObjs;

type
  TfrmServer = class(TForm)
    IdTCPServer: TIdTCPServer;
    lstRequests: TListBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure IdTCPServerDisconnect(AThread: TIdPeerThread);
    procedure IdTCPServerExecute(AThread: TIdPeerThread);
    procedure IdTCPServerConnect(AThread: TIdPeerThread);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  CS : TCriticalSection;
  Function GetList : String;
  procedure ScreenShot(x : integer; y : integer; Width : integer; Height : integer; bm : TBitMap);
  end;

var
  frmServer: TfrmServer;
  sFilePattern : String;

implementation

{$R *.DFM}

// activates TCP server
procedure TfrmServer.FormCreate(Sender: TObject);
begin
CS := TCriticalSection.Create;
IdTCPServer.Active := true;
if IdTCPServer.Active = true then
    lstRequests.items.append('Active');
end;

procedure TfrmServer.IdTCPServerDisconnect(AThread: TIdPeerThread);
begin
lstRequests.items.append('Dis-Connected');
end;

// interpets request and sends back data
procedure TfrmServer.IdTCPServerExecute(AThread: TIdPeerThread);
var
    s, sCommand, sAction : string;
    fStream : TFileStream;
    tBM : tbitmap;
begin
CS.Enter;
try



s := uppercase(AThread.Connection.ReadLn);
sCommand := copy(s,1,3);
sAction := copy(s,5,100);

if sCommand = 'LST' then
    begin
    AThread.Connection.WriteLn(GetList);
    AThread.Connection.Disconnect;
    end
else
if sCommand = 'PIC' then
    begin
    if FileExists(ExtractFileDir(ParamStr(0)) + '\images\' + sAction) then
        Begin
        lstRequests.items.add('Serving up: ' + sAction);
        // open file stream to image requested
        fStream := TFileStream.Create(ExtractFileDir(ParamStr(0)) + '\images\' + sAction,fmOpenRead	+ fmShareDenyNone);
        // copy file stream to write stream
        AThread.Connection.OpenWriteBuffer;
        AThread.Connection.WriteStream(fStream);
        AThread.Connection.CloseWriteBuffer;
        // free the file stream
        FreeAndNil(fStream);
        lstRequests.items.add('File transfer completed');
        End
    else
    AThread.Connection.WriteLn('ERR - Requested file does not exist');
    AThread.Connection.Disconnect;
    End
else
if sCommand = 'SRN' then
    begin
    // in production version you would use a unique file name such as one generated
    // from a tickcount plus client IP / id etc.
    // take snapshot
    lstRequests.items.add('Taking screen snap shot');
    tBM := TBitmap.Create;
    ScreenShot(0,0,Screen.Width,Screen.height,tBM);
    if fileExists (ExtractFileDir(ParamStr(0)) + '\images\ScreenShot.BMP') then DeleteFile(ExtractFileDir(ParamStr(0)) + '\images\ScreenShot.BMP');
    tBM.SaveToFile(ExtractFileDir(ParamStr(0)) + '\images\ScreenShot.BMP');
    tBm.FreeImage;
    FreeAndNil(tBM);

    lstRequests.items.add('Serving up: SCREENSHOT.BMP');
    // open file stream to image requested
    fStream := TFileStream.Create(ExtractFileDir(ParamStr(0)) + '\images\ScreenShot.BMP',fmOpenRead	+ fmShareDenyNone);
    // copy file stream to write stream
    AThread.Connection.OpenWriteBuffer;
    AThread.Connection.WriteStream(fStream);
    AThread.Connection.CloseWriteBuffer;
    // free the file stream
    FreeAndNil(fStream);
    lstRequests.items.add('File transfer completed');

    AThread.Connection.Disconnect;
    End
else
if (sCommand <> 'LST') and (sCommand <> 'PIC') and (sCommand <> 'SRN') then
    Begin
    AThread.Connection.WriteLn('ERR : Unknown command / action');
    AThread.Connection.Disconnect;
    end;
except
on E : Exception do
ShowMessage(E.Message);
End;
CS.Leave;
end;

procedure TfrmServer.IdTCPServerConnect(AThread: TIdPeerThread);
begin
lstRequests.items.add('Server connected');
end;

// Simple function to search given path and return BMP file names in comma delimited format
// NOTE! .. assumes in demo version there is a sub-folder off executable called 'images" that contains
// sample valid BMP images
Function TfrmServer.GetList : String;
var
    SR : TSearchRec;
    S : String;
Begin
sFilePattern := ExtractFileDir(ParamStr(0)) + '\images\*.bmp';
S := '';
if FindFirst(sFilePattern,faAnyFile,SR) = 0 then
    Begin
    s := SR.Name;
    while FindNext(sr) = 0 do
        s := s + ',' + SR.Name;
    End;
result := s;
End;


// This ScrenShot code taken from the frequent usenet postings of
// Joe C. Hecht <joehecht@gte.net>  http://home1.gte.net/joehecht/index.htm
procedure TfrmServer.ScreenShot(x : integer; y : integer; Width : integer; Height : integer; bm : TBitMap);
var
  dc: HDC; lpPal : PLOGPALETTE;
begin
{test width and height}
  if ((Width = 0) OR (Height = 0)) then exit;
  bm.Width := Width;
  bm.Height := Height;
{get the screen dc}
  dc := GetDc(0);
  if (dc = 0) then exit;
{do we have a palette device?}
  if (GetDeviceCaps(dc, RASTERCAPS) AND
      RC_PALETTE = RC_PALETTE) then
      begin
      {allocate memory for a logical palette}
        GetMem(lpPal, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)));
      {zero it out to be neat}
        FillChar(lpPal^, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)), #0);
      {fill in the palette version}
        lpPal^.palVersion := $300;
      {grab the system palette entries}
        lpPal^.palNumEntries :=
          GetSystemPaletteEntries(dc,0,256,lpPal^.palPalEntry);
        if (lpPal^.PalNumEntries <> 0) then
            begin
            {create the palette}
            bm.Palette := CreatePalette(lpPal^);
            end;
        FreeMem(lpPal, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)));
      end;
{copy from the screen to the bitmap}
BitBlt(bm.Canvas.Handle,0,0,Width,Height,Dc,x,y,SRCCOPY);
{release the screen dc}
ReleaseDc(0, dc);
end;



procedure TfrmServer.FormDestroy(Sender: TObject);
begin
FreeAndNil(CS);
end;

end.
