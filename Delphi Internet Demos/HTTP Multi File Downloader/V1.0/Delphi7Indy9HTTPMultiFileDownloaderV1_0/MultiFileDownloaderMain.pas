unit MultiFileDownloaderMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ExtCtrls, ComCtrls, StdCtrls, contnrs, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdException, Buttons,
  Menus, ActnList;
(* Limitations of this Demo
  Only works with URLS containing filenames
    eg. http://www.someserver.com/file.zip
    NOT http://www.someserver.com/download?file=123
-ie. using just "HEAD" does not always give the details.
    a routine needs to be made to get the filename when a "GET" is done.
    To do so, a "unique" temp filename must be used, and renamed once complete.
    This is not catered for yet.

  Duplicate filenames will overwrite
    eg. http://www.someserver1.com/file.zip
        http://www.otherserver.com/file.zip (will overwrite!)

  Files are not removed from the source list once downloaded

  The "Unique ID" is only unique per session. It should incorporate the date+time
  so that a "download list" can be reloaded and it will not replace the duplicate

*)

const
  WM_HTTPClientDownloadBeginWork = WM_user + 100;
  WM_HTTPClientDownloadWork = WM_user + 101;
  WM_HTTPClientDownloadEndWork = WM_user + 102;
  WM_HTTPDownloadSucceeded = WM_user + 103;
  WM_HTTPDownloadFailed = WM_user + 104;

type TDownloadStateForImages = (si_Blank, si_Failed, si_Succeeded, si_Downloading_Animation1, si_Downloading_Animation2);
type EUserCancelledDownloadException = class(Exception);

type TIndyInAThread = class(TThread)
  private
      UniqueID: integer;
      URL: string;
      LocalFilename: string;
      ShowProgress: boolean;
      fWorkCountMax: int64;
      fWorkDone: int64;
      HandleToPostTo: THandle;
      HTTPClientInsideAThread: TIdHTTP;
  public
      procedure HTTPClientInsideThreadWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);
      procedure HTTPClientInsideThreadWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
      procedure HTTPClientInsideThreadWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
      constructor Create(URL_: string; LocalFilename_: string; UniqueID_: integer; HandleToPostTo_: THandle; fOnComplete: TNotifyEvent);
      procedure Execute; override;
  end;

type TDownloadableFile = class
  private
      fURL: string;
      procedure SetURL(const Value: string);
      procedure IndyInAThreadComplete(sender: TObject);
      procedure CreateCompleteFile; // renames the '.part' and sets State to si_Succeeded
  public
      Filename: string;
      TempFilename: string;
      UniqueID: integer; // unique to this session only
      TotalFileSize: int64; // use 0 if unknown
      BytesPreviouslyDownloaded: int64; // eg. if resuming
      BytesDownloaded: int64;
      State: TDownloadStateForImages;
      IndyInAThread: TIndyInAThread;
      property URL: string read fURL write SetURL; // sets "filename" when you set "URL"
      constructor Create(URL_: string; UniqueID_: integer);
      destructor Destroy; override;
      function DownloadPercent: integer;
      procedure StartDownload;
      procedure StopDownload;
end;


type TSelectableFile = class
  private
      fURL: string;
      procedure SetURL(const Value: string);
  public
      Filename: string;
      UniqueID: integer; // unique to this session only
      property URL: string read fURL write SetURL; // sets "filename" when you set "URL"
      constructor Create(URL_: string; UniqueID_: integer);
end;

