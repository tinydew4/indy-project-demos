unit clientmain;
(*
This demo hows how to do a list of commands from within a thread to a
TCPServer, and display any logging in the main thread

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
  Dialogs, StdCtrls, ComCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;
// The next 2 types are used when logging messages to let us know what type of message it is
type TLogMessageType = (lmtInformation, lmtWarning, lmtError);
type TLogDirection = (ldNone, ldIn, ldOut);
                               
{
This is the thread class that will hold our TCP client. It synchronizes logging messages
and file progress to the main thread
}
type
    TIndyInaThread = class(TThread)
    private
        procedure TCPClientInsideThreadWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
        procedure TCPClientInsideThreadWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);
        procedure TCPClientInsideThreadWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
        procedure SendStringWithLogging(S: string);
        function ReceiveStringWithLogging: string;
        procedure ThreadLogMessage(LogMessageType_: TLogMessageType; LogDirection_: TLogDirection; S: string);
    public
        TCPClientInsideThread: TIdTCPClient;
        ID: string; // unique ID given to us by the server
        LogMessageType: TLogMessageType;
        LogDirection: TLogDirection;
        MessageText: string;

// next 3 properties are for file sending
        ShowProgress: boolean; // flag to synchronize progress data for file sending
        ProgressMax: integer;
        CurrentProgress: integer;
        constructor Create(Host: string; Port: integer; OnCompleteEvent: TNotifyEvent);
        procedure Execute; override;
//synchronized methods
        procedure SyncLogMessage;
        procedure SyncStartProgress;
        procedure SyncProgress;
        procedure SyncStopProgress;

    end;


type
  TfClientMain = class(TForm)
    gbSettings: TGroupBox;
    Label1: TLabel;
    eAddress: TEdit;
    bConnect: TButton;
    ListBox1: TListBox;
    Label2: TLabel;
    ePort: TEdit;
    ProgressBar1: TProgressBar;
    IdTCPClient1: TIdTCPClient;
    procedure bConnectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IndyInAThread: TIndyInAThread;
    procedure LogMessage(const LogMessageType: TLogMessageType; const LogDirection: TLogDirection; S: string);
    procedure TCPThreadComplete(Sender: TObject);
  end;

var
  fClientMain: TfClientMain;

IMPLEMENTATION

{$R *.DFM}
// nicely display the message using the flags (e.g. in, out, info, error)
procedure TfClientMain.LogMessage(const LogMessageType: TLogMessageType;
    const LogDirection: TLogDirection; S: string);
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

procedure TfClientMain.bConnectClick(Sender: TObject);
    begin
        try
            bConnect.Enabled := False;
// create our TCP client thread - This will connect straight away, and begin our batch commands
            IndyInAThread := TIndyInaThread.Create(eAddress.Text, StrToIntDef(ePort.Text, 2000), TCPThreadComplete);

        except
            on e: exception do
              LogMessage(lmtError, ldNone, E.Message);
        end;
    end;

{ TIndyInaThread }

constructor TIndyInaThread.Create(Host: string; Port: integer; OnCompleteEvent: TNotifyEvent);
    begin
//start but suspend the thread until we ahve set up the tcp client
        inherited Create(True);
// we want to know when this thread has finished, so we set the OnTerminate event
        OnTerminate := OnCompleteEvent;
        TCPClientInsideThread := TIdTCPClient.Create(nil);
        TCPClientInsideThread.ReadTimeout := 0; // this means we never disconnect while waiting to read something
        TCPClientInsideThread.Host := Host;
        TCPClientInsideThread.Port := Port;
        TCPClientInsideThread.OnWorkBegin := TCPClientInsideThreadWorkBegin;
        TCPClientInsideThread.OnWorkEnd := TCPClientInsideThreadWorkEnd;
        TCPClientInsideThread.OnWork := TCPClientInsideThreadWork;
// now start the work (ie. connect, do commands)
        resume;
    end;

// this is the main parth of the thread. In this demo, we are simply performing a set list of commands
procedure TIndyInaThread.Execute;
    var
        s: string;
        filename: string;
        AStream: TFileStream;
        BeforePing, AfterPing: Int64;
    begin
        try
            try
                TCPClientInsideThread.Connect;
                ThreadLogMessage(lmtInformation, ldNone, 'Connected to ' + TCPClientInsideThread.Host + ':' + IntToStr(TCPClientInsideThread.Port) );
                SendStringWithLogging('LOGIN TestUser password'); // login with dummy details
                S := ReceiveStringWithLogging;
                if pos('ERROR', S) = 1 then
                  ThreadLogMessage(lmtWarning, ldNone, 'Login failed:' + S)
                else
                begin // login successful
// Store unique ID
                    if pos('ID ', s) <> 1 then
                      ThreadLogMessage(lmtWarning, ldNone, 'Expected "ID" command from server')
                    else
                    begin
                        ID := copy(S, 4, maxint);
// send some test commands
// send PING command to server, this is just an example
                        BeforePing := GetTickCount;
                        SendStringWithLogging('PING');
                        S := ReceiveStringWithLogging;
                        AfterPing := GetTickCount; // the "PONG" responsse
                        ThreadLogMessage(lmtInformation, ldNone, 'Ping time is ' + IntToStr(AfterPing-BeforePing) + 'ms');
