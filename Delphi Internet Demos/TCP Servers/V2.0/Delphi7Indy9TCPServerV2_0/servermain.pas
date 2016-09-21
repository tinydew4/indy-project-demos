unit servermain;
(*
      The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
      http://www.mozilla.org/MPL/

      Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
      ANY KIND, either express or implied. See the License for the specific language governing rights and
      limitations under the License.

      The Initial Developer of the Original Code is David Hooper }=-Loki=-{. Portions created by
       David Hooper are Copyright (C) 2006 David Hooper. All Rights
      Reserved.

*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  IdBaseComponent, IdComponent, IdTCPServer, ComCtrls, StdCtrls, FileCtrl,
  IDStack, IDException, ExtCtrls;

Const
  WM_LogMessage = WM_user + 100;
  WM_DisplayConnectionCount = WM_user + 101;
  WM_ClientFileProgress = WM_user + 102;

// used in the lParam for threads sending log messages
  tlmtinformation = 1;
  tlmtWarning = 2;
  tlmtError = 4;
// used in the lParam for threads sending log messages
  tldNone = 8;
  tldIn = 16;
  tldOut = 32;

// same as above, but used in the main thread's LogMessage() procedure
type TLogMessageType = (lmtInformation, lmtWarning, lmtError);
type TLogDirection = (ldNone, ldIn, ldOut);
// flag so we know what stage the client connection is in. i.e. has it sent a valid password and logged in
type TClientStage = (csNone, csLoggedIn);

// the data object for each client. We store any extra info we want about the client here.
// we also have the events for file transfer here
type
    TClientSpecificData = class(TObject)
  private
      function GetCurrentProgressPercent: integer;
  public
      ClientStage: TClientStage;
      ID: string; // just the unique id we create for each connection
      Username: string;

  // used for file progress
      ProgressMax, CurrentProgress: Int64;
      ShowProgress: boolean;
      property CurrentProgressPercent: integer read GetCurrentProgressPercent;
      procedure TCPClientInsideThreadWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);
      procedure TCPClientInsideThreadWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
      procedure TCPClientInsideThreadWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
      procedure LogProgress;

      Constructor CreateWithSettings(ID_: string);
      Destructor Destroy; override;
  end;

type
  TfServerMain = class(TForm)
    IdTCPServer1: TIdTCPServer;
    ListBox1: TListBox;
    gbSettings: TGroupBox;
    Label1: TLabel;
    ePort: TEdit;
    bListen: TButton;
    bOffline: TButton;
    lConnectionCount: TLabel;
    lbConnections: TListBox;
    Splitter1: TSplitter;
    procedure bListenClick(Sender: TObject);
    procedure bOfflineClick(Sender: TObject);
    procedure IdTCPServer1Connect(AThread: TIdPeerThread);
    procedure IdTCPServer1Disconnect(AThread: TIdPeerThread);
    procedure IdTCPServer1Execute(AThread: TIdPeerThread);
    procedure lbConnectionsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

// the following procedures are run in the context of a client thread
    procedure SendStringWithLogging(AThread: TIdPeerThread; S: string);
    function ReceiveStringWithLogging(AThread: TIdPeerThread): string;

    procedure CMD_LOGIN(AThread: TIdPeerThread; InCmd: string);
    procedure CMD_TIMER(AThread: TIdPeerThread; InCmd: string);
    procedure CMD_COUNTDOWN(AThread: TIdPeerThread; InCmd: string);
    procedure CMD_FILE(AThread: TIdPeerThread);
    procedure CMD_PROCESS(AThread: TIdPeerThread; InCmd: string);
  public
    { Public declarations }
    procedure LogMessage(LogMessageType: TLogMessageType; LogDirection: TLogDirection; S: string);
    procedure ThreadLogMessage(LogMessageType: TLogMessageType; LogDirection: TLogDirection; S: string);
// this procedure allows the "OnConnect" and "OnDisconnect" to finish before reporting the # of clients
    Procedure DisplayConnectionCount(var Msg:TMessage);Message WM_DisplayConnectionCount;
// the following procedures are for catching the windows messages the client thread sends us
    Procedure WriteLog(var Msg:TMessage);Message WM_LogMessage;
    Procedure ClientFileProgress(var Msg:TMessage);Message WM_ClientFileProgress;
  end;

var
  fServerMain: TfServerMain;

