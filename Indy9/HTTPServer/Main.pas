{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  23275: Main.pas 
{
{   Rev 1.1    25/10/2004 22:49:08  ANeillans    Version: 9.0.17
{ Verified
}
{
{   Rev 1.0    12/09/2003 21:29:30  ANeillans
{ Initial Check in
{ Verified with Indy 9 on D7
}
{
  Demo Name:  HTTP Server
  Created By: Unknown
          On: 27/10/2002

  Notes:
   Basic outline of how to create a HTTP server - does not currently include SSL.
   Binds to IP 127.0.0.1 by default
   Authentication details, if enabled:
    Username: Indy
    Password: rocks

  Version History:
     12th Sept 03: Andy Neillans
                   Revised the default HTML pages to something a little more interesting.
     
  Tested:
   Indy 9:
     D5:     Untested
     D6:     Untested
     D7:     25th Oct 2004 by Andy Neillans
             Tested with Internet Explorer 6
}
unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, StdCtrls, IdComponent, IdTCPServer, IdHTTPServer, Buttons,
  ComCtrls, IdGlobal, IdBaseComponent, IdThreadMgr, IdThreadMgrDefault, syncobjs,
  IdThreadMgrPool, ExtCtrls, IdIntercept, IdIOHandlerSocket,
  IdCustomHTTPServer, idSocketHandle;

type
  TfmHTTPServerMain = class(TForm)
    HTTPServer: TIdHTTPServer;
    alGeneral: TActionList;
    acActivate: TAction;
    edPort: TEdit;
    cbActive: TCheckBox;
    StatusBar1: TStatusBar;
    edRoot: TEdit;
    LabelRoot: TLabel;
    cbAuthentication: TCheckBox;
    cbManageSessions: TCheckBox;
    cbEnableLog: TCheckBox;
    Label1: TLabel;
    Panel1: TPanel;
    lbLog: TListBox;
    lbSessionList: TListBox;
    Splitter1: TSplitter;
    procedure acActivateExecute(Sender: TObject);
    procedure edPortChange(Sender: TObject);
    procedure edPortKeyPress(Sender: TObject; var Key: Char);
    procedure edPortExit(Sender: TObject);
    procedure HTTPServerCommandGet(AThread: TIdPeerThread;
      RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HTTPServerSessionEnd(Sender: TIdHTTPSession);
    procedure HTTPServerSessionStart(Sender: TIdHTTPSession);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lbSessionListDblClick(Sender: TObject);
    procedure cbSSLClick(Sender: TObject);
    procedure HTTPServerConnect(AThread: TIdPeerThread);
    procedure HTTPServerDisconnect(AThread: TIdPeerThread);
    procedure HTTPServerExecute(AThread: TIdPeerThread);
    procedure HTTPServerCommandOther(Thread: TIdPeerThread;
      const asCommand, asData, asVersion: String);
    procedure HTTPServerStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
  private
    UILock: TCriticalSection;
    procedure ServeVirtualFolder(AThread: TIdPeerThread;
      RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    procedure DisplayMessage(const Msg: String);
    procedure DisplaySessionChange(const session: string);
    procedure ManageUserSession(AThread: TIdPeerThread;
      RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    function GetMIMEType(sFile: TFileName): String;
    { Private declarations }
  public
    { Public declarations }
    EnableLog: boolean;
    MIMEMap: TIdMIMETable;
    procedure MyInfoCallback(Msg: String);
    procedure GetKeyPassword(var Password: String);
  end;

var
  fmHTTPServerMain: TfmHTTPServerMain;

implementation

uses FileCtrl, IdStack;

{$R *.DFM}

procedure TfmHTTPServerMain.acActivateExecute(Sender: TObject);
var
  Binding : TIdSocketHandle;
begin
  acActivate.Checked := not acActivate.Checked;
  lbSessionList.Items.Clear;
  if not HTTPServer.Active then
  begin
    HTTPServer.Bindings.Clear;
    Binding := HTTPServer.Bindings.Add;
    Binding.Port := StrToIntDef(edPort.text, 80);
    Binding.IP := '127.0.0.1';
  end;

  if not DirectoryExists(edRoot.text) then
  begin
    DisplayMessage(Format('Web root folder (%s) not found.',[edRoot.text]));
    acActivate.Checked := False;
  end
  else
  begin
    if acActivate.Checked then
    begin
      try
        EnableLog := cbEnableLog.Checked;
        HTTPServer.SessionState := cbManageSessions.Checked;
        HTTPServer.Active := true;
        DisplayMessage(format('Listening for HTTP connections on %s:%d.',[HTTPServer.Bindings[0].IP, HTTPServer.Bindings[0].Port]));
      except
        on e: exception do
        begin
          acActivate.Checked := False;
          DisplayMessage(format('Exception %s in Activate. Error is:"%s".', [e.ClassName, e.Message]));
        end;
      end;
    end
    else
    begin
      HTTPServer.Active := false;
      // SSL stuff
      HTTPServer.Intercept := nil;
      // End SSL stuff
      DisplayMessage('Stop listening.');
    end;
  end;
  edPort.Enabled := not acActivate.Checked;
  edRoot.Enabled := not acActivate.Checked;
  cbAuthentication.Enabled := not acActivate.Checked;
  cbEnableLog.Enabled := not acActivate.Checked;
  cbManageSessions.Enabled := not acActivate.Checked;
end;

procedure TfmHTTPServerMain.edPortChange(Sender: TObject);
var
  FinalLength, i: Integer;
  FinalText: String;
begin
  // Filter routine. Remove every char that is not a numeric (must do that for cut'n paste)
  Setlength(FinalText, length(edPort.Text));
  FinalLength := 0;
  for i := 1 to length(edPort.Text) do
  begin
    if edPort.text[i] in [ '0'..'9' ] then
    begin
      inc(FinalLength);
      FinalText[FinalLength] := edPort.text[i];
    end;
  end;
  SetLength(FinalText, FinalLength);
  edPort.text := FinalText;
end;

procedure TfmHTTPServerMain.edPortKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in [ '0'..'9', #8 ]) then
    Key := #0;
end;

procedure TfmHTTPServerMain.edPortExit(Sender: TObject);
begin
  if length(trim(edPort.text)) = 0 then
    edPort.text := '80';
end;


procedure TfmHTTPServerMain.ManageUserSession(AThread: TIdPeerThread;
  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
var
  NumberOfView: Integer;
begin
  // Manage session informations
  if assigned(RequestInfo.Session) or (HTTPServer.CreateSession(AThread, ResponseInfo, RequestInfo) <> nil) then
  begin
    RequestInfo.Session.Lock;
    try
      NumberOfView := StrToIntDef(RequestInfo.Session.Content.Values['NumViews'], 0);
      inc(NumberOfView);
      RequestInfo.Session.Content.Values['NumViews'] := IntToStr(NumberOfView);
      RequestInfo.Session.Content.Values['UserName'] := RequestInfo.AuthUsername;
      RequestInfo.Session.Content.Values['Password'] := RequestInfo.AuthPassword;
    finally
      RequestInfo.Session.Unlock;
    end;
  end;
end;

procedure TfmHTTPServerMain.ServeVirtualFolder(AThread: TIdPeerThread;
  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
begin
  ResponseInfo.ContentType := 'text/HTML';
  ResponseInfo.ContentText := '<html><head><title>Virtual folder</title></head><body>';

  if AnsiSameText(RequestInfo.Params.Values['action'], 'close') then
  begin
    // Closing user session
    RequestInfo.Session.Free;
    ResponseInfo.ContentText :=  ResponseInfo.ContentText + '<h1>Session cleared</h1><p><a href="/sessions">Back</a></p>';
  end
  else
  begin
    if assigned(RequestInfo.Session) then
    begin
      if Length(RequestInfo.Params.Values['ParamName'])>0 then
      begin
        // Add a new parameter to the session
        ResponseInfo.Session.Content.Values[RequestInfo.Params.Values['ParamName']] := RequestInfo.Params.Values['Param'];
      end;
      ResponseInfo.ContentText := ResponseInfo.ContentText + '<h1>Session informations</h1>';
      RequestInfo.Session.Lock;
      try
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<table border=1>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<tr><td>SessionID</td><td>' + RequestInfo.Session.SessionID + '</td></tr>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<tr><td>Number of page requested during this session</td><td>'+RequestInfo.Session.Content.Values['NumViews']+'</td></tr>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<tr><td>Session data (raw)</td><td><pre>' + RequestInfo.Session.Content.Text + '</pre></td></tr>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '</table>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<h1>Tools:</h1>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<h2>Add new parameter</h2>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<form method="POST">';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<p>Name: <input type="text" Name="ParamName"></p>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<p>value: <input type="text" Name="Param"></p>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<p><input type="Submit"><input type="reset"></p>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '</form>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<h2>Other:</h2>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<p><a href="' + RequestInfo.Document + '?action=close">Close current session</a></p>';
      finally
        RequestInfo.Session.Unlock;
      end;
    end
    else
    begin
      ResponseInfo.ContentText := ResponseInfo.ContentText + '<p color=#FF000>No session</p>';
    end;
  end;
  ResponseInfo.ContentText := ResponseInfo.ContentText + '</body></html>';
end;


procedure TfmHTTPServerMain.DisplaySessionChange(const Session: string);
var
  Index: integer;
begin
  if EnableLog then
  begin
    UILock.Acquire;
    try
      Index := lbSessionList.Items.IndexOf(Session);
      if Index > -1 then
        lbSessionList.Items.Delete(Index)
      else
        lbSessionList.Items.Append(Session);
    finally
      UILock.Release;
    end;
  end;
end;

procedure TfmHTTPServerMain.DisplayMessage(const Msg: String);
begin
  if EnableLog then
  begin
    UILock.Acquire;
    try
      lbLog.ItemIndex := lbLog.Items.Add(Msg);
    finally
      UILock.Release;
    end;
  end;
end;

const
  sauthenticationrealm = 'Indy http server demo';

procedure TfmHTTPServerMain.HTTPServerCommandGet(AThread: TIdPeerThread;
  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);

  procedure AuthFailed;
  begin
    ResponseInfo.ContentText := '<html><head><title>Error</title></head><body><h1>Authentication failed</h1>'#13 +
      'Check the demo source code to discover the password:<br><ul><li>Search for <b>AuthUsername</b> in <b>Main.pas</b>!</ul></body></html>';
    ResponseInfo.AuthRealm := sauthenticationrealm;
  end;

  procedure AccessDenied;
  begin
    ResponseInfo.ContentText := '<html><head><title>Error</title></head><body><h1>Access denied</h1>'#13 +
      'You do not have sufficient priviligies to access this document.</body></html>';
    ResponseInfo.ResponseNo := 403;
  end;

var
  LocalDoc: string;
  ByteSent: Cardinal;
  ResultFile: TFileStream;
begin
  // Log the request
  DisplayMessage(Format( 'Command %s %s received from %s:%d',
                         [RequestInfo.Command, RequestInfo.Document,
                         TIdIOHandlerSocket(AThread.Connection.IOHandler).Binding.PeerIP,
                         TIdIOHandlerSocket(AThread.Connection.IOHandler).Binding.PeerPort]));
  if cbAuthentication.Checked and
     ((RequestInfo.AuthUsername <> 'Indy') or (RequestInfo.AuthPassword <> 'rocks')) then
  begin
    AuthFailed;
    exit;
  end;
  if cbManageSessions.checked then
    ManageUserSession(AThread, RequestInfo, ResponseInfo);
  if (Pos('/session', LowerCase(RequestInfo.Document)) = 1) then
  begin
    ServeVirtualFolder(AThread, RequestInfo, ResponseInfo);
  end
  else
  begin
    // Interprete the command to it's final path (avoid sending files in parent folders)
    LocalDoc := ExpandFilename(edRoot.text + RequestInfo.Document);
    // Default document (index.html) for folder
    if not FileExists(LocalDoc) and DirectoryExists(LocalDoc) and FileExists(ExpandFileName(LocalDoc + '/index.html')) then
    begin
      LocalDoc := ExpandFileName(LocalDoc + '/index.html');
    end;
    if FileExists(LocalDoc) then // File exists
    begin
      if AnsiSameText(Copy(LocalDoc, 1, Length(edRoot.text)), edRoot.Text) then // File down in dir structure
      begin
        if AnsiSameText(RequestInfo.Command, 'HEAD') then
        begin
          // HEAD request, don't send the document but still send back it's size
          ResultFile := TFileStream.create(LocalDoc, fmOpenRead	or fmShareDenyWrite);
          try
            ResponseInfo.ResponseNo := 200;
            ResponseInfo.ContentType := GetMIMEType(LocalDoc);
            ResponseInfo.ContentLength := ResultFile.Size;
          finally
            ResultFile.Free; // We must free this file since it won't be done by the web server component
          end;
        end
        else
        begin
          // Normal document request
          // Send the document back
          ByteSent := HTTPServer.ServeFile(AThread, ResponseInfo, LocalDoc);
          DisplayMessage(Format('Serving file %s (%d bytes / %d bytes sent) to %s:%d',
                                [LocalDoc, ByteSent, FileSizeByName(LocalDoc),
                                 TIdIOHandlerSocket(AThread.Connection.IOHandler).Binding.PeerIP,
                                 TIdIOHandlerSocket(AThread.Connection.IOHandler).Binding.PeerPort]));
        end;
      end
      else
        AccessDenied;
    end
    else
    begin
      ResponseInfo.ResponseNo := 404; // Not found
      ResponseInfo.ContentText := '<html><head><title>Error</title></head><body><h1>' + ResponseInfo.ResponseText + '</h1></body></html>';
    end;
  end;
end;

procedure TfmHTTPServerMain.FormCreate(Sender: TObject);
begin
  UILock := TCriticalSection.Create;
  MIMEMap := TIdMIMETable.Create(true);
  edRoot.text := ExtractFilePath(Application.exename) + 'Web';
  if HTTPServer.active then  caption := 'active' else caption := 'inactive';
end;

procedure TfmHTTPServerMain.FormDestroy(Sender: TObject);
begin
  MIMEMap.Free;
  UILock.Free;
end;

function TfmHTTPServerMain.GetMIMEType(sFile: TFileName): String;
begin
  result := MIMEMap.GetFileMIMEType(sFile);
end;

procedure TfmHTTPServerMain.HTTPServerSessionEnd(Sender: TIdHTTPSession);
var
  dt: TDateTime;
  i: Integer;
  hour, min, s, ms: word;
begin
  DisplayMessage(Format('Ending session %s at %s',[Sender.SessionID, FormatDateTime(LongTimeFormat, now)]));
  dt := (StrToDateTime(sender.Content.Values['StartTime'])-now);
  DecodeTime(dt, hour, min, s, ms);
  i := ((Trunc(dt)*24 + hour)*60 + min)*60 + s;
  DisplayMessage(Format('Session duration was: %d seconds', [i]));
  DisplaySessionChange(Sender.SessionID);
end;

procedure TfmHTTPServerMain.HTTPServerSessionStart(Sender: TIdHTTPSession);
begin
  sender.Content.Values['StartTime'] := DateTimeToStr(Now);
  DisplayMessage(Format('Starting session %s at %s',[Sender.SessionID, FormatDateTime(LongTimeFormat, now)]));
  DisplaySessionChange(Sender.SessionID);
end;

procedure TfmHTTPServerMain.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  // desactivate the server
  if cbActive.Checked then
    acActivate.execute;
end;

procedure TfmHTTPServerMain.lbSessionListDblClick(Sender: TObject);
begin
  if lbSessionList.ItemIndex > -1 then
  begin
    HTTPServer.EndSession(lbSessionList.Items[lbSessionList.ItemIndex]);
  end;
end;

// SSL stuff
procedure TfmHTTPServerMain.MyInfoCallback(Msg: String);
begin
  DisplayMessage(Msg);
end;

procedure TfmHTTPServerMain.GetKeyPassword(var Password: String);
begin
  Password := 'aaaa';  // this is a password for unlocking the server
                       // key. If you have your own key, then it would
                       // probably be different
end;

procedure TfmHTTPServerMain.cbSSLClick(Sender: TObject);
begin
edPort.Text := '80';
end;


procedure TfmHTTPServerMain.HTTPServerConnect(AThread: TIdPeerThread);
begin
DisplayMessage('User logged in');
end;

procedure TfmHTTPServerMain.HTTPServerDisconnect(AThread: TIdPeerThread);
begin
DisplayMessage('User logged out');
end;

procedure TfmHTTPServerMain.HTTPServerExecute(AThread: TIdPeerThread);
begin
DisplayMessage('Execute');
end;

procedure TfmHTTPServerMain.HTTPServerCommandOther(Thread: TIdPeerThread;
  const asCommand, asData, asVersion: String);
begin
DisplayMessage('Command other: ' + asCommand);
end;

procedure TfmHTTPServerMain.HTTPServerStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
DisplayMessage('Status: ' + aStatusText);
end;

end.