// send JUMP command and get 1 line respomse from server
                        SendStringWithLogging('JUMP'); //
                        S := ReceiveStringWithLogging;
// send TIMER command and wait for a TIMER_STOPPED respomse from server
                        SendStringWithLogging('TIMER 5');
                        S := ReceiveStringWithLogging;
// send TIMER command and wait for a TIMER_STOPPED respomse from server
                        SendStringWithLogging('COUNTDOWN 3');
                        repeat
                            S := ReceiveStringWithLogging;
                        until S = 'COUNTDOWN_END';
                       
                       
// Send a FILE (this .exe in fact for a test)
                        filename := 'c:\temp\bigfile.zip';
                        if not fileexists(S) then s := Paramstr(0); // the filename of this exe
                        AStream := TFileStream.Create(filename, fmOpenRead + fmShareDenyNone);
                        try
                            SendStringWithLogging('FILE'); //send command "FILE"
                            SendStringWithLogging(ExtractFilename(filename)); // send file name
                            SendStringWithLogging(IntToStr(AStream.Size)); //send file size
                            ThreadLogMessage(lmtInformation, ldNone, 'Sending file "' + ExtractFilename(filename) + '"');
                            ShowProgress := True;
                            TCPClientInsideThread.WriteStream(AStream);
                            S := ReceiveStringWithLogging;
                            if S = 'FILE_OK' then
                              ThreadLogMessage(lmtInformation, ldNone, 'Sent file "' + ExtractFilename(filename) + '"')
                            else
                              ThreadLogMessage(lmtWarning, ldNone, 'Failed to send file "' + ExtractFilename(filename) + '": ' + S)
                        finally
                            FreeAndNil(AStream);
                            ShowProgress := False;
                        end;
// send PROCESS command and wait for the process to finish on the server
// we will be receiving "PING" messages from the server to check if we are still alive
                        SendStringWithLogging('PROCESS TEST');
                        repeat
                            S := ReceiveStringWithLogging;
                            if S = 'PING' then SendStringWithLogging('PONG'); 
                        until S = 'PROCESS_DONE';
//                    SendStringWithLogging('QUIT');
                    end;
                end;
            except
                on e: exception do
                  ThreadLogMessage(lmtError, ldNone, E.Message);
            end;
        finally
            TCPClientInsideThread.Disconnect;
            ThreadLogMessage(lmtInformation, ldNone, 'Disconnected');
            TCPClientInsideThread.Free;
        end;
    end;
    
// synchronized call to log a message
procedure TIndyInaThread.SyncLogMessage;
    begin
        if not Terminated then
          fClientMain.LogMessage(LogMessageType, LogDirection, MessageText);
    end;
// send a command, but also log it to our main form for niceness
procedure TIndyInaThread.SendStringWithLogging(S: string);
    begin
        TCPClientInsideThread.WriteLn(S);
        ThreadLogMessage(lmtInformation, ldOut, S);
    end;

// receive a string, but also log it to our main form for niceness
function TIndyInaThread.ReceiveStringWithLogging: string;
    begin
        result := TCPClientInsideThread.ReadLn;
        ThreadLogMessage(lmtInformation, ldIn, result);
    end;
// start of file transfer
procedure TIndyInaThread.TCPClientInsideThreadWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
    begin
        if ShowProgress then
        begin
            ProgressMax := AWorkCountMax;
            CurrentProgress := 0;
            Synchronize(SyncStartProgress);
        end;
    end;

// file transfer progress
procedure TIndyInaThread.TCPClientInsideThreadWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
    begin
        if ShowProgress then
        begin
            CurrentProgress := AWorkCount;
            Synchronize(SyncProgress);
        end;

    end;
// end of file transfer
procedure TIndyInaThread.TCPClientInsideThreadWorkEnd(Sender: TObject;
  AWorkMode: TWorkMode);
    begin
        if ShowProgress then
        begin
            CurrentProgress := 0;
            Synchronize(SyncStopProgress);
        end;
    end;
// nice easy procedure to call for logging a message. this takes care of the synchronizing
procedure TIndyInaThread.ThreadLogMessage(LogMessageType_: TLogMessageType; LogDirection_: TLogDirection; S: string);
    begin
        LogMessageType := LogMessageType_;
        LogDirection := LogDirection_;
        MessageText := S;
        Synchronize(SyncLogMessage);
    end;
// synchronized call to let the main form know we are sending a file
procedure TIndyInaThread.SyncStartProgress;
    begin
        fClientMain.ProgressBar1.Position := 0;
        fClientMain.ProgressBar1.Max := ProgressMax;
        fClientMain.ProgressBar1.Visible := True;
    end;
// synchronized call to shoe the file progress
procedure TIndyInaThread.SyncProgress;
    begin
        fClientMain.ProgressBar1.Position := CurrentProgress;
    end;
// synchronized call to let the main form know we have finished sending a file
procedure TIndyInaThread.SyncStopProgress;
    begin
        fClientMain.ProgressBar1.Position := 0;
        fClientMain.ProgressBar1.Visible := False;
    end;

// This happens when the thread ends.
procedure TfClientMain.TCPThreadComplete(Sender: TObject);
    begin
// turn the "connect" button back on, since we have finished
        bConnect.Enabled := True;
    end;

end.