IMPLEMENTATION

{$R *.DFM}
procedure TfServerMain.FormCreate(Sender: TObject);
    begin
// get rid of the flicker during file transfer
        lbConnections.DoubleBuffered := True;
    end;
// display our message in a readable format, by using the flags we set (in, out, info, error etc)
procedure TfServerMain.LogMessage(LogMessageType: TLogMessageType; LogDirection: TLogDirection; S: string);
    var
        FullMsg: string;
    begin
        FullMSg := '';
        case LogMessageType of
            lmtInformation: FullMsg := '  ';
            lmtWarning: FullMsg := '? ';
            lmtError: FullMsg := '!  ';
        end;
       
        case LogDirection of
            ldNone: FullMsg := FullMsg + '   ';
            ldIn: FullMsg := FullMsg + '<- ';
            ldOut: FullMsg := FullMsg + '-> ';
        end;
        FullMsg := FullMsg + FormatDateTime('hh":"nn":"ss', Now) + ' ' + S;
        Listbox1.Items.Add(FullMsg);
        while Listbox1.Items.Count > 1000 do Listbox1.Items.Delete(0);
        Listbox1.ItemIndex := pred(Listbox1.Items.Count);
    end;

procedure TfServerMain.SendStringWithLogging(AThread: TIdPeerThread; S: string);
    begin
        AThread.Connection.WriteLn(S);
        ThreadLogMessage(lmtInformation, ldOut, (AThread.Data as TClientSpecificData).ID + ' - ' + S);
    end;

function TfServerMain.ReceiveStringWithLogging(AThread: TIdPeerThread): string;
    begin
        result := AThread.Connection.ReadLn;
        ThreadLogMessage(lmtInformation, ldIn, (AThread.Data as TClientSpecificData).ID + ' - ' + result);
    end;

procedure TfServerMain.bListenClick(Sender: TObject);
    begin
        IdTCPServer1.DefaultPort := StrToIntDef(ePort.Text, 2000);
        IdTCPServer1.Active := True;
        LogMessage(lmtInformation, ldNone, 'BOUND TO PORT ' + IntToStr(IdTCPServer1.DefaultPort));
        LogMessage(lmtInformation, ldNone, 'LISTENING');
    end;

procedure TfServerMain.bOfflineClick(Sender: TObject);
    begin
        IdTCPServer1.Active := False;
        LogMessage(lmtInformation, ldNone, 'OFFLINE');
    end;

procedure TfServerMain.IdTCPServer1Connect(AThread: TIdPeerThread);
    var
        ID_: string;
    begin
        ID_ := AThread.Connection.Socket.Binding.PeerIP + ':' + IntToStr(AThread.Connection.Socket.Binding.PeerPort);
        AThread.Data := TClientSpecificData.CreateWithSettings(ID_);
        AThread.Connection.Tag := integer(AThread.Data); //store our data object here also, so that the file progress knows a bit more about us
        AThread.Connection.OnWorkBegin := (AThread.Data as TClientSpecificData).TCPClientInsideThreadWorkBegin;
        AThread.Connection.OnWork := (AThread.Data as TClientSpecificData).TCPClientInsideThreadWork;
        AThread.Connection.OnWorkEnd := (AThread.Data as TClientSpecificData).TCPClientInsideThreadWorkEnd;

        LogMessage(lmtInformation, ldNone, ID_ + ' Connected');
        PostMessage(fServerMain.Handle, WM_DisplayConnectionCount, 0, 0);
    end;

procedure TfServerMain.IdTCPServer1Disconnect(AThread: TIdPeerThread);
    begin
        if assigned(AThread.Data) then
        begin
            (AThread.Data as TClientSpecificData).Free;
            AThread.Data := nil;
        end;
        if assigned(AThread.Connection.Socket.Binding) then
          LogMessage(lmtInformation, ldNone, AThread.Connection.Socket.Binding.PeerIP + ':' + IntToStr(AThread.Connection.Socket.Binding.PeerPort) + ' Disconnected')
        else
          LogMessage(lmtInformation, ldNone, AThread.Connection.Socket.LocalName + ' Disconnected');
        PostMessage(fServerMain.Handle, WM_DisplayConnectionCount, 0, 0);
    end;

