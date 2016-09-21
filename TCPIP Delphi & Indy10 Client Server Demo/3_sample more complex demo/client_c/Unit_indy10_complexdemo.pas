unit Unit_indy10_complexdemo;

{ *******************************************************************************
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
  *
  *     rev01 :   non functional code with many bugs  ( 10.11.2011 )
  *               compile with Delphi 2010 , Delphi XE 2
  *               connect and disconnect to the server is working,
  *               next step :  get exchange of TRecord Command's working
  *
  *    (C)        free ware  under Gnu Public licenz , no support, no help,
  *               no warrenty or what ever, just use on your own risk and fun !!!
  *
  *
  *  there  are  4 little features implemented
  *
  *
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
  *
  * ****************************************************************************
  *
  *  version 2012
  ******************************************************************************* }
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdContext, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdCmdTCPClient, ComCtrls, CheckLst, IDStack, IdGlobal, IdIPWatch,
  IDSync, IDStream,
  // IdObjs,       no need anymore
  // IdSys ,       no need anymore
  Unit_Indy_Classes, Unit_Indy_Functions, ExtCtrls, Vcl.Menus;

type

  TIndyClientMainForm = class(TForm)
    IdIPWatch: TIdIPWatch;
    MainStatusBar: TStatusBar;
    MyIdTCPClient: TIdTCPClient;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    About1: TMenuItem;
    BUILDINFO1: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    IPListCheckListBox: TCheckListBox;
    Label2: TLabel;
    PortEdit: TEdit;
    SetComunicationParameterButton: TButton;
    ClientActiveCheckBox: TCheckBox;
    LEDShape: TShape;
    Panel2: TPanel;
    ClientExecuteButton: TButton;
    CommandComboBox: TComboBox;
    SendTextEdit: TEdit;
    Memo1: TMemo;
    Splitter1: TSplitter;
    ClientImage: TImage;
    Label3: TLabel;

    procedure SetComunicationParameterButtonClick(Sender: TObject);
    procedure MyIdTCPClientConnected(Sender: TObject);
    procedure ClientExecuteButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClientActiveCheckBoxClick(Sender: TObject);
    procedure IPListCheckListBoxClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure BUILDINFO1Click(Sender: TObject);
  private
    procedure PopolateIPLIstButtonClick(Sender: TObject);
    procedure ShowCMDRecord(Info: String; aComBlock: TINDYCMD);
    procedure MakeINDYCommand(var aINDYCMD: TINDYCMD; aCMDINDEX: Integer);
    procedure SetClientConnected(aState: Boolean);
    procedure ShowDataRecord(Info: String; aDataRecord: TMyRecord);
    procedure MakeMyRecord(var aRecord: TMyRecord);
    procedure ShowCannotGetDataErrorMessage;
    procedure ShowCannotSendDataErrorMessage;
    procedure ShowCannotSendStreamDataErrorMessage;
    procedure ShowDataReceivedMessage;
    procedure ShowDataSendMessage;

    { Private-Deklarationen }
  public
    { Public-Deklarationen }

    SelectedIPItemIndex: Integer;
    SelectedIPItem: String;

    procedure ClientTRecordExchange(var CommBlock, NewCommBlock: TINDYCMD);
  end;

var
  IndyClientMainForm: TIndyClientMainForm;

implementation

{$R *.dfm}

uses Unit_DelphiCompilerversionDLG;

/// just connect and read the server greetings, functional code sample
procedure TIndyClientMainForm.BUILDINFO1Click(Sender: TObject);
begin
  OKRightDlgDelphi.Show;
end;

procedure TIndyClientMainForm.SetClientConnected(aState: Boolean);
begin
  Memo1.Lines.Add('INITIAL CLIENT STATE ' + BoolToStr(MyIdTCPClient.Connected));
  try
    if aState = true then
    begin
      MyIdTCPClient.Connect;
      Memo1.Lines.Add('connect to server .... ');
      LEDShape.brush.Color := clgreen;
    end
    else
    begin
      MyIdTCPClient.IOHandler.InputBuffer.clear;
      MyIdTCPClient.Disconnect;
      Memo1.Lines.Add('disconnect from server');

      LEDShape.brush.Color := Clyellow;
    end;

  except
    Memo1.Lines.Add('error connect/disconnect to server .... ');
    LEDShape.brush.Color := Clred;
  end;

  Memo1.Lines.Add('FINAL CLIENT STATE ' + BoolToStr(MyIdTCPClient.Connected));
end;

procedure TIndyClientMainForm.ClientActiveCheckBoxClick(Sender: TObject);
begin
  if ClientActiveCheckBox.Checked then
  begin
    SetClientConnected(true);
  end
  else
  begin
    SetClientConnected(false);
  end;
end;

