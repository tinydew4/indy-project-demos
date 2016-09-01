{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110576: MainForm.pas 
{
{   Rev 1.0    25/10/2004 23:04:20  ANeillans    Version: 9.0.17
{ Verified
}
{
{   Rev 1.0    25/10/2004 23:03:32  ANeillans    Version: 9.0.17
{ Verified
}
(***********************************************************)
(**  Chat room demo                                       **)
(***********************************************************)
(**  Created by: Jeremy Darling    webmaster@eonclash.com **)
(**  Created on: Sept. 21st 2000                          **)
(**  Origional Indy Version: 8.005B                       **)
(***********************************************************)
(**  Updates                                              **)
(***********************************************************)
(**  Sept. 25th 2000 Jeremy Darling                       **)
(**    Added functionality that is commonly wanted in a   **)
(**    chat program.                                      **)
(**      1)  Added send client list on request            **)
(**      2)  Added ability to add system commands         **)
(**                                                       **)
(***********************************************************)

{
Verified:
  Indy 9:
    D7: 25th Oct 2004 by Andy Neillans
}

unit MainForm;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, ToolWin, ImgList, Spin, Menus, SysUtils, Classes, IdBaseComponent,
  IdComponent, IdTCPServer, IdThreadMgr, IdThreadMgrDefault;

type
  TSimpleClient = class(TObject)
    DNS,
    Name        : String;
    ListLink    : Integer;
    Thread      : Pointer;
  end;

  TfrmMain = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Panel2: TPanel;
    lbClients: TListBox;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ImageList1: TImageList;
    Label3: TLabel;
    lblDNS: TLabel;
    tcpServer: TIdTCPServer;
    lblSocketVer: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    seBinding: TSpinEdit;
    IdThreadMgrDefault1: TIdThreadMgrDefault;
    Label6: TLabel;
    memEntry: TMemo;
    Label7: TLabel;
    memEMotes: TMemo;
    Label8: TLabel;
    Label9: TLabel;
    lblClientName: TLabel;
    lblClientDNS: TLabel;
    puMemoMenu: TPopupMenu;
    Savetofile1: TMenuItem;
    Loadfromfile1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ToolBar1: TToolBar;
    btnServerUp: TToolButton;
    ToolButton1: TToolButton;
    btnKillClient: TToolButton;
    btnClients: TToolButton;
    btnPM: TToolButton;
    Label12: TLabel;
    edSyopName: TEdit;
    procedure btnServerUpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure seBindingChange(Sender: TObject);
    procedure tcpServerConnect(AThread: TIdPeerThread);
    procedure tcpServerDisconnect(AThread: TIdPeerThread);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Savetofile1Click(Sender: TObject);
    procedure Loadfromfile1Click(Sender: TObject);
    procedure tcpServerExecute(AThread: TIdPeerThread);
    procedure btnClientsClick(Sender: TObject);
    procedure btnPMClick(Sender: TObject);
    procedure btnKillClientClick(Sender: TObject);
    procedure lbClientsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Clients  : TList;
    procedure UpdateBindings;
    procedure UpdateClientList;
    procedure BroadcastMessage( WhoFrom, TheMessage : String );
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

uses
  IdSocketHandle;  // This is where the IdSocketHandle class is defined.

procedure TfrmMain.UpdateBindings;
var
  Binding : TIdSocketHandle;
begin
{ Set the TIdTCPServer's port to the chosen value }
  tcpServer.DefaultPort := seBinding.Value;
{ Remove all bindings that currently exist }
  tcpServer.Bindings.Clear;
{ Create a new binding }
  Binding := tcpServer.Bindings.Add;
{ Assign that bindings port to our new port }
  Binding.Port := seBinding.Value;
end;

procedure TfrmMain.btnServerUpClick(Sender: TObject);
begin
  try
  { Check to see if the server is online or offline }
    tcpServer.Active := not tcpServer.Active;
    btnServerUp.Down := tcpServer.Active;
    if btnServerUp.Down then
      begin
      { Server is online }
        btnServerUp.ImageIndex := 1;
        btnServerUp.Hint       := 'Shut down server';
      end
    else
      begin
      { Server is offline }
        btnServerUp.ImageIndex := 0;
        btnServerUp.Hint       := 'Start up server';
      end;
  { Setup GUI buttons }
    btnClients.Enabled:= btnServerUp.Down;
    seBinding.Enabled := not btnServerUp.Down;
    edSyopName.Enabled:= not btnServerUp.Down;
  except
  { If we have a problem then rest things }
    btnServerUp.Down  := false;
    seBinding.Enabled := not btnServerUp.Down;
    btnClients.Enabled:= btnServerUp.Down;
    edSyopName.Enabled:= not btnServerUp.Down;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
{ Initalize our clients list }
  Clients := TList.Create;
{ Call updatebindings so that the servers bindings are correct }
  UpdateBindings;
{ Get the local DNS entry for this computer }
  lblDNS.Caption := tcpServer.LocalName;
{ Display the current version of indy running on the system }
  lblSocketVer.Caption := tcpServer.Version;
end;

procedure TfrmMain.seBindingChange(Sender: TObject);
begin
  UpdateBindings;
end;

procedure TfrmMain.tcpServerConnect(AThread: TIdPeerThread);
var
  Client : TSimpleClient;
begin
{ Send a welcome message, and prompt for the users name }
  AThread.Connection.WriteLn('ISD Connection Established...');
  AThread.Connection.WriteLn('Please send valid login sequence...');
  AThread.Connection.WriteLn('Your Name:');
{ Create a client object }
  Client := TSimpleClient.Create;
{ Assign its default values }
  Client.DNS  := AThread.Connection.LocalName;
  Client.Name := 'Logging In';
  Client.ListLink := lbClients.Items.Count;
{ Assign the thread to it for ease in finding }
  Client.Thread := AThread;
{ Add to our clients list box }
  lbClients.Items.Add(Client.Name);
{ Assign it to the thread so we can identify it later }
  AThread.Data := Client;
{ Add it to the clients list }
  Clients.Add(Client);
end;

procedure TfrmMain.tcpServerDisconnect(AThread: TIdPeerThread);
var
  Client : TSimpleClient;
begin
{ Retrieve Client Record from Data pointer }
  Client := Pointer(AThread.Data);
{ Remove Client from the Clients TList }
  Clients.Delete(Client.ListLink);
{ Remove Client from the Clients List Box }
  lbClients.Items.Delete(lbClients.Items.IndexOf(Client.Name));
  BroadcastMessage('System', Client.Name + ' has left the chat.');
{ Free the Client object }
  Client.Free;
  AThread.Data := nil;

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (Clients.Count > 0) and
     (tcpServer.Active) then
    begin
      Action := caNone;
      ShowMessage('Can''t close CBServ while server is online.');
    end
  else
    Clients.Free;
end;

procedure TfrmMain.Savetofile1Click(Sender: TObject);
begin
  if not (puMemoMenu.PopupComponent is TMemo) then
    exit;

  if SaveDialog1.Execute then
    begin
      TMemo(puMemoMenu.PopupComponent).Lines.SaveToFile(SaveDialog1.FileName);
    end;
end;

procedure TfrmMain.Loadfromfile1Click(Sender: TObject);
begin
  if not (puMemoMenu.PopupComponent is TMemo) then
    exit;

  if OpenDialog1.Execute then
    begin
      TMemo(puMemoMenu.PopupComponent).Lines.LoadFromFile(OpenDialog1.FileName);
    end;
end;

procedure TfrmMain.UpdateClientList;
var
  Count : Integer;
begin
{ Loop through all the clients connected to the system and set their names }
  for Count := 0 to lbClients.Items.Count -1 do
    if Count < Clients.Count then
      lbClients.Items.Strings[Count] := TSimpleClient(Clients.Items[Count]).Name;
end;

procedure TfrmMain.tcpServerExecute(AThread: TIdPeerThread);
var
  Client : TSimpleClient;
  Com,     // System command
  Msg    : String;
begin
{ Get the text sent from the client }
  Msg    := AThread.Connection.ReadLn;
{ Get the clients package info }
  Client := Pointer(AThread.Data);
{ Check to see if the clients name has been assigned yet }
  if Client.Name = 'Logging In' then
    begin
    { if not, assign the name and announce the client }
      Client.Name := Msg;
      UpdateClientList;
      BroadcastMessage('System', Msg + ' has just logged in.');
      AThread.Connection.WriteLn(memEntry.Lines.Text);
    end
  else
  { If name is set, then send the message }
  if Msg[1] <> '@' then
    begin
    { Not a system command }
      BroadcastMessage(Client.Name, Msg);
    end
  else
    begin
    { System command }
      Com := UpperCase(Trim(Copy(Msg, 2, Pos(':', Msg) -2)));
      Msg := UpperCase(Trim(Copy(Msg, Pos(':', Msg) +1, Length(Msg))));
      if Com = 'CLIENTS' then
        AThread.Connection.WriteLn( '@' + 'clients:' +
                                    lbClients.Items.CommaText);
    end;
end;

procedure TfrmMain.BroadcastMessage( WhoFrom, TheMessage : String );
var
  Count: Integer;
  List : TList;
  EMote,
  Msg  : String;
begin
  Msg := Trim(TheMessage);

  EMote := Trim(memEMotes.Lines.Values[Msg]);

  if WhoFrom <> 'System' then
    Msg := WhoFrom + ': ' + Msg;

  if EMote <> '' then
    Msg := Format(Trim(EMote), [WhoFrom]);

  List := tcpServer.Threads.LockList;
  try
    for Count := 0 to List.Count -1 do
    try
      TIdPeerThread(List.Items[Count]).Connection.WriteLn(Msg);
    except
      TIdPeerThread(List.Items[Count]).Stop;
    end;
  finally
    tcpServer.Threads.UnlockList;
  end;
end;

procedure TfrmMain.btnClientsClick(Sender: TObject);
begin
  UpdateClientList;
end;

procedure TfrmMain.btnPMClick(Sender: TObject);
var
  Msg : String;
  Client : TSimpleClient;
begin
  Msg := InputBox('Private Message', 'What is the message', '');
  Msg := Trim(Msg);
  Msg := edSyopName.Text + '> ' + Msg;
  if (Msg <> '') and
     (lbClients.ItemIndex <> -1) then
    begin
      Client := Clients.Items[lbClients.ItemIndex];
      TIdPeerThread(Client.Thread).Connection.WriteLn(Msg);
    end;
end;

procedure TfrmMain.btnKillClientClick(Sender: TObject);
var
  Msg : String;
  Client : TSimpleClient;
begin
  Msg := InputBox('Disconnect message', 'Enter a reason for the disconnect', '');
  Msg := Trim(Msg);
  Msg := edSyopName.Text + '> ' + Msg;
  if (Msg <> '') and
     (lbClients.ItemIndex <> -1) then
    begin
      Client := Clients.Items[lbClients.ItemIndex];
      TIdPeerThread(Client.Thread).Connection.WriteLn(Msg);
      TIdPeerThread(Client.Thread).Connection.Disconnect;
      Clients.Delete(lbClients.ItemIndex);
      lbClients.Items.Delete(lbClients.ItemIndex);
    end;
end;

procedure TfrmMain.lbClientsClick(Sender: TObject);
var
  Client : TSimpleClient;
begin
  btnPM.Enabled := lbClients.ItemIndex <> -1;
  btnKillClient.Enabled := btnPM.Enabled;
  
  if lbClients.ItemIndex = -1 then
    exit;
  Client := Clients.Items[lbClients.ItemIndex];
  lblClientName.Caption := Client.Name;
  lblClientDNS.Caption  := Client.DNS;
end;

end.
