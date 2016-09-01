{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110690: mainform.pas 
{
{   Rev 1.0    25/10/2004 23:31:16  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: main
 Author:    <unknown - please contact me to take credit! - Allen O'Neill>
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------
 Notes:

 Demonstrates use of a basic finger server

Verified:
  Indy 9:
    D7: 25th Oct 2004 Andy Neillans
}



unit mainform;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls,
  SysUtils, Classes, IdComponent, IdTCPServer, IdFingerServer,
  IdBaseComponent;

type
  TfrmFingerServer = class(TForm)
    IdFingerServer1: TIdFingerServer;
    Label1: TLabel;
    lblStatus: TLabel;
    Button1: TButton;
    procedure IdFingerServer1CommandFinger(AThread: TIdPeerThread;
      const AUserName: String);
    procedure IdFingerServer1CommandVerboseFinger(AThread: TIdPeerThread;
      const AUserName: String);
    procedure IdFingerServer1Connect(AThread: TIdPeerThread);
    procedure IdFingerServer1Disconnect(AThread: TIdPeerThread);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  frmFingerServer: TfrmFingerServer;

implementation
{$R *.DFM}

uses
  IdGlobal;

{These are our sample users}

Const SampleUsers : Array [1..3] of String =
  ('TIDFINGER', 'TIDQUOTD', 'TIDTIME');

procedure TfrmFingerServer.IdFingerServer1CommandFinger(AThread: TIdPeerThread;
  const AUserName: String);

begin
  {general querry - just list users}
  if AUserName = '' then
  begin
    AThread.Connection.WriteLn('TIdFinger');
    AThread.Connection.WriteLn('TIdQuotD');
    AThread.Connection.WriteLn('TIdTime');
  end //if AUserName = '' then
  else
  begin {Just Provide brief information}
    Case Succ ( PosInStrArray ( Uppercase ( AUserName ), SampleUsers ) ) of
      1 : //TIdFinger
          begin
            AThread.Connection.WriteLn('TIdFinger implements RFC 1288');
          end; {1}
      2 : //TIdQuotD
          begin
            AThread.Connection.WriteLn('TIdQuotD implements RFC 865');
          end; {2}
      3 : //TIdTime
          begin
            AThread.Connection.WriteLn('TIdTime implements RFC 868');
          end; {3}
      else
      begin  {This user is not on our system}
        AThread.Connection.WriteLn( AUserName + '?' );
      end; //else..case
    end; //Case Succ ( PosInStrArray ( Uppercase ( AUserName ), SampleUsers ) ) of
  end; //if AUserName = '' then
end;

procedure TfrmFingerServer.IdFingerServer1CommandVerboseFinger(
  AThread: TIdPeerThread; const AUserName: String);
begin
  AThread.Connection.WriteLn('Verbose query');
   {general querry - just list users}
  if AUserName = '' then
  begin
    AThread.Connection.WriteLn('TIdFinger');
    AThread.Connection.WriteLn('TIdQuotD');
    AThread.Connection.WriteLn('TIdTime');
  end //if AUserName = '' then
  else
  begin {Just Provide brief information}
    Case Succ ( PosInStrArray ( Uppercase ( AUserName ), SampleUsers ) ) of
      1 : //TIdFinger
          begin
            AThread.Connection.WriteLn('TIdFinger implements RFC 1288');
            AThread.Connection.WriteLn('');
            AThread.Connection.WriteLn('Finger is used to provide information');
            AThread.Connection.WriteLn('such as if the user is logged into a');
            AThread.Connection.WriteLn('mainframe, when they last checked their');
            AThread.Connection.WriteLn('E-Mail and received new E-Mail.  It');
            AThread.Connection.WriteLn('can also provide other information such');
            AThread.Connection.WriteLn('what a user puts into a plan file.');
          end; {1}
      2 : //TIdQuotD
          begin
            AThread.Connection.WriteLn('TIdQuotD implements RFC 865');
            AThread.Connection.WriteLn('');
            AThread.Connection.WriteLn('Quote of the Day is used for testing');
            AThread.Connection.WriteLn('TCP development by providing a quote.');
            AThread.Connection.WriteLn('to the client.  It is sometimes used');
            AThread.Connection.WriteLn('brief information for anybody.');
          end; {2}
      3 : //TIdTime
          begin
            AThread.Connection.WriteLn('TIdTime implements RFC 868');
            AThread.Connection.WriteLn('');
            AThread.Connection.WriteLn('Time is used for synchronizing clocks');
            AThread.Connection.WriteLn('on a local area network.  For accurate');
            AThread.Connection.WriteLn('synchronization, use SNTP (Simple');
            AThread.Connection.WriteLn('Network Time Protocol).');

          end; {3}
      else
      begin  {This user is not on our system}
        AThread.Connection.WriteLn( AUserName + '?' );
      end; //else..case
    end; //Case Succ ( PosInStrArray ( Uppercase ( AUserName ), SampleUsers ) ) of
  end; //if AUserName = '' then
end;

procedure TfrmFingerServer.IdFingerServer1Connect(AThread: TIdPeerThread);
begin
lblStatus.caption := '[ connected to client ]';
end;

procedure TfrmFingerServer.IdFingerServer1Disconnect(
  AThread: TIdPeerThread);
begin
lblStatus.caption := '[ idle ]';
end;

procedure TfrmFingerServer.FormActivate(Sender: TObject);
begin
  try
    IdFingerServer1.Active := True;
  except
  on E : Exception do
    ShowMessage('Cannot bind socket - is port already in use?');
  end;
end;


procedure TfrmFingerServer.Button1Click(Sender: TObject);
begin
 Close;
end;

end.
