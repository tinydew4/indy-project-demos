{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110641: ServerFrmMainUnit.pas 
{
{   Rev 1.0    25/10/2004 23:14:14  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: ServerFrmMainUnit
 Author:    Helge Jung (helge@eco-logic-software.de)
 Copyright: Indy Pit Crew
 Purpose:
 History: Improvements supplied by: Enver ALTIN
-----------------------------------------------------------------------------
 Notes:

 Demonstration on how to use TIdTCPServer and TIdTCPClient
 with using Threads and WriteBuffer/ReadBuffer

Verified:
  Indy 9:
    D7: 25th Oct 2004 by Andy Neillans
}

unit ServerFrmMainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdTCPServer, IdThreadMgr, IdThreadMgrDefault, IdBaseComponent,
  IdComponent;

type
  PClient   = ^TClient;
  TClient   = record  // Object holding data of client (see events)
                DNS         : String[20];            { Hostname }
                Connected,                           { Time of connect }
                LastAction  : TDateTime;             { Time of last transaction }
                Thread      : Pointer;               { Pointer to thread }
              end;

  TServerFrmMain = class(TForm)
                     Server: TIdTCPServer;
                     CBServerActive: TCheckBox;
                     Protocol: TMemo;
                     IdThreadMgrDefault1: TIdThreadMgrDefault;

                     procedure CBServerActiveClick(Sender: TObject);
                     procedure ServerConnect(AThread: TIdPeerThread);
                     procedure ServerExecute(AThread: TIdPeerThread);
                     procedure ServerDisconnect(AThread: TIdPeerThread);
                     procedure FormCreate(Sender: TObject);
                     procedure FormClose(Sender: TObject; var Action: TCloseAction);

                    private

                    public
                   end;

var
  ServerFrmMain   : TServerFrmMain;
  Clients         : TThreadList;     // Holds the data of all clients

implementation

uses GlobalUnit;

{$R *.DFM}

procedure TServerFrmMain.CBServerActiveClick(Sender: TObject);
begin
  Server.Active := CBServerActive.Checked;
end;

procedure TServerFrmMain.ServerConnect(AThread: TIdPeerThread);
var
  NewClient: PClient;

begin
  GetMem(NewClient, SizeOf(TClient));

  NewClient.DNS         := AThread.Connection.LocalName;
  NewClient.Connected   := Now;
  NewClient.LastAction  := NewClient.Connected;
  NewClient.Thread      :=AThread;

  AThread.Data:=TObject(NewClient);

  try
    Clients.LockList.Add(NewClient);
  finally
    Clients.UnlockList;
  end;

  Protocol.Lines.Add(TimeToStr(Time)+' Connection from "'+NewClient.DNS+'"');
end;

procedure TServerFrmMain.ServerExecute(AThread: TIdPeerThread);
var
  ActClient, RecClient: PClient;
  CommBlock, NewCommBlock: TCommBlock;
  RecThread: TIdPeerThread;
  i: Integer;

begin
  if not AThread.Terminated and AThread.Connection.Connected then
  begin
    AThread.Connection.ReadBuffer (CommBlock, SizeOf (CommBlock));
    ActClient := PClient(AThread.Data);
    ActClient.LastAction := Now;  // update the time of last action

    if (CommBlock.Command = 'MESSAGE') or (CommBlock.Command = 'DIALOG') then
    begin  // 'MESSAGE': A message was send - forward or broadcast it
           // 'DIALOG':  A dialog-window shall popup on the recipient's screen
           // it's the same code for both commands...

      if CommBlock.ReceiverName = '' then
      begin  // no recipient given - broadcast
        Protocol.Lines.Add (TimeToStr(Time)+' Broadcasting '+CommBlock.Command+': "'+CommBlock.Msg+'"');
        NewCommBlock := CommBlock;  // nothing to change ;-))

        with Clients.LockList do
        try
          for i := 0 to Count-1 do  // iterate through client-list
	  begin
            RecClient := Items[i];           // get client-object
            RecThread := RecClient.Thread;     // get client-thread out of it
            RecThread.Connection.WriteBuffer(NewCommBlock, SizeOf(NewCommBlock), True);  // send the stuff
          end;
        finally
          Clients.UnlockList;
        end;
      end
      else
      begin  // receiver given - search him and send it to him
        NewCommBlock := CommBlock; // again: nothing to change ;-))
        Protocol.Lines.Add(TimeToStr(Time)+' Sending '+CommBlock.Command+' to "'+CommBlock.ReceiverName+'": "'+CommBlock.Msg+'"');
        with Clients.LockList do
        try
          for i := 0 to Count-1 do
          begin
            RecClient:=Items[i];
            if RecClient.DNS=CommBlock.ReceiverName then  // we don't have a login function so we have to use the DNS (Hostname)
            begin
              RecThread:=RecClient.Thread;
              RecThread.Connection.WriteBuffer(NewCommBlock, SizeOf(NewCommBlock), True);
            end;
          end;
        finally
          Clients.UnlockList;
        end;
      end;
    end
    else
    begin  // unknown command given
      Protocol.Lines.Add (TimeToStr(Time)+' Unknown command from "'+CommBlock.MyUserName+'": '+CommBlock.Command);
      NewCommBlock.Command := 'DIALOG';       // the message should popup on the client's screen
      NewCommBlock.MyUserName := '[Server]';  // the server's username
      NewCommBlock.Msg := 'I don''t understand your command: "'+CommBlock.Command+'"';  // the message to show
      NewCommBlock.ReceiverName := '[return-to-sender]'; // unnecessary

      AThread.Connection.WriteBuffer (NewCommBlock, SizeOf (NewCommBlock), true);  // and there it goes...
    end;
  end;
end;

procedure TServerFrmMain.ServerDisconnect(AThread: TIdPeerThread);
var
  ActClient: PClient;

begin
  ActClient := PClient(AThread.Data);
  Protocol.Lines.Add (TimeToStr(Time)+' Disconnect from "'+ActClient^.DNS+'"');
  try
    Clients.LockList.Remove(ActClient);
  finally
    Clients.UnlockList;
  end;
  FreeMem(ActClient);
  AThread.Data := nil;
end;

procedure TServerFrmMain.FormCreate(Sender: TObject);
begin
  Clients := TThreadList.Create;
end;

procedure TServerFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Server.Active := False;
  Clients.Free;
end;

end.

