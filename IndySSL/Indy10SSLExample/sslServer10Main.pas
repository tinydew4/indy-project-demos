unit sslServer10Main;

interface

{ SIMPLE INDY 10 SSL SERVER

  Written by Ralph Sickinger, Best Manufacturing Practices Center of Excellence (BMPCOE)

  e-mail: ralph@bmpcoe.org
  
  This program establishes a TCP Server that listens for SSL connections on port 3000.  When a
  connection is received, the server responds with "Hello", and then listens for any other lines
  of text sent from the client.  When a line is received, it is echoed to the screen as well as
  back to the client.

  Note: in order to run this program, you must have libeay32.dll and ssleay32.dll installed where the
        application can find them  (either in the Windows System32 folder, or in the same folder as the
        application itself.  These files can be downloaded from:  http://indy.fulgan.com/SSL/

        The server also requires that the certificate files (sample.crt, sample.key, and sampleRoot.pem)
        be available in the same folder as the excutable.

  Changes from Indy 9:

  * In order to compile the application, you'll have to add the Indy 10 source folders to
    the Project/Options/Directories-Conditionals/Search Path;
    e.g: C:\Indy10\Lib\Core;C:\Indy10\Lib\System;C:\Indy10\Lib\Protocols

  * All instances of AThread.Connection.ReadLn (or WriteLn) must be changed to
    AContext.Connection.IOHandler.ReadLn

  * You must add the OnConnect method to check for SSL usage and set the passThrough property
    (see procedure IdTCPServerConnect).  This one is CRITICAL!  (Thanks to Mattias Fagerlund for
    posting this little tidbit;  without him I'd still be pulling my hair out trying to figure 
    out why the server wouldn't accept connections!)

  * You will have to manually add "IdContext" to the "uses" clause.

}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdServerIOHandler, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPServer, StdCtrls, ExtCtrls, Buttons, IdSSL, IdContext;

const
  maxConnections = 4;
  clOn = clLime;
  clOff = clGreen;
  
type
  AShape = array of TShape;

  TForm1 = class(TForm)
    Timer1: TTimer;
    Panel1: TPanel;
    btnExit: TSpeedButton;
    ledListening: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    Memo1: TMemo;
    IdTCPServer: TIdTCPServer;
    IdServerIOHandlerSSLOpenSSL: TIdServerIOHandlerSSLOpenSSL;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure IdServerIOHandlerSSLOpenSSLGetPassword(var Password: String);
    procedure IdTCPServerConnect(AContext: TIdContext);
    procedure IdTCPServerExecute(AContext: TIdContext);
  private
    { Private declarations }
    ledConnected: AShape;
  public
    { Public declarations }
  end; { TForm1 }

var
  Form1: TForm1;

{===================================================================================}
{===================================================================================}

implementation

{$R *.dfm}

{===================================================================================}

procedure TForm1.FormCreate(Sender: TObject);
var
  i, x: integer;
  appDir: string;
begin
  left:= 580;
  top:= 80;

  IdTCPServer.MaxConnections:= maxConnections;

  { IMPORTANT!  You must specify the certificate, key, and root cert files! }
  appDir:= extractFilePath(application.exename);
  IdServerIOHandlerSSLOpenSSL.SSLOptions.KeyFile:= appDir + 'sample.key';
  IdServerIOHandlerSSLOpenSSL.SSLOptions.CertFile:= appDir + 'sample.crt';
  IdServerIOHandlerSSLOpenSSL.SSLOptions.RootCertFile:= appDir + 'sampleRoot.pem';

  setLength(ledConnected,maxConnections);

  x:= 225;
  for i:= 0 to (maxConnections - 1) do begin
    ledConnected[i]:= TShape.create(panel1);
    with ledConnected[i] do begin
      parent:= panel1;
      height:= 8;
      width:= 20;
      top:= 15;
      left:= x;  inc(x,25);
      brush.color:= clOff;
    end; { do with ledConnected[i] }
  end; { for i:= 0 to (maxConnections - 1) }

  timer1.enabled:= true;

end; { FORM CREATE }

{===================================================================================}

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  { This approach (with the timer) is used to ensure that *everything* has been fully
    created and the application is running before we start the server up. }
    
  timer1.enabled:= false;
  IdTCPServer.Active:= true;
  ledListening.Brush.color:= clOn;

end; { TIMER1 TIMER }

{===================================================================================}

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  idTcpServer.Active:= false;
  ledListening.Brush.Color:= clOff;
  application.processMessages;
  canClose:= true;

end; { FORM CLOSE QUERY }

{===================================================================================}

procedure TForm1.btnExitClick(Sender: TObject);
begin
  close;

end; { BTN EXIT CLICK }

{===================================================================================}
{===================================================================================}

procedure TForm1.IdServerIOHandlerSSLOpenSSLGetPassword(var Password: String);
begin
  password:= 'aaaa';
end; { ID SERVER IO HANDLER SSL OPEN SSL GET PASSWORD }

{===================================================================================}

procedure TForm1.IdTCPServerConnect(AContext: TIdContext);
begin
  { THESE TWO LINES ARE CRITICAL TO MAKING THE IdTCPSERVER WORK WITH SSL! }
  if (AContext.Connection.IOHandler is TIdSSLIOHandlerSocketBase) then
    TIdSSLIOHandlerSocketBase(AContext.Connection.IOHandler).PassThrough:= false;

end; { ID TCP SERVER CONNECT }

{===================================================================================}

procedure TForm1.IdTCPServerExecute(AContext: TIdContext);
var
  connected: boolean;
  line: string;
  connectionNumber: integer;
begin
  { [!] NOTE: since this is a simple example to show how SSL works, we did not bother to synchronize
              any of the VCL/display calls - remember that the VCL is NOT thread-safe! }

  { Find an open connection... [!] }
  connectionNumber:= 0;
  while (ledConnected[connectionNumber].Brush.Color = clOn) do inc(connectionNumber);

  ledConnected[connectionNumber].Brush.Color:= clOn;  { show that we're connected [!] }

  AContext.Connection.IOHandler.WriteLn('Hello');
  connected:= true;
  while connected do begin
    try
      line:= AContext.Connection.IOHandler.ReadLn;
      AContext.Connection.IOHandler.WriteLn('>>'+line);
      memo1.Lines.add(format('[%d] %s',[connectionNumber,line]));
      if (ansiUpperCase(line) = 'BYE') or (ansiUpperCase(line) = 'QUIT') then begin
        AContext.Connection.Disconnect;
        connected:= false;
      end; { if (ansiUpperCase(line) = 'BYE') or (ansiUpperCase(line) = 'QUIT') }
    except
      connected:= false;
    end; { try/except }
  end; { do while connected }

  ledConnected[connectionNumber].Brush.Color:= clOff;    { show that we've disconnected [!] }

end; { ID TCP SERVER EXECUTE }

{===================================================================================}
{===================================================================================}

end. {*}

