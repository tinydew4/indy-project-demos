unit Unit_INDY10_server;
{ *******************************************************************************
  *
  *
  *
  *    #      #     #     # ####     #     #      #     #######
  *    #      ##    #     #     #     #   #       #     #     #
  *    #      # #   #     #     #      # #        #     #     #
  *    #      #  #  #     #     #       #         #     #     #
  *    #      #   # #     #    #        #         #     #     #
  *    #      #    ##     #####         #         #     #######
  *
  *
  *    a bit more comnplex trail application of INDY 10 tcp client server components
  *
  *
  *
  *  a evaluation project of the indy 10 components , completly free code
  *  no support, no help, use on your own risk,  no warrenty ...
  *  see the client file for more remarks
  *
  *  by   BDLM
  *
  *  there  are  4 little features implemented
  *
  *  TEST # 0
  *                        send a string to the server
  *  TEST # 1
  *                        send comand "Time"  form client  to server
  *                        server as to send back local server time
  *  TEST # 2
  *                        client send record(Type A) to server
  *                        Server send back record (Type B)
  *  TEST #3
  *                        client send Record(Type A) to server
  *                        no server response
  *  TEST # 4
  *                        send a file from the server to the client
  *
  *
  * ****************************************************************************
  *
  *  18.03.2011            install svn on source forge
  *  08.02.2012
  ******************************************************************************* }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdContext, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdTCPServer, IdCmdTCPServer, IdSync, StdCtrls, IDGlobal, IdStack,
  IDSocketHandle,
  IdStream,
  ComCtrls, CheckLst, IdIPWatch, ExtCtrls, Vcl.Menus,

  Unit_Indy_Functions, Unit_Indy_Classes;

type

  TServerMainForm = class(TForm)
    IdTCPServer: TIdTCPServer;
    MainStatusBar: TStatusBar;
    IdIPWatch: TIdIPWatch;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    About1: TMenuItem;
    Build1: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    IPEdit: TEdit;
    Label2: TLabel;
    PortEdit: TEdit;
    ServerBindingsButton: TButton;
    IPListCheckListBox: TCheckListBox;
    ServerActiveCheckBox: TCheckBox;
    LEDShape: TShape;
    Panel2: TPanel;
    SendTextEdit: TEdit;
    Memo1: TMemo;
    Label3: TLabel;
    Splitter1: TSplitter;
    Label4: TLabel;
    ServerImage: TImage;
    procedure ServerBindingsButtonClick(Sender: TObject);
    procedure ServerActiveCheckBoxClick(Sender: TObject);
    procedure IdCmdTCPServerException(AContext: TIdContext;
      AException: Exception);
    procedure IdTCPServerConnect(AContext: TIdContext);
    procedure IdTCPServerDisconnect(AContext: TIdContext);
    procedure IdTCPServerException(AContext: TIdContext; AException: Exception);

    /// <summary>
    /// <para>
    /// excute one out of the 4 communications flows
    /// </para>
    /// <para>
    /// ExchangeStrings
    /// </para>
    /// <para>
    /// ExchangeRecords (simple and complex version)
    /// </para>
    /// <para>
    /// Send a File !
    /// </para>
    /// </summary>
    procedure IdTCPServerExecute(AContext: TIdContext);

    /// <summary>
    /// <para>
    /// onCreate
    /// </para>
    /// <para>
    /// find all valid IP#s
    /// </para>
    /// </summary>
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Build1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private

    procedure PopolateIPLIstButtonClick(Sender: TObject);

    procedure RecordReceived_TMyRecord;
    procedure RecordReceived_TINDY_CMD;
    procedure ShowCannotGetDataErrorMessage;
    procedure ShowCannotSendDataErrorMessage;
    procedure ShowDataReceivedMessage;
    procedure DrawRandomBitMap(aBitMap: TBitMap);
    procedure ShowCannotSendStreamDataErrorMessage;
    procedure ShowDataSendMessage;
    procedure ShowStartServerdMessage;
    procedure StopStartServerdMessage;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }



    aMyRecord_TS: TMyRECORDThreadSafeRecord;
    AIndyRecord_TS: TINDYCMDThreadSafeRecord;

  end;

var
  ServerMainForm: TServerMainForm;

implementation

{$R *.dfm}

