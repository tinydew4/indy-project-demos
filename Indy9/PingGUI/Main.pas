{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  23313: Main.pas 
{
{   Rev 1.1    25/10/2004 22:49:18  ANeillans    Version: 9.0.17
{ Verified
}
{
{   Rev 1.0    12/09/2003 23:02:58  ANeillans
{ Initial Checkin.
{ Minor GUI Updates
{ Verified against Indy 9 and D7
}
{
  Demo Name:  Ping GUI
  Created By: Unknown
          On: Unknown

  Notes:
    Demonstrates using the ICMP client to generate PING stats.


  Version History:
   12th Sept 03: Andy Neillans
                 Added option for ping count.
                 Updated the Indy URL

  Tested:
   Indy 9:
     D5:     Untested
     D6:     Untested
     D7:     25th Oct 2004 by Andy Neillans
}
unit Main;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  SysUtils, Classes, IdIcmpClient, IdBaseComponent, IdComponent, IdRawBase, IdRawClient,
  Spin;


type
  TfrmPing = class(TForm)
    lstReplies: TListBox;
    ICMP: TIdIcmpClient;
    Panel1: TPanel;
    btnPing: TButton;
    edtHost: TEdit;
    spnPing: TSpinEdit;
    Label1: TLabel;
    procedure btnPingClick(Sender: TObject);
    procedure ICMPReply(ASender: TComponent; const ReplyStatus: TReplyStatus);
  private
  public
  end;

var
  frmPing: TfrmPing;

implementation
{$R *.DFM}

procedure TfrmPing.btnPingClick(Sender: TObject);
var
  i: integer;
begin
  ICMP.OnReply := ICMPReply;
  ICMP.ReceiveTimeout := 1000;
  btnPing.Enabled := False; try
    ICMP.Host := edtHost.Text;
    for i := 1 to spnPing.Value do begin
      ICMP.Ping;
      Application.ProcessMessages;
    end;
  finally btnPing.Enabled := True; end;
end;

procedure TfrmPing.ICMPReply(ASender: TComponent; const ReplyStatus: TReplyStatus);
var
  sTime: string;
begin
  // TODO: check for error on ping reply (ReplyStatus.MsgType?)
  if (ReplyStatus.MsRoundTripTime = 0) then
    sTime := '<1'
  else
    sTime := '=';

  lstReplies.Items.Add(Format('%d bytes from %s: icmp_seq=%d ttl=%d time%s%d ms',
    [ReplyStatus.BytesReceived,
    ReplyStatus.FromIpAddress,
    ReplyStatus.SequenceId,
    ReplyStatus.TimeToLive,
    sTime,
    ReplyStatus.MsRoundTripTime]));
end;

end.
