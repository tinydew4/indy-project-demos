unit uFTPServer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPServer, IdCmdTCPServer, IdFTPList,
  IdExplicitTLSClientServerBase, IdFTPServer, StdCtrls, IdFTPListOutput;

type
  TForm1 = class(TForm)
    IdFTPServer1: TIdFTPServer;
    btnClose: TButton;
    moNotes: TMemo;
    procedure IdFTPServer1UserLogin(ASender: TIdFTPServerContext;
      const AUsername, APassword: string; var AAuthenticated: Boolean);
    procedure IdFTPServer1RemoveDirectory(ASender: TIdFTPServerContext;
      var VDirectory: string);
    procedure IdFTPServer1MakeDirectory(ASender: TIdFTPServerContext;
      var VDirectory: string);
    procedure IdFTPServer1RetrieveFile(ASender: TIdFTPServerContext;
      const AFileName: string; var VStream: TStream);
    procedure IdFTPServer1GetFileSize(ASender: TIdFTPServerContext;
      const AFilename: string; var VFileSize: Int64);
    procedure IdFTPServer1StoreFile(ASender: TIdFTPServerContext;
      const AFileName: string; AAppend: Boolean; var VStream: TStream);
    procedure IdFTPServer1ListDirectory(ASender: TIdFTPServerContext;
      const APath: string; ADirectoryListing: TIdFTPListOutput; const ACmd,
      ASwitches: string);
    procedure FormCreate(Sender: TObject);
    procedure IdFTPServer1DeleteFile(ASender: TIdFTPServerContext;
      const APathName: string);
    procedure IdFTPServer1ChangeDirectory(ASender: TIdFTPServerContext;
      var VDirectory: string);
    procedure btnCloseClick(Sender: TObject);
  private
    function ReplaceChars(APath: String): String;
    function GetSizeOfFile(AFile : String) : Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  AppDir      : String;

implementation
{$R *.DFM}

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  IdFTPServer1.Active := false;
  close;
end;

function TForm1.ReplaceChars(APath:String):String;
var
 s:string;
begin
  s := StringReplace(APath, '/', '\', [rfReplaceAll]);
  s := StringReplace(s, '\\', '\', [rfReplaceAll]);
  Result := s;
end;

function TForm1.GetSizeOfFile(AFile : String) : Integer;
var
 FStream : TFileStream;
begin
Try
 FStream := TFileStream.Create(AFile, fmOpenRead);
 Try
  Result := FStream.Size;
 Finally
  FreeAndNil(FStream);
 End;
Except
 Result := 0;
End;
end;

procedure TForm1.IdFTPServer1ChangeDirectory(
  ASender: TIdFTPServerContext; var VDirectory: string);
begin
  ASender.CurrentDir := VDirectory;
end;

procedure TForm1.IdFTPServer1DeleteFile(ASender: TIdFTPServerContext;
  const APathName: string);
begin
  DeleteFile(ReplaceChars(AppDir+ASender.CurrentDir+'\'+APathname));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 AppDir := ExtractFilePath(Application.Exename);
end;

procedure TForm1.IdFTPServer1ListDirectory(ASender: TIdFTPServerContext;
  const APath: string; ADirectoryListing: TIdFTPListOutput; const ACmd,
  ASwitches: string);
var
 LFTPItem :TIdFTPListItem;
 SR : TSearchRec;
 SRI : Integer;
begin
  ADirectoryListing.DirFormat := doUnix;
  SRI := FindFirst(AppDir + APath + '\*.*', faAnyFile - faHidden - faSysFile, SR);
  While SRI = 0 do
  begin
    LFTPItem := ADirectoryListing.Add;
    LFTPItem.FileName := SR.Name;
    LFTPItem.Size := SR.Size;
    LFTPItem.ModifiedDate := FileDateToDateTime(SR.Time);
    if SR.Attr = faDirectory then
     LFTPItem.ItemType   := ditDirectory
    else
     LFTPItem.ItemType   := ditFile;
    SRI := FindNext(SR);
  end;
  FindClose(SR);
  SetCurrentDir(AppDir + APath + '\..');
end;

procedure TForm1.IdFTPServer1StoreFile(ASender: TIdFTPServerContext;
  const AFileName: string; AAppend: Boolean; var VStream: TStream);
begin
 if not Aappend then
   VStream := TFileStream.Create(ReplaceChars(AppDir+AFilename),fmCreate)
 else
   VStream := TFileStream.Create(ReplaceChars(AppDir+AFilename),fmOpenWrite)
end;

procedure TForm1.IdFTPServer1GetFileSize(ASender: TIdFTPServerContext;
  const AFilename: string; var VFileSize: Int64);
Var
 LFile : String;
begin
 LFile := ReplaceChars( AppDir + AFilename );
 try
 If FileExists(LFile) then
   VFileSize :=  GetSizeOfFile(LFile)
 else
   VFileSize := 0;
 except
   VFileSize := 0;
 end;
end;

procedure TForm1.IdFTPServer1RetrieveFile(ASender: TIdFTPServerContext;
  const AFileName: string; var VStream: TStream);
begin
  VStream := TFileStream.Create(ReplaceChars(AppDir+AFilename),fmOpenRead);
end;

procedure TForm1.IdFTPServer1MakeDirectory(ASender: TIdFTPServerContext;
  var VDirectory: string);
begin
  if not ForceDirectories(ReplaceChars(AppDir + VDirectory)) then
  begin
    Raise Exception.Create('Unable to create directory');
  end;
end;

procedure TForm1.IdFTPServer1RemoveDirectory(ASender: TIdFTPServerContext;
  var VDirectory: string);
Var
 LFile : String;
begin
  LFile := ReplaceChars(AppDir + VDirectory);
  // You should delete the directory here.
  // TODO
end;

procedure TForm1.IdFTPServer1UserLogin(ASender: TIdFTPServerContext;
  const AUsername, APassword: string; var AAuthenticated: Boolean);
begin
 // We just set AAuthenticated to true so any username / password is accepted
 // You should check them here - AUsername and APassword
 AAuthenticated := True;
end;

end.