uses Unit_DelphiCompilerversionDLG;

///
/// create a random color value ...
///
function RandomColor: TColor;
begin
  Result := RGB(Random(256), Random(256), Random(256));
end;

///
/// Create main form
///
procedure TServerMainForm.Build1Click(Sender: TObject);
begin
  OKRightDlgDelphi.Show;
end;

procedure TServerMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TServerMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  AIndyRecord_TS.Free;
  aMyRecord_TS.Free;
end;

procedure TServerMainForm.FormCreate(Sender: TObject);
begin
  PopolateIPLIstButtonClick(Sender);

  /// very simple record to send to the server

  /// a bit more complex record exchange
  ///
  ///



  AIndyRecord_TS := TINDYCMDThreadSafeRecord.Create;   // NEW THREAD SAVE RECORDE.. IF I NEED VCL ACCESS !!!
  aMyRecord_TS := TMyRECORDThreadSafeRecord.CReate;

end;

///
/// ...
///
procedure TServerMainForm.IdCmdTCPServerException(AContext: TIdContext;
  AException: Exception);
begin

end;

///
/// ...
///
procedure TServerMainForm.IdTCPServerConnect(AContext: TIdContext);
begin
  Memo1.Lines.Add('Connection from ..PeerIP/IP' + AContext.Binding.PeerIP +
    '  // ' + AContext.Binding.IP + '  @ ' + dateToStr(now) + '->' +
    TimeToStr(now));

  AContext.Connection.IOHandler.WriteLn('Greeting from the tcp server demo ');

end;

///
/// ...
///
procedure TServerMainForm.IdTCPServerDisconnect(AContext: TIdContext);
begin

  Memo1.Lines.Add('DisConnect from ..PeerIP/IP' + AContext.Binding.PeerIP +
    '  // ' + AContext.Binding.IP + '  @ ' + dateToStr(now) + '->' +
    TimeToStr(now));

end;

procedure TServerMainForm.IdTCPServerExecute(AContext: TIdContext);
var
  LBuffer: TBytes;

  LSize: LongInt;

  CMD_CLASS: Integer;
  line: String;

  aMs: TMemoryStream;

  aINDYCMD: TGenericRecord<TINDYCMD>;
  aMyRecord: TGenericRecord<TMyRecord>;
  abmp  : TBitMap;