procedure TfServerMain.IdTCPServer1Execute(AThread: TIdPeerThread);
    var
        i: integer;
        S, S2: string;
        InCmd: string;
    begin
        try
            AThread.Connection.ReadTimeout := 1000; // 1 second timeout
            InCmd := ReceiveStringWithLogging(AThread);
            AThread.Connection.ReadTimeout := 30000;// 30 second timeout
// check if user is logged in
            If InCmd <> '' then
            begin
                case (AThread.Data as TClientSpecificData).ClientStage of
                    csNone:
                    begin //LOGIN username password
                        if (pos('LOGIN', uppercase(InCmd)) = 1) then CMD_LOGIN(AThread, copy(InCmd, pos(' ', InCmd) + 1, maxint))
                        else SendStringWithLogging(AThread, 'ERROR Not logged in. Can not use "' + InCmd +'" command');
                    end;
                    csLoggedIn:
                    begin
                        if InCmd = 'PING' then  SendStringWithLogging(AThread, 'PONG') //Note: we do not show logging for this, becaue we want it as fast as possible
                        else if InCmd = 'JUMP' then SendStringWithLogging(AThread, 'Whee!')
                        else if (pos('TIMER ', InCmd) = 1) then CMD_TIMER(AThread, copy(InCmd, pos(' ', InCmd) + 1, maxint))
                        else if (pos('COUNTDOWN ', InCmd) = 1) then CMD_COUNTDOWN(AThread, copy(InCmd, pos(' ', InCmd) + 1, maxint))
                        else if InCmd = 'FILE' then CMD_FILE(AThread)
                        else if (pos('PROCESS ', InCmd) = 1) then CMD_PROCESS(AThread, copy(InCmd, pos(' ', InCmd) + 1, maxint))
                        else if InCmd = 'QUIT' then AThread.Connection.Disconnect
                        else SendStringWithLogging(AThread, 'ERROR Unknown command "' + InCmd +'"');
                    end; // of ClientStage = csLoggedIn
                end; // of case notlogged in, or logged in
            end;
        except
            on e: EIdSocketError do
            begin
                if pos('10053', E.Message) > 0 then
                  ThreadLogMessage(lmtInformation, ldNone, 'Client disconnected')
                else
                  ThreadLogMessage(lmtError, ldNone, E.Message);
                Raise;
            end;
            on e: EIdReadTimeout do ;
            on e: exception do
            begin
                if pos('CONNECTION CLOSED GRACEFULLY', uppercase(e.Message)) > 0 then
                  ThreadLogMessage(lmtInformation, ldNone, 'Client disconnected gracefully')
                else
                  ThreadLogMessage(lmtError, ldNone, E.Message);
                Raise;
            end;
        end;
    end;

procedure TfServerMain.ThreadLogMessage(LogMessageType: TLogMessageType; LogDirection: TLogDirection; S: string);
    var
        i: Integer;
        PS: PString;
    begin
        New(PS);
        PS^ := S;
        i := 0;
        if LogMessageType = lmtInformation then i := tlmtInformation;
        if LogMessageType = lmtWarning then i := tlmtWarning;
        if LogMessageType = lmtError then i := tlmtError;

        if LogDirection = ldNone then i := i + tldNone;
        if LogDirection = ldIn then i := i + tldIn;
        if LogDirection = ldOut then i := i + tldOut;
        PostMessage(fServerMain.Handle, WM_LogMessage, Integer(PS), i);
    end;

// HANDLE EACH COMMAND IN ITS' OWN PROCEDURE (JUST TO BE TIDY)

//LOGIN USERNAME PASSWORD
procedure TfServerMain.CMD_LOGIN(AThread: TIdPeerThread; InCmd: string);
    var
        s, s2: string;
        i: integer;
    begin
          delete(InCmd, 1, length('LOGIN ')); // remove the LOGIN part
          i := pos(' ', InCmd);
          if i = 0 then
            SendStringWithLogging(AThread, 'ERROR Not enough parameters for "LOGIN" command. expecting LOGIN <username> <password>')
          else
          begin
              S := copy(InCmd, 1, i-1);
              S2 := copy(InCmd, i+1, maxint);
// check login details here, e.g. fatabase, ini file, whatever. for now we will just always accept
              (AThread.Data as TClientSpecificData).Username := S;
              (AThread.Data as TClientSpecificData).ClientStage := csLoggedIn; // allows other commands
