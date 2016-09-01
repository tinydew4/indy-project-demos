{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  23310: FTPServer_console.dpr 
{
{   Rev 1.1    25/10/2004 22:48:54  ANeillans    Version: 9.0.17
{ Verified
}
{
{   Rev 1.0    12/09/2003 22:47:52  ANeillans
{ Initial Checkin
{ Verified against Indy 9 and D7
}
{
  Demo Name:  FTP Server Demo
  Created By: Bas Gooijen
          On: Unknown

  Notes:
    FTP Server Demo
    Sample of the usage of the TIdFtpServer component.
    Also shows how to use Indy in console apps

    Username: myuser
    Password: mypass


  Version History:
    None

  Tested:
   Indy 9:
     D5:     Untested
     D6:     Untested
     D7:     25th Oct 2004 by Andy Neillans
             Tested with Microsoft FTP Client
}

program FTPServer_console;

{$APPTYPE console}
uses
  Classes,
  windows,
  sysutils,
  IdFTPList,
  IdFTPServer,
  idtcpserver,
  IdSocketHandle,
  idglobal,
  IdHashCRC;

type
  TFTPServer = class
  private
    { Private declarations }
    IdFTPServer: tIdFTPServer;
    procedure IdFTPServer1UserLogin( ASender: TIdFTPServerThread; const AUsername, APassword: string; var AAuthenticated: Boolean ) ;
    procedure IdFTPServer1ListDirectory( ASender: TIdFTPServerThread; const APath: string; ADirectoryListing: TIdFTPListItems ) ;
    procedure IdFTPServer1RenameFile( ASender: TIdFTPServerThread; const ARenameFromFile, ARenameToFile: string ) ;
    procedure IdFTPServer1RetrieveFile( ASender: TIdFTPServerThread; const AFilename: string; var VStream: TStream ) ;
    procedure IdFTPServer1StoreFile( ASender: TIdFTPServerThread; const AFilename: string; AAppend: Boolean; var VStream: TStream ) ;
    procedure IdFTPServer1RemoveDirectory( ASender: TIdFTPServerThread; var VDirectory: string ) ;
    procedure IdFTPServer1MakeDirectory( ASender: TIdFTPServerThread; var VDirectory: string ) ;
    procedure IdFTPServer1GetFileSize( ASender: TIdFTPServerThread; const AFilename: string; var VFileSize: Int64 ) ;
    procedure IdFTPServer1DeleteFile( ASender: TIdFTPServerThread; const APathname: string ) ;
    procedure IdFTPServer1ChangeDirectory( ASender: TIdFTPServerThread; var VDirectory: string ) ;
    procedure IdFTPServer1CommandXCRC( ASender: TIdCommand ) ;
    procedure IdFTPServer1DisConnect( AThread: TIdPeerThread ) ;
  protected
    function TransLatePath( const APathname, homeDir: string ) : string;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  end;

constructor TFTPServer.Create;
begin
  IdFTPServer := tIdFTPServer.create( nil ) ;
  IdFTPServer.DefaultPort := 21;
  IdFTPServer.AllowAnonymousLogin := False;
  IdFTPServer.EmulateSystem := ftpsUNIX;
  IdFTPServer.HelpReply.text := 'Help is not implemented';
  IdFTPServer.OnChangeDirectory := IdFTPServer1ChangeDirectory;
  IdFTPServer.OnChangeDirectory := IdFTPServer1ChangeDirectory;
  IdFTPServer.OnGetFileSize := IdFTPServer1GetFileSize;
  IdFTPServer.OnListDirectory := IdFTPServer1ListDirectory;
  IdFTPServer.OnUserLogin := IdFTPServer1UserLogin;
  IdFTPServer.OnRenameFile := IdFTPServer1RenameFile;
  IdFTPServer.OnDeleteFile := IdFTPServer1DeleteFile;
  IdFTPServer.OnRetrieveFile := IdFTPServer1RetrieveFile;
  IdFTPServer.OnStoreFile := IdFTPServer1StoreFile;
  IdFTPServer.OnMakeDirectory := IdFTPServer1MakeDirectory;
  IdFTPServer.OnRemoveDirectory := IdFTPServer1RemoveDirectory;
  IdFTPServer.Greeting.NumericCode := 220;
  IdFTPServer.OnDisconnect := IdFTPServer1DisConnect;
  with IdFTPServer.CommandHandlers.add do
  begin
    Command := 'XCRC';
    OnCommand := IdFTPServer1CommandXCRC;
  end;
  IdFTPServer.Active := true;
end;

function CalculateCRC( const path: string ) : string;
var
  f: tfilestream;
  value: dword;
  IdHashCRC32: TIdHashCRC32;
begin
  IdHashCRC32 := nil;
  f := nil;
  try
    IdHashCRC32 := TIdHashCRC32.create;
    f := TFileStream.create( path, fmOpenRead or fmShareDenyWrite ) ;
    value := IdHashCRC32.HashValue( f ) ;
    result := inttohex( value, 8 ) ;
  finally
    f.free;
    IdHashCRC32.free;
  end;
end;

procedure TFTPServer.IdFTPServer1CommandXCRC( ASender: TIdCommand ) ;
// note, this is made up, and not defined in any rfc.
var
  s: string;
begin
  with TIdFTPServerThread( ASender.Thread ) do
  begin
    if Authenticated then
    begin
      try
        s := ProcessPath( CurrentDir, ASender.UnparsedParams ) ;
        s := TransLatePath( s, TIdFTPServerThread( ASender.Thread ) .HomeDir ) ;
        ASender.Reply.SetReply( 213, CalculateCRC( s ) ) ;
      except
        ASender.Reply.SetReply( 500, 'file error' ) ;
      end;
    end;
  end;
end;

destructor TFTPServer.Destroy;
begin
  IdFTPServer.free;
  inherited destroy;
end;

function StartsWith( const str, substr: string ) : boolean;
begin
  result := copy( str, 1, length( substr ) ) = substr;
end;

function BackSlashToSlash( const str: string ) : string;
var
  a: dword;
begin
  result := str;
  for a := 1 to length( result ) do
    if result[a] = '\' then
      result[a] := '/';
end;

function SlashToBackSlash( const str: string ) : string;
var
  a: dword;
begin
  result := str;
  for a := 1 to length( result ) do
    if result[a] = '/' then
      result[a] := '\';
end;

function TFTPServer.TransLatePath( const APathname, homeDir: string ) : string;
var
  tmppath: string;
begin
  result := SlashToBackSlash( homeDir ) ;
  tmppath := SlashToBackSlash( APathname ) ;
  if homedir = '/' then
  begin
    result := tmppath;
    exit;
  end;

  if length( APathname ) = 0 then
    exit;
  if result[length( result ) ] = '\' then
    result := copy( result, 1, length( result ) - 1 ) ;
  if tmppath[1] <> '\' then
    result := result + '\';
  result := result + tmppath;
end;

function GetSizeOfFile( const APathname: string ) : int64;
begin
  result := FileSizeByName( APathname ) ;
end;

function GetNewDirectory( old, action: string ) : string;
var
  a: integer;
begin
  if action = '../' then
  begin
    if old = '/' then
    begin
      result := old;
      exit;
    end;
    a := length( old ) - 1;
    while ( old[a] <> '\' ) and ( old[a] <> '/' ) do
      dec( a ) ;
    result := copy( old, 1, a ) ;
    exit;
  end;
  if ( action[1] = '/' ) or ( action[1] = '\' ) then
    result := action
  else
    result := old + action;
end;

procedure TFTPServer.IdFTPServer1UserLogin( ASender: TIdFTPServerThread;
  const AUsername, APassword: string; var AAuthenticated: Boolean ) ;
begin
  AAuthenticated := ( AUsername = 'myuser' ) and ( APassword = 'mypass' ) ;
  if not AAuthenticated then
    exit;
  ASender.HomeDir := '/';
  asender.currentdir := '/';
end;

procedure TFTPServer.IdFTPServer1ListDirectory( ASender: TIdFTPServerThread; const APath: string; ADirectoryListing: TIdFTPListItems ) ;

  procedure AddlistItem( aDirectoryListing: TIdFTPListItems; Filename: string; ItemType: TIdDirItemType; size: int64; date: tdatetime ) ;
  var
    listitem: TIdFTPListItem;
  begin
    listitem := aDirectoryListing.Add;
    listitem.ItemType := ItemType;
    listitem.FileName := Filename;
    listitem.OwnerName := 'anonymous';
    listitem.GroupName := 'all';
    listitem.OwnerPermissions := '---';
    listitem.GroupPermissions := '---';
    listitem.UserPermissions := '---';
    listitem.Size := size;
    listitem.ModifiedDate := date;
  end;

var
  f: tsearchrec;
  a: integer;
begin
  ADirectoryListing.DirectoryName := apath;

  a := FindFirst( TransLatePath( apath, ASender.HomeDir ) + '*.*', faAnyFile, f ) ;
  while ( a = 0 ) do
  begin
    if ( f.Attr and faDirectory > 0 ) then
      AddlistItem( ADirectoryListing, f.Name, ditDirectory, f.size, FileDateToDateTime( f.Time ) )
    else
      AddlistItem( ADirectoryListing, f.Name, ditFile, f.size, FileDateToDateTime( f.Time ) ) ;
    a := FindNext( f ) ;
  end;

  FindClose( f ) ;
end;

procedure TFTPServer.IdFTPServer1RenameFile( ASender: TIdFTPServerThread;
  const ARenameFromFile, ARenameToFile: string ) ;
begin
  if not MoveFile( pchar( TransLatePath( ARenameFromFile, ASender.HomeDir ) ) , pchar( TransLatePath( ARenameToFile, ASender.HomeDir ) ) ) then
    RaiseLastWin32Error;
end;

procedure TFTPServer.IdFTPServer1RetrieveFile( ASender: TIdFTPServerThread;
  const AFilename: string; var VStream: TStream ) ;
begin
  VStream := TFileStream.create( translatepath( AFilename, ASender.HomeDir ) , fmopenread or fmShareDenyWrite ) ;
end;

procedure TFTPServer.IdFTPServer1StoreFile( ASender: TIdFTPServerThread;
  const AFilename: string; AAppend: Boolean; var VStream: TStream ) ;
begin
  if FileExists( translatepath( AFilename, ASender.HomeDir ) ) and AAppend then
  begin
    VStream := TFileStream.create( translatepath( AFilename, ASender.HomeDir ) , fmOpenWrite or fmShareExclusive ) ;
    VStream.Seek( 0, soFromEnd ) ;
  end
  else
    VStream := TFileStream.create( translatepath( AFilename, ASender.HomeDir ) , fmCreate or fmShareExclusive ) ;
end;

procedure TFTPServer.IdFTPServer1RemoveDirectory( ASender: TIdFTPServerThread;
  var VDirectory: string ) ;
begin
  RmDir( TransLatePath( VDirectory, ASender.HomeDir ) ) ;
end;

procedure TFTPServer.IdFTPServer1MakeDirectory( ASender: TIdFTPServerThread;
  var VDirectory: string ) ;
begin
  MkDir( TransLatePath( VDirectory, ASender.HomeDir ) ) ;
end;

procedure TFTPServer.IdFTPServer1GetFileSize( ASender: TIdFTPServerThread;
  const AFilename: string; var VFileSize: Int64 ) ;
begin
  VFileSize := GetSizeOfFile( TransLatePath( AFilename, ASender.HomeDir ) ) ;
end;

procedure TFTPServer.IdFTPServer1DeleteFile( ASender: TIdFTPServerThread;
  const APathname: string ) ;
begin
  DeleteFile( pchar( TransLatePath( ASender.CurrentDir + '/' + APathname, ASender.HomeDir ) ) ) ;
end;

procedure TFTPServer.IdFTPServer1ChangeDirectory( ASender: TIdFTPServerThread;
  var VDirectory: string ) ;
begin
  VDirectory := GetNewDirectory( ASender.CurrentDir, VDirectory ) ;
end;

procedure TFTPServer.IdFTPServer1DisConnect( AThread: TIdPeerThread ) ;
begin
  //  nothing much here
end;

begin
  with TFTPServer.Create do
  try
    writeln( 'Running, press [enter] to terminate' ) ;
    readln
  finally
    free;
  end;
end.