begin
   TIdNotify.NotifyMethod( ShowStartServerdMessage );

  aINDYCMD := TGenericRecord<TINDYCMD>.Create;
  aMyRecord := TGenericRecord<TMyRecord>.Create;

  AContext.Connection.IOHandler.ReadTimeout := 90000;

  // 'server execute start'

  if (ReceiveBuffer(AContext, LBuffer) = False) then
  begin
    TIdNotify.NotifyMethod(ShowCannotGetDataErrorMessage);
    Exit;
  end
  else
  begin
    TIdNotify.NotifyMethod(ShowDataReceivedMessage);

    aINDYCMD.value := aINDYCMD.ByteArrayToMyRecord(LBuffer);

    AIndyRecord_TS.lock;

    AIndyRecord_TS.value := aINDYCMD.value;

    AIndyRecord_TS.unlock;


    TIdNotify.NotifyMethod(RecordReceived_TINDY_CMD);




  end;

  aINDYCMD.value := aINDYCMD.ByteArrayToMyRecord(LBuffer);


  CMD_CLASS := aINDYCMD.value.CMD_CLASS;

  // MainStatusBar.SimpleText := ' CMD_CLASS -> ' +  INtToStr(aINDYCMD.value.CMD_CLASS);

  case CMD_CLASS of
    0:
      begin
        /// receive a simple string from client
        line := AContext.Connection.IOHandler.ReadLn();
        // Memo1.Lines.Add('');
        // Memo1.Lines.Add('CLIENT STRING -> ' + line);
        // Memo1.Lines.Add('');
      end;

    1:
      begin
        ///
        // Memo1.Lines.Add('');
        // Memo1.Lines.Add('SEND RECORD BACK TO CLIENT#1');
        // Memo1.Lines.Add('');

        AIndyRecord_TS.lock;
        AIndyRecord_TS.value.CMD_TIMESTAMP := now;
        AIndyRecord_TS.value.CMD_VALUE := ' TEST SEND BACK SERVER TIME -> ' +
          dateToStr(now) + '/' + TimeToStr(now);
        AIndyRecord_TS.value.CMD_CLASS := 100;
        aINDYCMD.value := AIndyRecord_TS.value;
        AIndyRecord_TS.unlock;

        LBuffer := aINDYCMD.MyRecordToByteArray(aINDYCMD.value);

        if (NOT SendBuffer(AContext, LBuffer)) then
        begin
          TIdNotify.NotifyMethod(ShowCannotSendDataErrorMessage);
        end
        else
        begin
          TIdNotify.NotifyMethod(ShowDataSendMessage);

    TIdNotify.NotifyMethod(RecordReceived_TINDY_CMD);
        end;
      end;
    2:
      begin
        // Memo1.Lines.Add('');
        // Memo1.Lines.Add('SEND RECORD BACK TO CLIENT#2');
        // Memo1.Lines.Add('');
        aMyRecord_TS.value.Details := ' complex server response ......';
        aMyRecord_TS.value.FileName := 'TEXT TEST TEXT TEST';
        aMyRecord_TS.value.FileDate := now;
        aMyRecord_TS.value.Recordsize := Random(300);
        aMyRecord_TS.value.FileSize := 1234567890;

        aMyRecord.value := aMyRecord.value;

        LBuffer := aMyRecord.MyRecordToByteArray(aMyRecord.value);

        if (SendBuffer(AContext, LBuffer) = False) then
        begin
          TIdNotify.NotifyMethod(ShowCannotSendDataErrorMessage);
        end
        else
        begin
          TIdNotify.NotifyMethod(ShowDataSendMessage);
           TIdNotify.NotifyMethod(RecordReceived_TMyRecord);
        end;

      end;

    3:
      begin
        ///
        // Memo1.Lines.Add('record received, paint random record !');

         abmp := TBitMap.Create;

        abmp.Height := 300;
        abmp.Width := 300;

        DrawRandomBitMap(abmp);

        ServerImage.Picture.Bitmap.Assign(abmp);

        abmp.free;

      end;
    4:
      begin
        ///
        // Memo1.Lines.Add('send stream back !');
        ///
        abmp := TBitMap.Create;
        aMs := TMemoryStream.Create;
        abmp.SaveToStream(aMs);

        if (SendStream(AContext, TStream(aMs)) = False) then
        begin
          TIdNotify.NotifyMethod(ShowCannotSendStreamDataErrorMessage);
          Exit;
        end;

        aMs.Free;

      end;

  else
    //
  end;


  AContext.Connection.IOHandler.WriteBufferClear;


  LEDShape.brush.Color := clgreen;


  // Memo1.Lines.Add('server execute done');

  aINDYCMD.Free;
  aMyRecord.Free;

  TIdNotify.NotifyMethod( StopStartServerdMessage );

end;

procedure TServerMainForm.DrawRandomBitMap(aBitMap: TBitMap);
var
  i, j: Integer;
  rx1, rx2: Integer;
  ry1, ry2: Integer;
  w, h: Integer;

begin
  w := aBitMap.Width;
  h := aBitMap.Height;

//  abmp.Canvas.FloodFill(0, 0, clwhite, fsSurface);

  for i := 1 to 30 do
  begin

    randomize;

    rx1 := Random(w - 1);
    rx2 := Random(w - 1);

    ry1 := Random(h - 1);
    ry2 := Random(h - 1);

    aBitMap.Canvas.Pen.Color := RandomColor;

    aBitMap.Canvas.MoveTo(rx1, ry1);

    aBitMap.Canvas.LineTo(rx2, ry2);

  end;

end;

procedure TServerMainForm.RecordReceived_TINDY_CMD;
begin
  AIndyRecord_TS.Lock;
  Memo1.Lines.Add('------------------< RECORD VALUES >-------------');
  Memo1.Lines.Add(' CMD_Value -> ' + AIndyRecord_TS.value.CMD_VALUE);
  Memo1.Lines.Add(' CMD_CLASS -> ' + INtToStr(AIndyRecord_TS.value.CMD_CLASS));
  Memo1.Lines.Add(' CMD_CLASS -> ' +
    dateToStr(AIndyRecord_TS.value.CMD_TIMESTAMP));
  Memo1.Lines.Add('--------------------< END >----------------------') ;
  AIndyRecord_TS.Unlock;