// send the "ID" command, this means login was successful (could just send "OK" if you like
              SendStringWithLogging(AThread, 'ID ' + (AThread.Data as TClientSpecificData).ID);

          end;
    end;

//TIMER SECONDS
procedure TfServerMain.CMD_TIMER(AThread: TIdPeerThread; InCmd: string);
    begin
        sleep(StrToIntDef(InCmd, 5) * 1000); //wait for x seconds, then send a TIMER_STOPPED
        SendStringWithLogging(AThread, 'TIMER_STOPPED');
    end;

//COUNTDOWN SECONDS
procedure TfServerMain.CMD_COUNTDOWN(AThread: TIdPeerThread; InCmd: string);
    var
        i: integer;
    begin
        for i:= StrToIntDef(InCmd, 5) downto 1 do
        begin
            SendStringWithLogging(AThread, 'COUNTDOWN: ' + inttostr(i));
//            AThread.Connection.Socket.WriteLn('countdown: ' + inttostr(i));
            sleep(1000);
        end;
        SendStringWithLogging(AThread, 'COUNTDOWN_END')
    end;

//FILE
//followed by separate FILENAME, then FILESIZE, then the actual STREAM
procedure TfServerMain.CMD_FILE(AThread: TIdPeerThread);
    var
        AStream: TFileStream;
        S: string;
        FileSize: Int64;
        Filename: string;
    begin
        Filename := ReceiveStringWithLogging(AThread);
        S := ReceiveStringWithLogging(AThread); // filesize
        FileSize := StrToInt(S);
        ForceDirectories(ExtractFilePath(Paramstr(0)) + 'In');
        (AThread.Data as TClientSpecificData).ShowProgress := True;
        AStream := TFileStream.Create(ExtractFilePath(Paramstr(0)) + 'In\' + Filename, fmCreate);
        try
            ThreadlogMessage(lmtInformation, ldNone, (AThread.Data as TClientSpecificData).ID + ' - Receiving file "' + Filename + '" ' + IntToStr(Filesize) + ' bytes');
            AThread.Connection.ReadStream(AStream, Filesize, False);
            ThreadLogMessage(lmtInformation, ldNone, (AThread.Data as TClientSpecificData).ID + ' - Received file "' + Filename + '"');
        finally
            FreeAndNil(AStream);
        end;
        (AThread.Data as TClientSpecificData).ShowProgress := False;
        SendStringWithLogging(AThread, 'FILE_OK');
    end;

//PROCESS JOB
procedure TfServerMain.CMD_PROCESS(AThread: TIdPeerThread; InCmd: string);
    const
        PingInterval = 10; // ping every "x" seconds
        PingTimeout = 10; // if no response to "ping" in "x" seconds, then fail
    var
        WaitResult : integer;
        StartupInfo: TStartupInfo;
        ProcessInfo: TProcessInformation;
        iResult : integer;
        Filename: string;
        ClientResponding: Boolean;
        Counter: integer;
        S: string;
        BeforePing, AfterPing: Int64;
    begin
        try
            AThread.Connection.ReadTimeout := PingTimeout * 1000;
            if (uppercase(InCmd) = 'TEST') then
            begin
                if FileExists('C:\Windows\Notepad.exe') then Filename := 'C:\Windows\Notepad.exe'
                else if FileExists('C:\WinNT\Notepad.exe') then Filename := 'C:\WinNT\Notepad.exe';
            end
            else
              Filename := '';
            ClientResponding := True; // default
            Counter := 0;
// for this example we will just run notepad
            if Filename <> '' then
            begin
                FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
                with StartupInfo do
                begin
                    cb := SizeOf(TStartupInfo);
                    dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
(* you could pass sw_show or sw_hide as parameter
sw_hide would make more sense if you do not wish to see anything on the screen
                    but not a good idea if the application doe not close itself*)
                    wShowWindow := SW_SHOW; //visibility;
                end;
                if CreateProcess(nil,PChar(Filename), nil, nil, False, NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo) then
                try
                    repeat
// we are going to check the process is still running
// however, every 10 seconds, we will send a "PING" to the client
// if we do not receive a "PONG" response, we will terminate the process
                        WaitResult := WaitForSingleObject(ProcessInfo.hProcess, 1000); //Wait for 1 seconds at a time.
                        inc(Counter);
                        if Counter >= PingInterval then
                        begin
                            Counter := 0;
                            try
                                BeforePing := GetTickCount;
                                SendStringWithLogging(AThread, 'PING');
                                S := AThread.Connection.ReadLn; // readtimeout is set above (10 seconds)
                                AfterPing := GetTickCount;
                                ThreadLogMessage(lmtInformation, ldIn, (AThread.Data as TClientSpecificData).ID + ' - ' + S + ' (' + IntToStr(AfterPing-BeforePing) + 'ms)');
                            except
                                on e: EIdReadTimeout do ClientResponding := False;
                                on e: exception do
                                begin // assume any error is a read timeout
                                    ClientResponding := False;
                                    ThreadLogMessage(lmtInformation, ldIn, (AThread.Data as TClientSpecificData).ID + ' - Ping Failed: ' + E.Message);
    //Terminate the process
                                    iresult := Integer(TerminateProcess(ProcessInfo.hProcess, 0));
                                    Raise;
                                end;
                            end;
                        end; //of check ping
                    until ( (WaitResult <> WAIT_TIMEOUT) or (not ClientResponding) )
                finally
                    if ProcessInfo.hProcess <> 0 then
                      CloseHandle(ProcessInfo.hProcess);
                    if ProcessInfo.hThread <> 0 then
                      CloseHandle(ProcessInfo.hThread);
                end
                else
                  iresult := GetLastError; // error occurs during CreateProcess see help for details }
            end;
        finally
            if ClientResponding then
            begin
                AThread.Connection.ReadTimeout := 0; // reset to infinite
                SendStringWithLogging(AThread, 'PROCESS_DONE');
            end;
        end;
    end;

{ TClientSpecificData }

constructor TClientSpecificData.CreateWithSettings(ID_: string);
    begin
        Inherited Create;
        ID := ID_;
        ClientStage := csNone;
        Username := '';
        ShowProgress := False;
    end;

destructor TClientSpecificData.Destroy;
    begin
//
        inherited;
    end;

procedure TfServerMain.lbConnectionsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
    var
        progressbarrect: TRect;
        progressrect: TRect;

        lastcolor: tcolor;
        s: string;
        currentx: integer;
        progresspercent: integer;
    begin
        with (Control as TListbox).Canvas do
        begin
(* This ensures the correct highlight color is used *)
            FillRect(Rect);
// outline of progress bar
            progressbarrect.Top := Rect.Top;
            progressbarrect.Left := Rect.Left;
            progressbarrect.Bottom := Rect.Bottom;
            progressbarrect.Right := (progressbarrect.Left + 57);

            lastcolor  := Brush.Color;
            InflateRect(progressbarrect,-2,-2);
            if odSelected in State then
              Brush.Color := clWhite
            else
              Brush.Color := clBlack;
            (Control as TListbox).Canvas.FrameRect(progressbarrect);

// actual progress
            progresspercent := Integer((Control as TListbox).Items.Objects[Index]);
            if progresspercent > 0 then
            begin
                progressrect.Top := progressbarrect.Top + 1;
                progressrect.Left := progressbarrect.Left + 1;
                progressrect.Bottom := progressbarrect.Bottom - 1;
                progressrect.Right := progressrect.Left + 1 + (progresspercent div 2); // to get 1-100 to 1-50 pixels
                Brush.Color := clLime;
                (Control as TListbox).Canvas.FillRect(progressrect);
            end;
            Brush.Color := lastcolor;
            currentx := Rect.Left + (progressbarrect.Right - progressbarrect.Left) + 4 + 2;
            TextOut(currentx, Rect.Top, lbConnections.items[Index]);
        end;
    end;

//used to catch file transfer progress message from thread
//the wParam is a pointer to theclient, the lParam is the %age
procedure TfServerMain.ClientFileProgress(var Msg: TMessage);
    var
        PS:PString;
        S: string;
        i, progresspercent: integer;
        LogMessageType: TLogMessageType;
        LogDirection: TLogDirection;
    begin
        PS:=Pointer(Msg.WParam);
        S := PS^; // the unique "ID" so that we can find it in the listbox. you could pass anything here, even the TIdPeerthread
        Dispose(PS);

        progresspercent := Msg.LParam;
        i := lbConnections.Items.IndexOf(S);
        if i <> -1 then
        begin
            lbConnections.Items.Objects[i] := Pointer(progresspercent);
            lbConnections.Repaint;
        end;
    end;

//used to catch logging message from thread
procedure TfServerMain.WriteLog(var Msg: TMessage);
    var
        PS:PString;
        S: string;
        i: integer;
        LogMessageType: TLogMessageType;
        LogDirection: TLogDirection;
    begin

        PS:=Pointer(Msg.WParam);
        S := PS^;

        i := Msg.LParam;
        if (i and tlmtinformation) = tlmtinformation then LogMessageType := lmtInformation;
        if (i and tlmtwarning) = tlmtwarning then LogMessageType := lmtWarning;
        if (i and tlmterror) = tlmterror then LogMessageType := lmtError;

        if (i and tldNone) = tldNone then LogDirection := ldNone;
        if (i and tldIn) = tldIn then LogDirection := ldIn;
        if (i and tldOut) = tldOut then LogDirection := ldOut;
        LogMessage(LogMessageType, LogDirection, S);

        //        FS.WriteBuffer(S^[1],Length(S^));
        Dispose(PS);
    end;
// used to catch connects and disconnects, and display the connection info at a suitable time (ie. after the connect or dsconnect)
procedure TfServerMain.DisplayConnectionCount(var Msg: TMessage);
    var
        i: integer;
        FoundDisconnection: boolean;
    begin
        FoundDisconnection := False;
        with IdTCPServer1.Threads.LockList do
         try
            lbConnections.Items.BeginUpdate;
            lbConnections.Items.Clear;
            lConnectionCount.Caption := IntToStr(Count) + ' connections';
            for i := 0 to Count - 1 do
            begin
                if assigned( TIdPeerThread(Items[i]).Data) then
                  lbConnections.Items.Add( TClientSpecificData(TIdPeerThread(Items[i]).Data).ID)
                else
                begin
// with Indy9, you can get this message before the client has completely disconnected.
// in that situation, we  do this routine again, by which time, the client has completely gone. 
                    lbConnections.Items.Add( 'Disconnecting...' );
                    FoundDisconnection := True;
                end;
            end;
         finally
            lbConnections.Items.EndUpdate;
            IdTCPServer1.Threads.UnLockList;
         end;
         if FoundDisconnection then
           PostMessage(fServerMain.Handle, WM_DisplayConnectionCount, 0, 0);
    end;

//start of file transfer
procedure TClientSpecificData.TCPClientInsideThreadWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);
    var
        ClientSpecificData: TClientSpecificData;
    begin
        if ShowProgress then
        begin
            ClientSpecificData := TClientSpecificData((Sender as TIdTCPServerConnection).Tag);
            ClientSpecificData.ProgressMax := AWorkCountMax;
            ClientSpecificData.CurrentProgress := 0;
            ClientSpecificData.LogProgress;
        end;
    end;
