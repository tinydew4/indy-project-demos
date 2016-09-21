unit InteractiveClientMain;
(*
This demo shows how to send commands to a TCPClient in a thread, which sends them  to a
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, ExtCtrls,
  IDException, IdExceptionCore, IdObjs, IdSys,
  DelimitedStringList; // written by Loki for Delphi 5

// The next 2 types are used when logging messages to let us know what type of message it is
type TLogMessageType = (lmtInformation, lmtWarning, lmtError);
type TLogDirection = (ldNone, ldIn, ldOut);

type TClientStage = (cs_Disconnected, cs_Connected, cs_LoggedIn);
type TOnStageChange = procedure(Sender: TObject; Stage: TClientStage) of object;
{
This is the thread class that will hold our TCP client. It synchronizes logging messages
and file progress to the main thread
}
type
    TIndyInaThread = class(TThread)
    private
        TCPClientInsideThread: TIdTCPClient;
        fStage: TClientStage;
        fOnStageChange: TOnStageChange;
        CommandString: string; // including parameters
        Parameters: TDelimitedStringList;
        PingTime: Int64;
        procedure TCPClientInsideThreadConnected(Sender: TObject);
        procedure TCPClientInsideThreadDisconnected(Sender: TObject);

        procedure TCPClientInsideThreadWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
        procedure TCPClientInsideThreadWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
        procedure TCPClientInsideThreadWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
        procedure SendStringWithLogging(S: string);
        function ReceiveStringWithLogging: string;
        procedure ThreadLogMessage(LogMessageType_: TLogMessageType; LogDirection_: TLogDirection; S: string);
        procedure SetStage(const Value: TClientStage);
        property Stage: TClientStage read fStage write SetStage;

    public
        ID: string; // unique ID given to us by the server
        LogMessageType: TLogMessageType;
        LogDirection: TLogDirection;
        MessageText: string;

// next 3 properties are for file sending
        ShowProgress: boolean; // flag to synchronize progress data for file sending
        ProgressMax: Int64;
        CurrentProgress: Int64;
        constructor Create(OnStageChange_: TOnStageChange; OnCompleteEvent: TNotifyEvent);
        procedure Execute; override;
// command routines
        procedure HandleCommand;
        procedure CMD_CONNECT; // ADDRESS PORT
        procedure CMD_DISCONNECT;
        procedure CMD_LOGIN; // USERNAME PASSWORD
        procedure CMD_TIMER; // SECONDS
        procedure CMD_COUNTDOWN; // SECONDS
        procedure CMD_FILE; // FILENAME (this procedure will determine the size and send that with the command also)
        procedure CMD_PROCESS;
        procedure CMD_PING;
// synchronized methods
        procedure SyncLogMessage;
        procedure SyncStartProgress;
        procedure SyncProgress;
        procedure SyncStopProgress;
        procedure CheckForPendingCommands;
        procedure UpdateStage;
    end;


type
  TfInteractiveClientMain = class(TForm)
    gbSettings: TGroupBox;
    Label1: TLabel;
    eAddress: TEdit;
    bConnect: TButton;
    ListBox1: TListBox;
    Label2: TLabel;
    ePort: TEdit;
    ProgressBar1: TProgressBar;
    gbUserInput: TGroupBox;
    pEdit: TPanel;
    eCommand: TEdit;
    lbPendingCommands: TListBox;
    bDisconnect: TButton;
    OpenDialog1: TOpenDialog;
    bSendFileToServer: TButton;
    bLoadBatch: TButton;
    procedure bConnectClick(Sender: TObject);
    procedure eCommandKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bDisconnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bLoadBatchClick(Sender: TObject);
    procedure bSendFileToServerClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IndyInAThread: TIndyInAThread;
    procedure LogMessage(const LogMessageType: TLogMessageType; const LogDirection: TLogDirection; S: string);
    procedure ClientStageChanged(Sender: TObject; Stage: TClientStage);
    procedure TCPThreadComplete(Sender: TObject);
  end;

var
  fInteractiveClientMain: TfInteractiveClientMain;

IMPLEMENTATION

{$R *.DFM}

procedure TfInteractiveClientMain.FormCreate(Sender: TObject);
    begin
        IndyInAThread := TIndyInaThread.Create(ClientStageChanged, TCPThreadComplete);
    end;

procedure TfInteractiveClientMain.FormDestroy(Sender: TObject);
    begin
        IndyInAThread.Terminate;
        IndyInAThread.Waitfor;
    end;


// nicely display the message using the flags (e.g. in, out, info, error)
procedure TfInteractiveClientMain.LogMessage(const LogMessageType: TLogMessageType;
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

procedure TfInteractiveClientMain.bConnectClick(Sender: TObject);
    begin
        lbPendingCommands.Items.Add('CONNECT ' + eAddress.Text + ' ' + ePort.Text);
    end;

procedure TfInteractiveClientMain.bDisconnectClick(Sender: TObject);
    begin
        lbPendingCommands.Items.Add('DISCONNECT');
    end;

procedure TfInteractiveClientMain.ClientStageChanged(Sender: TObject; Stage: TClientStage);
    begin
        case Stage of
          cs_Disconnected:
              begin
                  bConnect.Visible := True;
                  bDisconnect.Visible := False;
                  bSendFileToServer.Visible := False;
              end;
          cs_Connected:
              begin
                  bConnect.Visible := False;
                  bDisconnect.Visible := True;
                  bSendFileToServer.Visible := True;
              end;
          cs_LoggedIn:
              begin
              end;
        end;
    end;


procedure TfInteractiveClientMain.bLoadBatchClick(Sender: TObject);
    begin
        OpenDialog1.Filter := 'text files|*.txt|all files|*.*';
        OpenDialog1.FilterIndex := 1;
        OpenDialog1.InitialDir := ExtractFilePath(Paramstr(0));
        if OpenDialog1.Execute then
          lbPendingCommands.Items.LoadfromFile(OpenDialog1.FileName);
    end;

procedure TfInteractiveClientMain.bSendFileToServerClick(Sender: TObject);
    begin
        OpenDialog1.Filter := 'all files|*.*';
        OpenDialog1.FilterIndex := 1;
        OpenDialog1.InitialDir := ExtractFilePath(Paramstr(0));
        if OpenDialog1.Execute then
          lbPendingCommands.Items.Add('FILE "' + OpenDialog1.FileName + '"');
    end;


{ TIndyInaThread }

constructor TIndyInaThread.Create(OnStageChange_: TOnStageChange; OnCompleteEvent: TNotifyEvent);
    begin
//start but suspend the thread until we ahve set up the tcp client
        inherited Create(True);
// we want to know when this thread has finished, so we set the OnTerminate event
        OnTerminate := OnCompleteEvent;
        TCPClientInsideThread := TIdTCPClient.Create(nil);
        TCPClientInsideThread.ReadTimeout := 0; // this means we never disconnect while waiting to read something
        TCPClientInsideThread.OnWorkBegin := TCPClientInsideThreadWorkBegin;
        TCPClientInsideThread.OnWorkEnd := TCPClientInsideThreadWorkEnd;
        TCPClientInsideThread.OnWork := TCPClientInsideThreadWork;
        Stage := cs_Disconnected;
        fOnStageChange := OnStageChange_;
        resume;
    end;

// this is the main parth of the thread. In this demo, we are simply performing a set list of commands
procedure TIndyInaThread.Execute;
    var
        s: string;
        filename: string;
        AStream: TFileStream;
    begin
        Parameters := TDelimitedStringList.Create; // a escendent of TStringList, written by Loki for Delphi 5
        Parameters.Delimiters.Add(' ');
        CommandString := '';
        try
            repeat
                try
                    Synchronize(CheckForPendingCommands);
                    if CommandString <> '' then
                      HandleCommand
                    else
                      sleep(500); // wait for 1/2 a second before checking for commands again
                except
                    on e: exception do
                      ThreadLogMessage(lmtError, ldNone, E.Message);
                end;
            until Terminated
        finally
            Parameters.Clear;
            Parameters.Free;
            if Stage <> cs_Disconnected then
            begin
                TCPClientInsideThread.Disconnect;
                ThreadLogMessage(lmtInformation, ldNone, 'Disconnected');
            end;
            TCPClientInsideThread.Free;
        end;
    end;

// synchronized call to log a message
procedure TIndyInaThread.SyncLogMessage;
    begin
        if not Terminated then
          fInteractiveClientMain.LogMessage(LogMessageType, LogDirection, MessageText);
    end;
// send a command, but also log it to our main form for niceness
procedure TIndyInaThread.SendStringWithLogging(S: string);
    begin
        TCPClientInsideThread.IOHandler.WriteLn(S);
        ThreadLogMessage(lmtInformation, ldOut, S);
    end;

// receive a string, but also log it to our main form for niceness
function TIndyInaThread.ReceiveStringWithLogging: string;
    begin
        result := TCPClientInsideThread.IOHandler.ReadLn;
        if result = '' then
          Raise EIDReadTimeout.Create('TimedOut - later versions of Indy 10 do not raise an exception, so I will');

        ThreadLogMessage(lmtInformation, ldIn, result);
    end;

// start of file transfer
procedure TIndyInaThread.TCPClientInsideThreadWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    begin
        if ShowProgress then
        begin
            ProgressMax := AWorkCountMax;
            CurrentProgress := 0;
            Synchronize(SyncStartProgress);
        end;
    end;

// file transfer progress
procedure TIndyInaThread.TCPClientInsideThreadWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    begin
        if ShowProgress then
        begin
            CurrentProgress := AWorkCount;
            Synchronize(SyncProgress);
        end;

    end;
// end of file transfer
procedure TIndyInaThread.TCPClientInsideThreadWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
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
        fInteractiveClientMain.ProgressBar1.Position := 0;
        fInteractiveClientMain.ProgressBar1.Max := ProgressMax;
        fInteractiveClientMain.ProgressBar1.Visible := True;
    end;
// synchronized call to shoe the file progress
procedure TIndyInaThread.SyncProgress;
    begin
        fInteractiveClientMain.ProgressBar1.Position := CurrentProgress;
    end;
// synchronized call to let the main form know we have finished sending a file
procedure TIndyInaThread.SyncStopProgress;
    begin
        fInteractiveClientMain.ProgressBar1.Position := 0;
        fInteractiveClientMain.ProgressBar1.Visible := False;
    end;

// This happens when the thread ends.
procedure TfInteractiveClientMain.TCPThreadComplete(Sender: TObject);
    begin
// turn the "connect" button back on, since we have finished
        bConnect.Enabled := True;
    end;

procedure TfInteractiveClientMain.eCommandKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    begin
        if Key = vk_Return then
        begin
            if eCommand.Text <> '' then
            begin
                lbPendingCommands.Items.Add(eCommand.Text);
                eCommand.Text := '';
                Key := 0;
            end;
        end;
    end;

procedure TIndyInaThread.HandleCommand;
    var
        throwaway: string;
        timedout: boolean;
        s: string;
    begin
        Parameters.Clear;
        Parameters.DelimitedText := CommandString;
        CommandString := uppercase(Parameters[0]); // akje the command just the first value eg. "PING"
        Parameters.Delete(0);
// the server will tell us if we are in the wrong stage
        if CommandString = 'CONNECT' then CMD_CONNECT // this will disconnect first if we are connected
        else if CommandString = 'DISCONNECT' then CMD_DISCONNECT
        else if CommandString = 'LOGIN' then CMD_LOGIN
        else if CommandString = 'DISCONNECT' then CMD_DISCONNECT
        else if CommandString = 'PING' then CMD_PING
        else if CommandString = 'TIMER' then CMD_TIMER

//        else if CommandString = 'COUNTDOWN' then CMD_COUNTDOWN
        else if CommandString = 'FILE' then CMD_FILE
        else if CommandString = 'PROCESS' then CMD_PROCESS

// commands that just get a 1 line response that we don't really care about
        else if
          (CommandString = 'JUMP') then
        begin
            SendStringWithLogging(CommandString);
            throwaway := ReceiveStringWithLogging;
        end

        else
        begin
(*  This is an example of how to send an unknown command to the server.
We will then display all messages sent from the server
until it is idle for 2 seconds.
At that point, you could send another command
*)
            Parameters.QuotedTextFields := False;
            if Parameters.count > 0 then
              SendStringWithLogging(CommandString + ' ' + Parameters.DelimitedText)
            else
              SendStringWithLogging(CommandString);

            Parameters.QuotedTextFields := True;
            timedout := false;
            TCPClientInsideThread.ReadTimeout := 2000; // 2 seconds
            try
                repeat
                try
                    S := ReceiveStringWithLogging;
                except
                    on EIDReadTimeout do
                      timedout := true;
                    on e: exception do
                    begin
                        ThreadLogMessage(lmtError, ldNone, 'unspecified command error. ' + E.Message);
                        break;
                    end;
                end;
                until terminated or timedout;
            finally
                TCPClientInsideThread.ReadTimeout := 0; // set back to infinite
            end;

        end;
    end;

procedure TIndyInaThread.CMD_CONNECT;
    begin
        if stage <> cs_Disconnected then
          CMD_DISCONNECT;
        TCPClientInsideThread.Host := Parameters[0]; //Host
        TCPClientInsideThread.Port := StrToIntDef(Parameters[1], 2000); //Port
        try
            TCPClientInsideThread.Connect;
            Stage := cs_Connected;
            TCPClientInsideThread.IOHandler.LargeStream := True;
            ThreadLogMessage(lmtInformation, ldNone, 'Connected to ' + TCPClientInsideThread.Host + ':' + IntToStr(TCPClientInsideThread.Port) );
        except
            on e: exception do
              ThreadLogMessage(lmtError, ldNone, 'Failed to connect to ' + TCPClientInsideThread.Host + ':' + IntToStr(TCPClientInsideThread.Port) + ' ' + E.Message);
        end;
    end;

procedure TIndyInaThread.CMD_DISCONNECT;
    begin
        try
            TCPClientInsideThread.Disconnect;
            ThreadLogMessage(lmtInformation, ldNone, 'Disconnected from ' + TCPClientInsideThread.Host + ':' + IntToStr(TCPClientInsideThread.Port) );
        except
            on e: exception do
              ThreadLogMessage(lmtError, ldNone, 'Error in disconnect from ' + TCPClientInsideThread.Host + ':' + IntToStr(TCPClientInsideThread.Port) + ' ' + E.Message);
        end;
        Stage := cs_Disconnected;
    end;

procedure TIndyInaThread.CMD_LOGIN;
    var
        s: string;
    begin
        SendStringWithLogging('LOGIN ' + Parameters[0] + ' ' + Parameters[1]); //USERNAME PASSWORD  (TestUser password are the test details)
        S := ReceiveStringWithLogging;
        if pos('ERROR', S) = 1 then
          ThreadLogMessage(lmtWarning, ldNone, 'Login failed: ' + S)
        else
        begin // login successful
            Stage := cs_LoggedIn;
// Store unique ID
            if pos('ID ', s) <> 1 then
              ThreadLogMessage(lmtWarning, ldNone, 'Expected "ID" command from server')
            else
            begin
                ID := copy(S, 4, maxint);
            end;
        end;
    end;

procedure TIndyInaThread.CMD_COUNTDOWN;
    var
        s: string;
    begin
        SendStringWithLogging('COUNTDOWN ' + Parameters[0]); //seconds
        repeat
            S := ReceiveStringWithLogging;
        until ( (S = 'COUNTDOWN_END') or Terminated);
    end;

procedure TIndyInaThread.CMD_TIMER;
    var
        throwaway: string;
    begin
        SendStringWithLogging('TIMER ' + Parameters[0]); //seconds
        throwaway := ReceiveStringWithLogging;
    end;

procedure TIndyInaThread.CMD_FILE; //FILENAME
    var
        AStream: TIDStream;
        S: string;
    begin
(* Check the file exists, and get the filesize. THis is just an example of sending more than 1 command. ie.
FILE
filename
filesize
We could of course, change this to send FILE filename filesize - on the same command, but this is a demo after all
*)
        if FileExists(Parameters[0]) then
        begin
            AStream := TIdFileStream.Create(parameters[0], fmOpenRead + fmShareDenyNone);
            try
                SendStringWithLogging('FILE');
                SendStringWithLogging(ExtractFilename(Parameters[0])); // send file name
                SendStringWithLogging(IntToStr(AStream.Size)); //send file size
// TO DO: wait for the server to say "OK" because it may deny the transfer eg. file exists, no free disk space, etc...
                ThreadLogMessage(lmtInformation, ldNone, 'Sending file "' + ExtractFilename(Parameters[0]) + '"');
                ShowProgress := True;
                TCPClientInsideThread.IOHandler.Write(AStream);
                S := ReceiveStringWithLogging;
                if S = 'FILE_OK' then
                  ThreadLogMessage(lmtInformation, ldNone, 'Sent file "' + ExtractFilename(Parameters[0]) + '"')
                else
                  ThreadLogMessage(lmtWarning, ldNone, 'Failed to send file "' + ExtractFilename(Parameters[0]) + '": ' + S)
            finally
                FreeAndNil(AStream);
                ShowProgress := False;
            end;
        end
        else
          ThreadLogMessage(lmtWarning, ldNone, 'FILE (file not found): ' + Parameters[0]);
    end;

procedure TIndyInaThread.CMD_PROCESS; // PROCESSNAME
    var
        s: string;
    begin
        SendStringWithLogging('PROCESS ' + Parameters[0]); // PROCESSNAME
        repeat
// the server will periodically send us a "ping" to see if we are still waiting
// and will send PROCESS_DONE when complete
            S := ReceiveStringWithLogging;
            if ( (S = 'PING') and (not Terminated) ) then SendStringWithLogging('PONG');
        until (S = 'PROCESS_DONE') or Terminated;
    end;

procedure TIndyInaThread.CMD_PING;
    var
        BeforePing, AfterPing: Int64;
        throwaway: string;
    begin
// send PING command to server, this is just an example
        BeforePing := GetTickCount;
        SendStringWithLogging('PING');
        throwaway := ReceiveStringWithLogging;
        AfterPing := GetTickCount; // the "PONG" responsse
        PingTime := AfterPing-BeforePing; // store this in case needed
        ThreadLogMessage(lmtInformation, ldNone, 'Ping time is ' + IntToStr(PingTime) + 'ms');
    end;

procedure TIndyInaThread.CheckForPendingCommands;
    begin
        if fInteractiveClientMain.lbPendingCommands.Items.Count > 0 then
        begin
            self.CommandString := fInteractiveClientMain.lbPendingCommands.Items[0];
// remove the command from the list
            fInteractiveClientMain.lbPendingCommands.Items.Delete(0);
        end
        else
          self.CommandString := '';
    end;

procedure TIndyInaThread.TCPClientInsideThreadConnected(Sender: TObject);
    begin
        Stage := cs_Connected;
    end;

procedure TIndyInaThread.TCPClientInsideThreadDisconnected(Sender: TObject);
    begin
        Stage := cs_Disconnected;
    end;

procedure TIndyInaThread.SetStage(const Value: TClientStage);
    begin
        fStage := Value;
        synchronize(UpdateStage);
    end;

procedure TIndyInaThread.UpdateStage;
    begin
        if assigned(fOnStageChange) then
          fOnStageChange(self, fStage);
    end;

end.