type
  TfMultiFileDownloaderMain = class(TForm)
    ilDownloadImages: TImageList;
    IdHTTP1: TIdHTTP;
    tDownloadAnimationChanger: TTimer;
    pSelectableFiles: TPanel;
    pSelectablelist_ButtonPanel: TPanel;
    bbAddURLToSelectableList: TBitBtn;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    lvDownloadableFiles: TListView;
    bbCancelAll: TBitBtn;
    alDownloadableFiles: TActionList;
    aDownloadSelected: TAction;
    aPauseSelected: TAction;
    aResumeSelected: TAction;
    pmDownloadableFiles: TPopupMenu;
    Download1: TMenuItem;
    Pause1: TMenuItem;
    ResumeDownload1: TMenuItem;
    aDeleteSelected: TAction;
    aPauseAll: TAction;
    aStartAll: TAction;
    aToggleSelectedDownloads: TAction;
    miHorzBar1: TMenuItem;
    StartAllDownloads1: TMenuItem;
    PauseAllDownloads1: TMenuItem;
    aRemoveCompleted: TAction;
    N1: TMenuItem;
    RemoveCompleteditemsfromlistnotfromdisk1: TMenuItem;
    lvSelectableFiles: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvSelectableFilesDblClick(Sender: TObject);
    procedure lvDownloadableFilesDblClick(Sender: TObject);
    procedure lvDownloadableFilesGetImageIndex(Sender: TObject;
      Item: TListItem);
    procedure tDownloadAnimationChangerTimer(Sender: TObject);
    procedure lvDownloadableFilesCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bbAddURLToSelectableListClick(Sender: TObject);
    procedure aPauseAllExecute(Sender: TObject);
    procedure aStartAllExecute(Sender: TObject);
    procedure aToggleSelectedDownloadsExecute(Sender: TObject);
    procedure aDownloadSelectedExecute(Sender: TObject);
    procedure aPauseSelectedExecute(Sender: TObject);
    procedure aResumeSelectedExecute(Sender: TObject);
    procedure aDeleteSelectedExecute(Sender: TObject);
    procedure pmDownloadableFilesPopup(Sender: TObject);
    procedure aRemoveCompletedExecute(Sender: TObject);
  private
    { Private declarations }
    fNextUniqueID: integer;
    procedure LoadSelectableFileList;
    procedure DisplaySelectableFileList;
    procedure SaveSelectableFileList;
  public
    { Public declarations }
    SelectableFileList: TObjectList;
    DownloadableFileList: TObjectList;
    function GetNextUniqueID: integer;
    function IndexOfDownloadableFile(UniqueID_: integer): integer; // returns the index of the downloadable file that matches this uniqueid
    Procedure HTTPClientDownloadBeginWork(var Msg:TMessage);Message WM_HTTPClientDownloadBeginWork;
    Procedure HTTPClientDownloadWork(var Msg:TMessage);Message WM_HTTPClientDownloadWork;
    Procedure HTTPClientDownloadEndWork(var Msg:TMessage);Message WM_HTTPClientDownloadEndWork;
    Procedure HTTPDownloadSucceeded(var Msg:TMessage);Message WM_HTTPDownloadSucceeded;
    Procedure HTTPDownloadFailed(var Msg:TMessage);Message WM_HTTPDownloadFailed;
  end;

var
  fMultiFileDownloaderMain: TfMultiFileDownloaderMain;
procedure ListView_GetSubItemRect(ListView: TCustomListview; Item: TListItem; SubItem: integer; var Rect_: TRect);

implementation

{$R *.dfm}

// This routine will try to determine the "rectangle" for a particular subitem in the listview
procedure ListView_GetSubItemRect(ListView: TCustomListview; Item: TListItem; SubItem: integer; var Rect_: TRect);
    var
        ColLeft: integer;
        i: integer;
   begin
        Rect_.TopLeft := item.Position;
        Rect_.Left := Rect_.Left - 2; // actual x position start

        ColLeft := Rect_.Left; //ARect.Left;
        for i := 0 to (SubItem-1) do
          ColLeft := ColLeft + ListView.Column[i].Width;
        Rect_.Left := ColLeft;
// Calculate bounding rectangle of selected column
        Rect_.Right := Rect_.Left + ListView.Column[SubItem].Width;
        Rect_.Bottom := 4 + Rect_.Top + ListView.Canvas.TextHeight('W');

    end;

{ TSelectableFile }

constructor TSelectableFile.Create(URL_: string; UniqueID_: integer);
    begin
        inherited Create;
        URL := URL_;
        UniqueID := UniqueID_;
    end;