/// show that simple record
procedure TIndyClientMainForm.ShowCMDRecord(Info: String; aComBlock: TINDYCMD);
begin
  Memo1.Lines.Add('-----------    COMMAND RECORD DUMP --------------');
  Memo1.Lines.Add('Info  -> ' + Info);
  Memo1.Lines.Add('Class -> ' + IntToStr(aComBlock.CMD_CLASS));
  Memo1.Lines.Add('Value -> ' + aComBlock.CMD_VALUE);
  Memo1.Lines.Add('Date  -> ' + DateToStr(aComBlock.CMD_TIMESTAMP));
  Memo1.Lines.Add('TIME  -> ' + TimeToStr(aComBlock.CMD_TIMESTAMP));

end;

/// show that simple record
procedure TIndyClientMainForm.ShowDataRecord(Info: String;
  aDataRecord: TMyRecord);
begin
  Memo1.Lines.Add('-----------    COMMAND RECORD DUMP --------------');
  Memo1.Lines.Add('Info  -> ' + Info);
  Memo1.Lines.Add('Details -> ' + aDataRecord.Details);
  Memo1.Lines.Add('Filename -> ' + aDataRecord.FileName);
  Memo1.Lines.Add('Filesize  -> ' + IntToStr(aDataRecord.FileSize));
  Memo1.Lines.Add('Date  -> ' + DateToStr(aDataRecord.FileDate));
  Memo1.Lines.Add('TIME  -> ' + TimeToStr(aDataRecord.FileDate));

end;

procedure TIndyClientMainForm.MakeMyRecord(var aRecord: TMyRecord);
begin

  aRecord.Details := 'data values fromn client';
  aRecord.FileDate := now;
  aRecord.FileName := 'any txt here - TEST TEST ';
  aRecord.Recordsize := random(10) - 5;
  aRecord.FileSize := random(100000);

end;

procedure TIndyClientMainForm.MakeINDYCommand(var aINDYCMD: TINDYCMD;
  aCMDINDEX: Integer);
begin

  aINDYCMD.CMD_TIMESTAMP := now;

  case aCMDINDEX of

    0:
      begin
        ///
        aINDYCMD.CMD_CLASS := 0;
        aINDYCMD.CMD_VALUE := 'GETSTRING';
      end;
    1:
      begin
        ///
        aINDYCMD.CMD_CLASS := 1;
        aINDYCMD.CMD_VALUE := 'GETSERVERDATETIME';
      end;
    2:
      begin
        ///
        aINDYCMD.CMD_CLASS := 2;
        aINDYCMD.CMD_VALUE := 'SENDANDGETRECORD';
      end;
    3:
      begin
        ///
        aINDYCMD.CMD_CLASS := 3;
        aINDYCMD.CMD_VALUE := 'SENDRECORD';
      end;
    4:
      begin
        ///
        aINDYCMD.CMD_CLASS := 4;
        aINDYCMD.CMD_VALUE := 'GETFILE';
      end
  else

  end;

end;

/// selct a command from a CMD List box, today only trial code
procedure TIndyClientMainForm.ClientExecuteButtonClick(Sender: TObject);
var
  aINDYCMD: TGenericRecord<TINDYCMD>;
  aINDYCMD_temp: TINDYCMD;
  aMyRecord: TGenericRecord<TMyRecord>;
  aMyRecord_temp: TMyRecord;
  CmdIndex: Integer;
  line: String;
  LBuffer: TBytes;

  aMemStream: TMemoryStream;
begin


  /// very simple record type to send to the server

  aINDYCMD := TGenericRecord<TINDYCMD>.Create;

  aMyRecord := TGenericRecord<TMyRecord>.Create;


  CmdIndex := CommandComboBox.ItemIndex;

  // Memo1.Lines.Add('start client execute : ' + IntToStr(CmdIndex));

  MakeINDYCommand(aINDYCMD_temp, CmdIndex);
  aINDYCMD.Value := aINDYCMD_temp;

  MakeMyRecord(aMyRecord_temp);
  aMyRecord.Value := aMyRecord_temp;

  /// start   communication client server .....

  LBuffer := aINDYCMD.MyRecordToByteArray(aINDYCMD.Value);
  if (SendBuffer(MyIdTCPClient, LBuffer) = false) then
  begin
     TIdNotify.NotifyMethod(ShowCannotSendDataErrorMessage);
  end
  else
  begin
     TIdNotify.NotifyMethod(ShowDataSendMessage);
  end;

  case CmdIndex of
    0:
      /// send a string tp the server
      begin
        ///  'send text  ;
        MyIdTCPClient.IOHandler.WriteLn(SendTextEdit.Text);
        TIdNotify.NotifyMethod(ShowDataSendMessage);
      end;
    1:
      /// send INDY CMD and get INDY CMD from the server
      begin

        ///
        ///
        if ( NOT ReceiveBuffer(MyIdTCPClient, LBuffer)) then
        begin
              // 'Cannot receive record/buffer from server.'
              TIdNotify.NotifyMethod(ShowCannotGetDataErrorMessage);
        end
        else
        begin
          aINDYCMD.Value := aINDYCMD.ByteArrayToMyRecord(LBuffer);
          //  ShowCMDRecord('ServerResponse', aINDYCMD.Value);
           TIdNotify.NotifyMethod(ShowDataReceivedMessage);
        end;
      end;
    2:
      /// send INDY RECORD GET CLIENTSVR RECORD from server
      begin
        ///
        ///
        if (NOT ReceiveBuffer(MyIdTCPClient, LBuffer)) then
        begin
         // 'Cannot receive record/buffer from server.'
          TIdNotify.NotifyMethod(ShowCannotGetDataErrorMessage);
        end
        else
        begin
          aMyRecord.Value := aMyRecord.ByteArrayToMyRecord(LBuffer);
           TIdNotify.NotifyMethod(ShowDataReceivedMessage);
          // ShowDataRecord('ServerResponse', aMyRecord.Value);
        end;
      end;

    3:

      begin
        /// do nothing !!!!!!!
      end;
    4:
      /// get a file from the server
      begin
        /// *   todo  !!!!
        ///
        ///
        ///
        aMemStream := TMemoryStream.Create;

        if (ReceiveStream(MyIdTCPClient, TStream(aMemStream)) = false) then
        begin
          Memo1.Lines.Add
            ('Cannot get STREAM from server, Unknown error occured');
          Exit;
        end;

        ClientImage.Picture.Bitmap.LoadFromStream(TStream(aMemStream));

        aMemStream.Free;

      end
  else
    ///
  end;

  aINDYCMD.Free;

  aMyRecord.Free;



