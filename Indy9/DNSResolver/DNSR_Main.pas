{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  101135: DNSR_Main.pas 
{
{   Rev 1.1    25/10/2004 22:48:28  ANeillans    Version: 9.0.17
{ Verified
}
{
{   Rev 1.0    2004/6/25 ¤U¤È 05:59:28  DChang    Version: 1.0
{ First provide of simple DNS resolver.
{ If can be applied in any program which needs to resolve domain name.
}
{
  Demo Name:  DNS Resolver Demo

  Notes:
     IMPORTANT: Make sure you specify a DNS Server in Configuration

  Tested:
   Indy 9:
     D5:     Untested
     D6:     Untested
     D7:     25th Oct 2004 by Andy Neillans
}
unit DNSR_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPClient, IdDNSResolver;

const
     MyBreak = '========================';
     Code_Suspend = -2;
type
  TDNS_Main = class(TForm)
    MainMenu1: TMainMenu;
    S1: TMenuItem;
    MItem_Config: TMenuItem;
    N1: TMenuItem;
    MItem_Exit: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    Ed_Query: TEdit;
    Panel2: TPanel;
    Label2: TLabel;
    LB_QueryType: TListBox;
    Btn_Query: TButton;
    Panel3: TPanel;
    Label3: TLabel;
    Memo_Result: TMemo;
    About1: TMenuItem;
    About2: TMenuItem;
    procedure MItem_ConfigClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MItem_ExitClick(Sender: TObject);
    procedure Btn_QueryClick(Sender: TObject);
    procedure About2Click(Sender: TObject);
  private
    { Private declarations }
    FDNS_Server: String;
    procedure SetDNS_Server(const Value: String);
  public
    { Public declarations }
    property DNS_Server : String read FDNS_Server write SetDNS_Server;
    function DNS_Perform_Query(Question:string; var Value:string):integer;
  end;

var
  DNS_Main: TDNS_Main;

implementation

{$R *.DFM}

{ TDNS_Main }

procedure TDNS_Main.SetDNS_Server(const Value: String);
begin
  FDNS_Server := Value;
end;

procedure TDNS_Main.MItem_ConfigClick(Sender: TObject);
var
   Input_DNS : String;
begin
     Input_DNS := DNS_Server;
     if InputQuery('DNS Server IP address configuration', 'Please input an IP address of DNS Server', Input_DNS) then
        DNS_Server := Input_DNS;
end;

procedure TDNS_Main.FormCreate(Sender: TObject);
begin
     DNS_Server := '168.95.1.1';
     LB_QueryType.ItemIndex := 0;
end;

procedure TDNS_Main.MItem_ExitClick(Sender: TObject);
begin
     Application.Terminate;
end;

function TDNS_Main.DNS_Perform_Query(Question: string;
  var Value: string): integer;
var
   DNS : TIdDNSResolver;
   continue : word;
   Count : integer;

   function DecodeSecToTime(Secs : Cardinal) : string;
   var
      sec, min, hour, day, temp : Cardinal;
   begin
        sec := Secs mod 60;
        temp := (Secs -sec) div 60;
        min := temp mod 60;
        temp := (temp - min) div 60;
        hour := temp mod 24;
        day := (temp - hour) div 24;

        if (day > 0) then
           Result := IntToStr(day) + 'day';
        if (hour > 0) then
           Result := Result + IntToStr(hour) + 'hour';
        if (min > 0) then
           Result := Result + IntToStr(min) + 'min';
        if (sec > 0) then
           Result := Result + IntToStr(sec) + 'sec';
   end;

   function GetDetail(RR : TResultRecord) : string;
   begin
        if (RR is TARecord) then Result := 'IP address = ' + TARecord(RR).IPAddress +#13+#10;
        if (RR is TCNRecord) then Result := 'Name Server = '+ TCNRecord(RR).HostName +#13+#10;;
        if (RR is THINFORecord) then Result := 'CPU =' +THINFORecord(RR).CPU + '; OS= ' +THINFORecord(RR).OS + #13+#10;;
        if (RR is TMINFORecord) then Result := 'Responsible Email is: ' + TMINFORecord(RR).ResponsiblePersonMailbox + #13+#10;;
        if (RR is TMXRecord) then Result := 'Mail Server is: ' + TMXRecord(RR).ExchangeServer + #13+#10;;
        if (RR is TNAMERecord) then Result := 'Name Server = ' + TNAMERecord(RR).HostName + #13+#10;;
        if (RR is TNSRecord) then Result := 'Name Server = ' + TNSRecord(RR).HostName+#13+#10;
        if (RR is TPTRRecord) then Result := 'PTR = ' + TPTRRecord(RR).HostName +#13+#10;
        if (RR is TRDATARecord) then Result := 'IP address = ' + TRDATARecord(RR).IPAddress+#13+#10;
        if (RR is TSOARecord) then begin
           Result := 'Primary Domain Server = ' + TSOARecord(RR).Primary + #13+#10;
           Result := Result + 'ResponsiblePersion mail = ' + TSOARecord(RR).ResponsiblePerson + #13+#10;
           Result := Result + 'Serial = ' + IntToStr(TSOARecord(RR).Serial) + #13+#10;
           Result := Result + 'Refresh = ' + IntToSTr(TSOARecord(RR).Refresh) + ' ('+ DecodeSecToTime(TSOARecord(RR).Refresh)+')' + #13+#10;
           Result := Result + 'Retry = ' + IntToSTr(TSOARecord(RR).Retry) + ' (' +DecodeSecToTime(TSOARecord(RR).Retry) +')'+ #13+#10;
           Result := Result + 'Expire = ' + IntToSTr(TSOARecord(RR).Expire) + ' ('+ DecodeSecToTime(TSOARecord(RR).Expire) + ')' + #13+#10;
           Result := Result + 'default TTL = ' + IntToSTr(TSOARecord(RR).MinimumTTL) + ' (' +DecodeSecToTime(TSOARecord(RR).MinimumTTL)+')';
        end;

        if (RR is TTextRecord) then Result := TTextRecord(RR).Text.Text;
   end;
begin
     DNS := TIdDNSResolver.Create(self);
     // Assign the IP address of the DNS which you want to query
     //(NSLOOKUP Command: >server 168.95.1.1)
     DNS.Host := DNS_Server;

     // Assign query type (NSLOOKUP Command: >set querytype=A)
     //                   (NSLOOKUP Command: >set querytype=NS), etc
     DNS.QueryRecords := [];
     case LB_QueryType.ItemIndex of
          0: DNS.QueryRecords := [qtA];
          1: DNS.QueryRecords := [qtNS];
          2: DNS.QueryRecords := [qtName];
          3: DNS.QueryRecords := [qtSOA];
          4: DNS.QueryRecords := [qtHINFO];
          5: //DNS.QueryRecords := [qtTXT];
             begin
                  MessageDlg('Because many DNS does not provide RFC 1305 TXT record, we suspend this type!', mtWarning, [mbOK], 0);
                  Value := 'This function is suspeneded';
                  Result := Code_Suspend;
                  exit;
             end;
          6: DNS.QueryRecords := [qtMX];
          7:
            begin
                 continue := MessageDlg('Because many DNS does not provide MINFO, will you still query MINFO record??', mtConfirmation, [mbYes, mbNo], 0);
                 if ( continue = mrYes) then
                    DNS.QueryRecords := [qtMINFO]
                 else
                     begin
                          Value := 'This function is suspeneded';
                          Result := Code_Suspend;
                          exit;
                     end;
            end;
          8: DNS.QueryRecords := [qtMG];
          9: DNS.QueryRecords := [qtMR];
     end;

     try
        DNS.Active := True;
        DNS.Resolve(Question);
        Value := '';

        for count := 0 to DNS.QueryResult.Count-1 do begin
            Value := Value + GetDetail(DNS.QueryResult.Items[count]);
        end;

        Result := 0;
     except
           Value := 'Error';
           Result := -1;
           //DNS.Free;
     end;
end;

procedure TDNS_Main.Btn_QueryClick(Sender: TObject);
var
   Back, explain : string;
begin
     if (DNS_Perform_Query(Ed_Query.Text, Back) = 0 )then begin
             case LB_QueryType.ItemIndex of
                  0: //DNS.RequestedRecords := [cA];
                     explain := 'Query Result : IP address of '+Ed_Query.Text +' : ';
                  1: //DNS.RequestedRecords := [cNS];
                     explain := 'Query Result : Name Server(s) of '+Ed_Query.Text +' : ';
                  2: //DNS.RequestedRecords := [cName];
                     explain := 'Query Result : Alias(es) of '+Ed_Query.Text +' : ';
                  3: //DNS.RequestedRecords := [cSOA];
                     explain := 'Query Result : SOA of '+Ed_Query.Text +' :'+#13+#10;
                  4: //DNS.RequestedRecords := [cHINFO];
                     explain := 'Query Result : Host information of '+Ed_Query.Text +' : '+#13+#10;
                  5: //DNS.RequestedRecords := [cTXT];
                     explain := 'Query Result : TXT info of '+Ed_Query.Text +' : ';
                  6: //DNS.RequestedRecords := [cMX];
                     explain := 'Query Result : Mail exchange of '+Ed_Query.Text + ' : ';
                  7: //DNS.RequestedRecords := [cMINFO];
                     explain := 'Query Result : Mail server information of '+Ed_Query.Text +' : ';
                  8: //DNS.RequestedRecords := [cMG];
                     explain := 'Query Result : Mail group of '+Ed_Query.Text +' : ';
                  9: //DNS.RequestedRecords := [cMR];
                     explain := 'Query Result : Mail server alias of '+Ed_Query.Text +' : ';
             end;

             Memo_Result.Lines.Add(explain + Back);
             Memo_Result.Lines.Add(MyBreak);
        end
     else
         begin
              case LB_QueryType.ItemIndex of
                  0: //DNS.RequestedRecords := [cA];
                     explain := 'Some error happened while querying A Record of '+Ed_Query.Text;
                  1: //DNS.RequestedRecords := [cNS];
                     explain := 'Some error happened while querying NS Record of '+Ed_Query.Text;
                  2: //DNS.RequestedRecords := [cName];
                     explain := 'Some error happened while querying Alias Record of '+Ed_Query.Text;
                  3: //DNS.RequestedRecords := [cSOA];
                     explain := 'Some error happened while querying SOA Record of '+Ed_Query.Text;
                  4: //DNS.RequestedRecords := [cHINFO];
                     explain := 'Some error happened while querying HINFO Record of '+Ed_Query.Text;
                  5: //DNS.RequestedRecords := [cTXT];
                     explain := 'Some error happened while querying Text Record of '+Ed_Query.Text;
                  6: //DNS.RequestedRecords := [cMX];
                     explain := 'Some error happened while querying Mail Exchange Record of '+Ed_Query.Text;
                  7: //DNS.RequestedRecords := [cMINFO];
                     explain := 'Some error happened while querying Mail Info Record of '+Ed_Query.Text;
                  8: //DNS.RequestedRecords := [cMG];
                     explain := 'Some error happened while querying Mail group Record of '+Ed_Query.Text;
                  9: //DNS.RequestedRecords := [cMR];
                     explain := 'Some error happened while querying Mail Alias Record of '+Ed_Query.Text;
             end;

             Memo_Result.Lines.Add(MyBreak);
         end;
end;

procedure TDNS_Main.About2Click(Sender: TObject);
begin
   ShowMessage('If you have any question about this question, please mail to Indy-Demos@yahoogroups.com');
end;

end.