end;

procedure TServerMainForm.RecordReceived_TMyRecord;
begin
  aMyRecord_TS.Lock;
  Memo1.Lines.Add('--------------------< RECORD VALUES >----------------');
   Memo1.Lines.Add('Details ' + aMyRecord_TS.value.Details);
   Memo1.Lines.Add('FileName = ' + aMyRecord_TS.value.FileName);
   Memo1.Lines.Add('FileSize = ' + INtToStr(aMyRecord_TS.value.FileSize));
   Memo1.Lines.Add('RecordSize = ' + INtToStr(aMyRecord_TS.value.Recordsize));
  Memo1.Lines.Add('--------------------< END >------------------------');
  aMyRecord_TS.Unlock;
end;

///
/// ...
///
procedure TServerMainForm.ServerActiveCheckBoxClick(Sender: TObject);
begin
  IdTCPServer.Active := ServerActiveCheckBox.Checked;

  if IdTCPServer.Active then
    LEDShape.brush.Color := clgreen
  else
    LEDShape.brush.Color := clred;

end;

///
/// not yet implemented  ....
///
procedure TServerMainForm.ServerBindingsButtonClick(Sender: TObject);
var
  SocketHandle: TIDSocketHandles;
begin

  // binding set to 127.0.0.1   ::  50000

  IdTCPServer.Active := False;

  IdTCPServer.Bindings.Add.IPVersion := Id_IPv4;
  // else, throw socket error # 98 , address already in use ...
  IdTCPServer.Bindings.Add.IP := IPEdit.text; // '127.0.0.1';
  IdTCPServer.Bindings.Add.Port := StrToInt(PortEdit.text); // 5000;

  // customization
  ServerActiveCheckBox.Checked := true;
  IdTCPServer.Active := ServerActiveCheckBox.Checked;

  //
  MainStatusBar.SimpleText := 'server running on port ' + PortEdit.text +
    ' host ip ->' + IPEdit.text;

end;

///
/// get all available IP's
///
procedure TServerMainForm.PopolateIPLIstButtonClick(Sender: TObject);
var
  MYIdStack: TIdStack;
begin

  /// methode #1  , working with INDY IDIPWatch
  IdIPWatch.Active := true;
  MainStatusBar.SimpleText := IdIPWatch.LocalIP + '...' + IdIPWatch.CurrentIP;

  /// meathode #2 , see ....

  with IPListCheckListBox do
  begin
    Clear;
    Items := GStack.LocalAddresses;
    If IPListCheckListBox.Items.Strings[0] <> '127.0.0.1' then
      Items.Insert(0, '127.0.0.1');

    Checked[0] := true;

  end;

end;



procedure TServerMainForm.ShowStartServerdMessage;
begin
  Memo1.Lines.Add('START SERVER  @' + TimeToStr(now));
end;

procedure TServerMainForm.StopStartServerdMessage;
begin
  Memo1.Lines.Add('STOP SERVER  @' + TimeToStr(now));
end;

procedure TServerMainForm.ShowDataReceivedMessage;
begin
  Memo1.Lines.Add('Data received @' + TimeToStr(now));
end;

procedure TServerMainForm.ShowDataSendMessage;
begin
  Memo1.Lines.Add('Data send @' + TimeToStr(now));
end;

procedure TServerMainForm.ShowCannotGetDataErrorMessage;
begin
  Memo1.Lines.Add('Cannot get data from client, Unknown error occured @' +
    TimeToStr(now));
end;

procedure TServerMainForm.ShowCannotSendDataErrorMessage;
begin
  Memo1.Lines.Add('Cannot send data to client, Unknown error occured @' +
    TimeToStr(now));
end;

procedure TServerMainForm.ShowCannotSendStreamDataErrorMessage;
begin
  Memo1.Lines.Add('Cannot send STREAM data to client, Unknown error occured @' +
    TimeToStr(now));
end;

procedure TServerMainForm.IdTCPServerException(AContext: TIdContext;
  AException: Exception);
begin
  with AContext.Connection.IOHandler do
  begin
    writeln('server.exception  @' + TimeToStr(now));
  end;
end;

end.