procedure TSelectableFile.SetURL(const Value: string);
    var
        s: string;
    begin
        fURL := Value;
        s := Value;
        while pos('/', s) > 0 do
        begin
            delete(s, 1, pos('/', s));
        end;
        while pos('\', s) > 0 do
        begin
            delete(s, 1, pos('\', s));
        end;

        Filename := s;
    end;

{ TDownloadableFile }

constructor TDownloadableFile.Create(URL_: string; UniqueID_: integer);
    begin
        inherited Create;
        URL := URL_;
        UniqueID := UniqueID_;
        State := si_Blank;
    end;

destructor TDownloadableFile.Destroy;
    begin
        StopDownload;
        inherited;
    end;

procedure TDownloadableFile.CreateCompleteFile;
begin
    ForceDirectories(extractFilePath(Paramstr(0)) + 'In\');
    if FileExists(ExtractFilePath(Paramstr(0)) + 'In\' + self.Filename) then
      DeleteFile(ExtractFilePath(Paramstr(0)) + 'In\' + self.Filename);
    if FileExists(ExtractFilePath(Paramstr(0)) + 'Temp\' + self.Filename) then
      DeleteFile(ExtractFilePath(Paramstr(0)) + 'Temp\' + self.Filename);

    if MoveFile( PChar(ExtractFilePath(Paramstr(0)) + 'Temp\' + self.TempFilename) ,
      PChar(ExtractFilePath(Paramstr(0)) + 'In\' + self.Filename)) then
        self.State := si_Succeeded
    else
      self.State := si_Failed
end;

function TDownloadableFile.DownloadPercent: integer;
    begin
        if TotalFileSize = 0 then
          result := 0
        else
        begin
            result := Trunc((BytesDownloaded / TotalFileSize) * 100);
            if result > 100 then result := 100;
        end;
    end;


procedure TDownloadableFile.IndyInAThreadComplete(sender: TObject);
  begin
      if (Sender = IndyInAThread) then
        IndyInAThread := nil;
  end;

procedure TDownloadableFile.SetURL(const Value: string);
    var
        s: string;
    begin
        fURL := Value;
        s := Value;
        while pos('/', s) > 0 do
        begin
            delete(s, 1, pos('/', s));
        end;
        while pos('\', s) > 0 do
        begin
            delete(s, 1, pos('\', s));
        end;

        Filename := s;
        TempFilename := Filename + '.part';
    end;

procedure TDownloadableFile.StartDownload;
    var
        fs: TFileStream;
    begin
        if ( (State in [si_Blank, si_Failed]) and (not assigned(IndyInAThread) ) ) then
        begin // only start the download if we are not already downloading
            ForceDirectories(extractFilePath(Paramstr(0)) + 'Temp\');
// check if this is a "resume" - if it is, then the temp file will exist.
            if FileExists(extractFilePath(Paramstr(0)) + 'Temp\' + self.TempFilename) then
            begin
                fs := TFileStream.Create(extractFilePath(Paramstr(0)) + 'Temp\' + self.TempFilename, fmOpenRead + fmShareDenyNone);
                try
                    self.BytesPreviouslyDownloaded := FS.Size;
                finally
                    fs.Free;
                end;
            end
            else
              self.BytesPreviouslyDownloaded := 0;
            IndyInAThread := TIndyInAThread.Create(self.URL, extractFilePath(Paramstr(0)) + 'Temp\' + self.TempFilename, self.UniqueID, fMultiFileDownloaderMain.Handle, IndyInAThreadComplete);
        end;
    end;

procedure TDownloadableFile.StopDownload;
    begin
        if ( (State in [si_Downloading_Animation1, si_Downloading_Animation2]) and (assigned(IndyInAThread) ) ) then
        begin
            IndyInAThread.Terminate;
            IndyInAThread.WaitFor;
        end;
    end;

{ TIndyInAThread }

constructor TIndyInAThread.Create(URL_: string; LocalFilename_: string; UniqueID_: integer; HandleToPostTo_: THandle; fOnComplete: TNotifyEvent);
    begin
        inherited Create(True);
//      	FreeOnTerminate := True; // because we will FreeAndNil() this in the main thread
        URL := URL_;
        LocalFilename := LocalFilename_;
        UniqueID := UniqueID_;
        HandleToPostTo := HandleToPostTo_;
        ShowProgress := False;
        OnTerminate := fOnComplete;
        HTTPClientInsideAThread := TIdHTTP.Create(nil);

    //    HTTPClientInsideAThread.MaxLineAction := maException;
        HTTPClientInsideAThread.ReadTimeout := 0;
        HTTPClientInsideAThread.AllowCookies := True;
        HTTPClientInsideAThread.ProxyParams.BasicAuthentication := False;
        HTTPClientInsideAThread.ProxyParams.ProxyPort := 0;
        HTTPClientInsideAThread.Request.ContentLength := -1;
        HTTPClientInsideAThread.Request.ContentRangeEnd := 0;
        HTTPClientInsideAThread.Request.ContentRangeStart := 0;
        HTTPClientInsideAThread.Request.ContentType := 'text/html';
        HTTPClientInsideAThread.Request.Accept := 'text/html, */*';
        HTTPClientInsideAThread.Request.BasicAuthentication := False;
        HTTPClientInsideAThread.Request.UserAgent := 'Mozilla/3.0 (compatible; Indy Library)';
        HTTPClientInsideAThread.HTTPOptions := [hoForceEncodeParams];

        HTTPClientInsideAThread.OnWorkBegin := HTTPClientInsideThreadWorkBegin;
        HTTPClientInsideAThread.OnWork := HTTPClientInsideThreadWork;
        HTTPClientInsideAThread.OnWorkEnd := HTTPClientInsideThreadWorkEnd;

        Resume; // start the thread now, which will start the download
    end;

procedure TIndyInAThread.Execute;
    var
        FS: TFileStream;
    begin
        try
            ForceDirectories(ExtractFilePath(LocalFilename));
            if FileExists(LocalFilename) then
            begin
              FS := TFileStream.Create(LocalFilename, fmOpenReadWrite);
              FS.Seek(0, soFromEnd); // move to the end of the partial file
              HTTPClientInsideAThread.Request.ContentRangeStart := FS.Position;
//               ContentRangeEnd
            end
            else
            begin
                FS := TFileStream.Create(LocalFilename, fmCreate);
            end;
            ShowProgress := True;
            try
                HTTPClientInsideAThread.Get(URL, FS);
                PostMessage(HandleToPostTo, WM_HTTPDownloadSucceeded, UniqueID, 0);
// flesh this out a bit with some testing of the file etc...
            finally
                FS.Free;
            end;
        except
            on e: exception do
            begin
                PostMessage(HandleToPostTo, WM_HTTPDownloadFailed, UniqueID, 0);
            end;
        end;

        try
            HTTPClientInsideAThread.Free;
        except // do not care about any errors yet, maybe log them later
        end;
        ShowProgress := False;
    end;


procedure TIndyInAThread.HTTPClientInsideThreadWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);
    begin
        if Terminated then Raise EUserCancelledDownloadException.Create('Asked to disconnect by software')
        else if ShowProgress then
        begin
            fWorkCountMax := AWorkCountMax;
            PostMessage(HandleToPostTo, WM_HTTPClientDownloadBeginWork, UniqueID, AWorkCountMax);
        end;
    end;

procedure TIndyInAThread.HTTPClientInsideThreadWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
    begin
        if ( Terminated and (aWorkCount < fWorkCountMax) ) then
          Raise EUserCancelledDownloadException.Create('Asked to disconnect by software')
        else if ShowProgress then
        begin
            fWorkDone := AWorkCount;
            PostMessage(HandleToPostTo, WM_HTTPClientDownloadWork, UniqueID, AWorkCount);
        end;
    end;

procedure TIndyInAThread.HTTPClientInsideThreadWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    begin
        if ShowProgress then
        begin
            PostMessage(HandleToPostTo, WM_HTTPClientDownloadEndWork, UniqueID, 0);
        end;
    end;

// *************** FORM Methods

procedure TfMultiFileDownloaderMain.FormCreate(Sender: TObject);
    begin
        SelectableFileList := TObjectList.Create;
        DownloadableFileList := TObjectList.Create;
        lvDownloadableFiles.DoubleBuffered := True;
        fNextUniqueID := 0;
        LoadSelectableFileList;
        DisplaySelectableFileList;
    end;

procedure TfMultiFileDownloaderMain.FormDestroy(Sender: TObject);
    begin
        SelectableFileList.Clear;
        SelectableFileList.Free;
        DownloadableFileList.Clear;
        DownloadableFileList.Free;
    end;

procedure TfMultiFileDownloaderMain.FormClose(Sender: TObject; var Action: TCloseAction);
    begin
        tDownloadAnimationChanger.Enabled := False;
    end;

// everytime this function is called, we update the counter, so the next call gets a new number
function TfMultiFileDownloaderMain.GetNextUniqueID: integer;
    begin
        result := fNextUniqueID;
        inc(fNextUniqueID);
    end;

procedure TfMultiFileDownloaderMain.LoadSelectableFileList;
    var
        sl: TStringList;
        i: integer;
    begin
        sl := TStringList.Create;
        try
            sl.LoadFromFile(ExtractFilePath(Paramstr(0)) + 'DownloadableFiles.lst');
// load the list into our SelectableFileList
            SelectableFileList.Clear;
            for i := 0 to pred(sl.Count) do
            begin
                 SelectableFileList.Add(
                   TSelectableFile.Create(sl[i], GetNextUniqueID)
                 );
            end;
        finally
            sl.Free;
        end;
    end;

procedure TfMultiFileDownloaderMain.DisplaySelectableFileList;
    var
        i: integer;
        OneSelectableFile: TSelectableFile;
        newlistitem: TListItem;
    begin
// load the list into the combobox, and set the listview's "data" property to point to our object
        lvSelectableFiles.Items.BeginUpdate;
        try
            lvSelectableFiles.Items.Clear;
            for i := 0 to pred(SelectableFileList.Count) do
            begin
                OneSelectableFile := TSelectableFile(SelectableFileList[i]);
                newlistitem := lvSelectableFiles.Items.Add;
                newlistitem.Caption := OneSelectableFile.Filename;
                newlistitem.SubItems.Add(OneSelectableFile.URL);
// store the data object in the listview's data property so we can access it in the listview when we want to draw the progress etc.
                newlistitem.Data := OneSelectableFile;
            end;
        finally
            lvSelectableFiles.Items.EndUpdate;
        end;
    end;

procedure TfMultiFileDownloaderMain.SaveSelectableFileList;
    var
        i: integer;
        sl: TStringList;
        OneSelectableFile: TSelectableFile;
    begin
        sl := TStringList.Create;
        try
            for i := 0 to pred(SelectableFileList.Count) do
            begin
                OneSelectableFile := TSelectableFile(SelectableFileList[i]);
                sl.add(OneSelectableFile.URL);
                sl.SaveToFile(ExtractFilePath(Paramstr(0)) + 'Files.lst');
            end;
        finally
            sl.free;
        end;
    end;

// returns the index of the downloadable file that matches this uniqueid
function TfMultiFileDownloaderMain.IndexOfDownloadableFile(UniqueID_: integer): integer;
    var
        i: integer;
    begin
        result := -1;
        i := 0;
        while ( (result = -1) and (i < DownloadableFileList.Count) ) do
        begin
            if TDownloadableFile(DownloadableFileList[i]).UniqueID = UniqueID_ then
              result := i
            else
              inc(i);
        end;
    end;

procedure TfMultiFileDownloaderMain.lvSelectableFilesDblClick(Sender: TObject);
    var
        i: integer;
        OneSelectableFile: TSelectableFile;
        OneDownloadableFile: TDownloadableFile;
        newlistitem: TListItem;
    begin
        if lvSelectableFiles.SelCount = 0 then exit;
// assume you can select multiple files and click a button to add to download list
        for i := 0 to pred(lvSelectableFiles.Items.Count) do
        begin
            if lvSelectableFiles.Items[i].Selected then
            begin
// check if it is already in the list
                OneSelectableFile := TSelectableFile(lvSelectableFiles.Items[i].Data);
                if IndexOfDownloadableFile( OneSelectableFile.UniqueID ) = -1 then
                begin // not found, add it
// create the new DownloadableFile object
                    OneDownloadableFile := TDownloadableFile.Create(OneSelectableFile.URL, OneSelectableFile.UniqueID);
                    newlistitem := lvDownloadableFiles.Items.Add;
                    newlistitem.Caption := OneDownloadableFile.Filename;
// everything else is filled out by the "OnCustomDrawSubItem" property, but we populate it here so that it is initialised
                    newlistitem.SubItems.Add(OneDownloadableFile.URL);
                    newlistitem.SubItems.Add(IntToStr(OneDownloadableFile.TotalFileSize));
                    newlistitem.SubItems.Add(IntToStr(OneDownloadableFile.BytesDownloaded));
                    newlistitem.SubItems.Add('');
                    DownloadableFileList.Add(OneDownloadableFile);
                    newlistitem.Data := OneDownloadableFile;
                end; // of not there, so add it
            end; // of selected
        end; // of for loop
    end;

// Message handler for when a download starts. Threads send this message for us to catch
Procedure TfMultiFileDownloaderMain.HTTPClientDownloadBeginWork(var Msg:TMessage);
    var
        uniqueid_: integer;
        totalbytes_: int64;
        i: integer;
    begin
        uniqueid_ := Msg.wparam;
        totalbytes_ := Msg.LParam;
        i := IndexOfDownloadableFile(uniqueid_);
        if i <> -1 then
        begin
            TDownloadableFile(DownloadableFileList[i]).BytesDownloaded := TDownloadableFile(DownloadableFileList[i]).BytesPreviouslyDownloaded;
            TDownloadableFile(DownloadableFileList[i]).TotalFileSize := TDownloadableFile(DownloadableFileList[i]).BytesPreviouslyDownloaded + totalbytes_;
            TDownloadableFile(DownloadableFileList[i]).State := si_Downloading_Animation1;
            lvDownloadableFiles.Repaint;
        end;
    end;

// Message handler for progress of a download. Threads send this message for us to catch
Procedure TfMultiFileDownloaderMain.HTTPClientDownloadWork(var Msg:TMessage);
    var
        uniqueid_: integer;
        workcount: int64;
        i: integer;
    begin
        uniqueid_ := Msg.wparam;
        workcount := Msg.LParam;
        i := IndexOfDownloadableFile(uniqueid_);
        if i <> -1 then
        begin
            TDownloadableFile(DownloadableFileList[i]).BytesDownloaded := TDownloadableFile(DownloadableFileList[i]).BytesPreviouslyDownloaded + workcount;
            lvDownloadableFiles.Repaint;
        end;
    end;

// Message handler for when a download ends. Threads send this message for us to catch
Procedure TfMultiFileDownloaderMain.HTTPClientDownloadEndWork(var Msg:TMessage);
    var
        uniqueid_: integer;
        i: integer;
    begin
        uniqueid_ := Msg.wparam;
        i := IndexOfDownloadableFile(uniqueid_);
        if i <> -1 then
        begin
// nothing to do in this example really. the next message we get from the thread will be a "success" or "failure"
// which will change our icon appropriately
        end;
    end;

// Message handler for when a download fails. Threads send this message for us to catch
procedure TfMultiFileDownloaderMain.HTTPDownloadFailed(var Msg: TMessage);
    var
        uniqueid_: integer;
        i: integer;
    begin
        uniqueid_ := Msg.wparam;
        i := IndexOfDownloadableFile(uniqueid_);
        if i <> -1 then
        begin
// check if the "temp" file is actually the complete file anyway.
            if (
                 (TDownloadableFile(DownloadableFileList[i]).TotalFileSize > 0) and
                 (TDownloadableFile(DownloadableFileList[i]).BytesDownloaded = TDownloadableFile(DownloadableFileList[i]).TotalFileSize)
                ) then
              HTTPDownloadSucceeded(Msg)
            else
            begin
                TDownloadableFile(DownloadableFileList[i]).State := si_Failed;
                lvDownloadableFiles.Repaint;
            end;
        end;
    end;

// Message handler for when a download succeeds. Threads send this message for us to catch
procedure TfMultiFileDownloaderMain.HTTPDownloadSucceeded(var Msg: TMessage);
    var
        uniqueid_: integer;
        i: integer;
    begin
        uniqueid_ := Msg.wparam;
        i := IndexOfDownloadableFile(uniqueid_);
        if i <> -1 then
        begin
            TDownloadableFile(DownloadableFileList[i]).CreateCompleteFile; // also sets the "State" to si_Succeeded
            lvDownloadableFiles.Repaint;
        end;
    end;

procedure TfMultiFileDownloaderMain.lvDownloadableFilesDblClick(Sender: TObject);
    begin
        aToggleSelectedDownloads.Execute;
    end;

//Listview method to determine what image to show depending on the state
procedure TfMultiFileDownloaderMain.lvDownloadableFilesGetImageIndex(Sender: TObject; Item: TListItem);
    begin
        if assigned(Item.Data) then
          Item.ImageIndex := integer(TDownloadableFile(Item.Data).State)
        else
          Item.ImageIndex := 0;
    end;

// This is just a simple addition to change the download icon each second
procedure TfMultiFileDownloaderMain.tDownloadAnimationChangerTimer(Sender: TObject);
    var
        i: integer;
        found: boolean;
        OneDownloadableFile: TDownloadableFile;
    begin
        tDownloadAnimationChanger.Enabled := false;
        found := false;
// I am just using the "Tag" property of the time to decide which icon to draw
        tDownloadAnimationChanger.Tag := tDownloadAnimationChanger.Tag + 1;
        if tDownloadAnimationChanger.Tag >=2 then tDownloadAnimationChanger.Tag := 0;
        try
            for i := 0 to pred(lvDownloadableFiles.items.Count) do
            begin
                if assigned(lvDownloadableFiles.items[i].Data) then
                begin
                    OneDownloadableFile := TDownloadableFile(lvDownloadableFiles.items[i].Data);
                    if (OneDownloadableFile.State in [si_Downloading_Animation1, si_Downloading_Animation2]) then
                    begin
                        found := true;
                        if tDownloadAnimationChanger.Tag = 0 then
                          OneDownloadableFile.State := si_Downloading_Animation1
                        else
                          OneDownloadableFile.State := si_Downloading_Animation2;
                    end;
                end;
            end;
            if found then lvDownloadableFiles.Repaint;
        finally
            tDownloadAnimationChanger.enabled := true;
        end;
    end;

(*This is the hugely complicated drawing routine for the top listview. it lets us
show the "download byte count" and a graphical custom drawn progress bar.*)
procedure TfMultiFileDownloaderMain.lvDownloadableFilesCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
    var
        colBounds: TRect;
        progressbarrect: TRect;
        progressrect: TRect;

        lastcolor: tcolor;
        currentx: integer;
        progresspercent: integer;
        texttoprint: string;
    begin
// highlighting isn't working yet :-( sorry. Loki

        if SubItem = 2 then
        begin
            with (Sender as TCustomListView).Canvas do
            begin
    (* This ensures the correct highlight color is used *)
                lastcolor  := Brush.Color;
                ListView_GetSubItemRect((Sender as TCustomListView), Item, SubItem, ColBounds);

                FillRect(ColBounds);
                if assigned(Item.Data) then
                  texttoprint := FloatToStr(TDownloadableFile(Item.Data).TotalFileSize)
                else texttoprint := '?';

                TextOut(ColBounds.Left, ColBounds.Top, texttoprint);
            end;
            Brush.Color := lastcolor;
            DefaultDraw := false;
        end
        else if SubItem = 3 then
        begin
            with (Sender as TCustomListView).Canvas do
            begin
    (* This ensures the correct highlight color is used *)
                lastcolor  := Brush.Color;
                ListView_GetSubItemRect((Sender as TCustomListView), Item, SubItem, ColBounds);

                FillRect(ColBounds);
                if assigned(Item.Data) then
                  texttoprint := FloatToStr(TDownloadableFile(Item.Data).BytesDownloaded)
                else texttoprint := '?';

                Brush.Color := clBlack;
                TextOut(ColBounds.Left, ColBounds.Top, texttoprint);
            end;
            Brush.Color := lastcolor;
            DefaultDraw := false;
        end

        else if SubItem = 4 then
        begin

//    aTextRect:=Item.DisplayRect(drLabel);


            ListView_GetSubItemRect((Sender as TCustomListView), Item, SubItem, ColBounds);
//(*test works*)            (Sender as TCustomListView).Canvas.TextOut(ColBounds.Left , ColBounds.Top, 'test');

            with (Sender as TCustomListView).Canvas do
            begin
    (* This ensures the correct highlight color is used *)
                lastcolor  := Brush.Color;
//                    Brush.Color := clNavy;
                FillRect(ColBounds);

    // outline of progress bar
                progressbarrect.Top := ColBounds.Top;
                progressbarrect.Left := ColBounds.Left;
                progressbarrect.Bottom := ColBounds.Bottom;
                progressbarrect.Right := (progressbarrect.Left + 57);

                lastcolor  := Brush.Color;
                InflateRect(progressbarrect,-2,-2);
// highlighting isn't working ye. The following is my feeble attempts to get it going so far :-)
                if ( (cdsSelected in State) and ((Sender AS TCustomListView).RowSelect) ) then
                begin
//                    Brush.Color := clNavy;
//                    FillRect(ColBounds);
//                    Font.Color := clWhite;
                  Brush.Color := clBlack;
                end
                else
                  Brush.Color := clBlack;
                (Sender as TCustomListView).Canvas.FrameRect(progressbarrect);

    // actual progress
                if assigned(Item.Data) then
                  progresspercent := TDownloadableFile(Item.Data).DownloadPercent
                else
                  progresspercent := 0;
                if progresspercent > 0 then
                begin
                    progressrect.Top := progressbarrect.Top + 1;
                    progressrect.Left := progressbarrect.Left + 1;
                    progressrect.Bottom := progressbarrect.Bottom - 1;
                    progressrect.Right := progressrect.Left + 1 + (progresspercent div 2); // to get 1-100 to 1-50 pixels
                    Brush.Color := clLime;
                    (Sender as TCustomListView).Canvas.FillRect(progressrect);
                end;
                Brush.Color := lastcolor;
                currentx := ColBounds.Left + (progressbarrect.Right - progressbarrect.Left) + 4 + 2;
//                TextOut(currentx, ColBounds.Top, 'here'); //lbConnections.items[Index]);

                DefaultDraw := false;

            end;
        end;
    end;

procedure TfMultiFileDownloaderMain.bbAddURLToSelectableListClick(Sender: TObject);
    var
        s: string;
    begin
        s := InputBox('Add URL to download', 'Full URL path and filename', '');
        if s <> '' then
        begin
            SelectableFileList.Add(
               TSelectableFile.Create(s, GetNextUniqueID)
             );
            SaveSelectableFileList;
            DisplaySelectableFileList;
        end;
    end;


procedure TfMultiFileDownloaderMain.aPauseAllExecute(Sender: TObject);
    var
        i: integer;
    begin
        for i := pred(DownloadableFileList.Count) downto 0 do
          TDownloadableFile(DownloadableFileList[i]).StopDownload;
    end;

procedure TfMultiFileDownloaderMain.aStartAllExecute(Sender: TObject);
    var
        i: integer;
    begin
        for i := 0 to pred(DownloadableFileList.Count) do
          TDownloadableFile(DownloadableFileList[i]).StartDownload;
    end;

procedure TfMultiFileDownloaderMain.aToggleSelectedDownloadsExecute(Sender: TObject);
    var
        i: integer;
        OneDownloadableFile: TDownloadableFile;
    begin
        if lvDownloadableFiles.SelCount = 0 then exit;
// assume you can select multiple files and click a button to add to download list
        for i := 0 to pred(lvDownloadableFiles.Items.Count) do
        begin
            if lvDownloadableFiles.Items[i].Selected then
            begin
                OneDownloadableFile := TDownloadableFile(lvDownloadableFiles.Items[i].Data);
                if OneDownloadableFile <> nil then
                begin
                    if OneDownloadableFile.State in [si_Downloading_Animation1, si_Downloading_Animation2] then
                      OneDownloadableFile.StopDownload
                    else if OneDownloadableFile.State in [si_Blank, si_Failed] then
                      OneDownloadableFile.StartDownload;
                end;
            end;
        end;
    end;

procedure TfMultiFileDownloaderMain.aDownloadSelectedExecute(Sender: TObject);
    var
        i: integer;
        OneDownloadableFile: TDownloadableFile;
    begin
        if lvDownloadableFiles.SelCount = 0 then exit;
// assume you can select multiple files and click a button to add to download list
        for i := 0 to pred(lvDownloadableFiles.Items.Count) do
        begin
            if lvDownloadableFiles.Items[i].Selected then
            begin
                OneDownloadableFile := TDownloadableFile(lvDownloadableFiles.Items[i].Data);
                if OneDownloadableFile <> nil then
                begin
                    if OneDownloadableFile.State in [si_Blank, si_Failed] then
                      OneDownloadableFile.StartDownload;
                end;
            end;
        end;
    end;

procedure TfMultiFileDownloaderMain.aPauseSelectedExecute(Sender: TObject);
    var
        i: integer;
        OneDownloadableFile: TDownloadableFile;
    begin
        if lvDownloadableFiles.SelCount = 0 then exit;
// assume you can select multiple files and click a button to add to download list
        for i := 0 to pred(lvDownloadableFiles.Items.Count) do
        begin
            if lvDownloadableFiles.Items[i].Selected then
            begin
                OneDownloadableFile := TDownloadableFile(lvDownloadableFiles.Items[i].Data);
                if OneDownloadableFile <> nil then
                begin
                    if OneDownloadableFile.State in [si_Downloading_Animation1, si_Downloading_Animation2] then
                      OneDownloadableFile.StopDownload;
                end;
            end;
        end;
    end;

procedure TfMultiFileDownloaderMain.aResumeSelectedExecute(Sender: TObject);
    begin
        aDownloadSelected.Execute;
    end;

procedure TfMultiFileDownloaderMain.aDeleteSelectedExecute(
  Sender: TObject);
begin
//
end;

procedure TfMultiFileDownloaderMain.pmDownloadableFilesPopup(Sender: TObject);
    var
        OneDownloadableFile: TDownloadableFile;
    begin
        if lvDownloadableFiles.Selected = nil then
        begin
            aDownloadSelected.Visible := False;
            aResumeSelected.Visible := False;
            aPauseSelected.Visible := False;
            miHorzBar1.Visible := False;
        end
        else if lvDownloadableFiles.SelCount > 1 then
        begin
            aDownloadSelected.Visible := True;
            aResumeSelected.Visible := False;
            aPauseSelected.Visible := True;
            miHorzBar1.Visible := True;
        end
        else
        begin
            OneDownloadableFile := TDownloadableFile(lvDownloadableFiles.Selected.Data);
            aDownloadSelected.Visible := OneDownloadableFile.State = si_Blank;
            aResumeSelected.Visible := OneDownloadableFile.State = si_Failed;
            aPauseSelected.Visible := OneDownloadableFile.State in [si_Succeeded, si_Downloading_Animation1, si_Downloading_Animation2];
            miHorzBar1.Visible := True;
        end;


    end;

procedure TfMultiFileDownloaderMain.aRemoveCompletedExecute(Sender: TObject);
    var
        i: integer;
        s: string;
    begin
        for i := pred(DownloadableFileList.Count) downto 0 do
        begin
// because the download list matches the listview, we can safely assume they have the same index
// delete the temp files
            s := ExtractFilePath(Paramstr(0)) + 'Temp\' + TDownloadableFile(DownloadableFileList[i]).TempFilename;
            if FileExists(S) then
              DeleteFile(S);
// delete the complete downloaded file
            s := ExtractFilePath(Paramstr(0)) + 'In\' + TDownloadableFile(DownloadableFileList[i]).Filename;
            if FileExists(S) then
              DeleteFile(S);

            DownloadableFileList.Delete(i); // this calls the destroy of the object
            lvDownloadableFiles.Items[i].Delete;
        end;
    end;

end.