// file transfer progress
procedure TClientSpecificData.TCPClientInsideThreadWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
    var
        ClientSpecificData: TClientSpecificData;
    begin
        if ShowProgress then
        begin
            ClientSpecificData := TClientSpecificData((Sender as TIdTCPServerConnection).Tag);
            ClientSpecificData.CurrentProgress := CurrentProgress + AWorkCount;
            ClientSpecificData.LogProgress;
        end;
    end;
// end of file transfer
procedure TClientSpecificData.TCPClientInsideThreadWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    var
        ClientSpecificData: TClientSpecificData;
    begin
        if ShowProgress then
        begin
            ClientSpecificData := TClientSpecificData((Sender as TIdTCPServerConnection).Tag);
            ClientSpecificData.CurrentProgress := 0;
            ClientSpecificData.LogProgress;
        end;
    end;
//post a message about the transfer. the wParam is a pointer to this client, the lParam is the %age
procedure TClientSpecificData.LogProgress;
    var
        i: Integer;
        PS: PString;
    begin
        New(PS);
        PS^ := ID;
        PostMessage(fServerMain.Handle, WM_ClientFileProgress, Integer(PS), CurrentProgressPercent);
    end;

//convert the data sent / total into a nice %age
function TClientSpecificData.GetCurrentProgressPercent: integer;
    begin
        if ProgressMax = 0 then
          result := 0
        else
          result := Trunc(CurrentProgress / ProgressMax);
        if result > 100 then result := 100; // occasionally indy includes its' own data as part of the count
    end;

end.