end;

/// send a record to the server and read back the result record
procedure TIndyClientMainForm.ClientTRecordExchange(var CommBlock,
  NewCommBlock: TINDYCMD);

begin

end;

procedure TIndyClientMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

/// store the selected ID into a global var
procedure TIndyClientMainForm.FormCreate(Sender: TObject);
begin

  ///
  PopolateIPLIstButtonClick(nil);

  /// GUI
  MainStatusBar.SimpleText := ' INDY 10  typ client demo  Version 10.04.2012';

  ///
  /// OK, set the default IP  already at form create
  ///
  IPListCheckListBoxClick(Sender);

  SetComunicationParameterButtonClick(Sender);
end;

/// select othe IP adress....
procedure TIndyClientMainForm.IPListCheckListBoxClick(Sender: TObject);
var
  i: Integer;
begin

  SelectedIPItemIndex := -1;

  i := -1;
  repeat

    inc(i);

    if IPListCheckListBox.Checked[i] then
    begin

      SelectedIPItemIndex := i;

      SelectedIPItem := IPListCheckListBox.Items[i];

    end;

  until i >= IPListCheckListBox.Items.Count - 1;

  MainStatusBar.SimpleText := 'selected IP : ' + SelectedIPItem;

end;

///
procedure TIndyClientMainForm.MyIdTCPClientConnected(Sender: TObject);
begin
  Memo1.Lines.Add('Connected  ...');
end;

/// need tp press this button before using TCPClient
procedure TIndyClientMainForm.SetComunicationParameterButtonClick
  (Sender: TObject);
begin

  MyIdTCPClient.Host := SelectedIPItem;

  MyIdTCPClient.Port := StrToInt(PortEdit.Text);

  MainStatusBar.SimpleText := 'running client at  IP : ' + SelectedIPItem +
    '  port: ' + PortEdit.Text;
end;

/// get all available IP's
procedure TIndyClientMainForm.PopolateIPLIstButtonClick(Sender: TObject);
var
  MYIdStack: TIdStack;
begin

  /// methode #1  , working with INDY IDIPWatch
  IdIPWatch.Active := true;
  MainStatusBar.SimpleText := IdIPWatch.LocalIP + '...' + IdIPWatch.CurrentIP;

  /// methode #2 , see ....

  with IPListCheckListBox do
  begin
    clear;
    Items := GStack.LocalAddresses;
    If IPListCheckListBox.Items.Strings[0] <> '127.0.0.1' then
      Items.Insert(0, '127.0.0.1');

    Checked[0] := true;
  end;

end;
 procedure TIndyClientMainForm.ShowDataSendMessage;
begin
  Memo1.Lines.Add('Data send := OK ' + TimeToStr(now));
end;
procedure TIndyClientMainForm.ShowDataReceivedMessage;
begin
  Memo1.Lines.Add('Data received:= OK ' + TimeToStr(now));
end;

procedure TIndyClientMainForm.ShowCannotGetDataErrorMessage;
begin
  Memo1.Lines.Add('Cannot get data from server, Unknown error occured'+ TimeToStr(now));
end;

procedure TIndyClientMainForm.ShowCannotSendDataErrorMessage;
begin
  Memo1.Lines.Add('Cannot send data to server, Unknown error occured'+ TimeToStr(now));
end;

procedure TIndyClientMainForm.ShowCannotSendStreamDataErrorMessage;
begin
  Memo1.Lines.Add('Cannot send STREAM data to server, Unknown error occured'+ TimeToStr(now));
end;


end.
