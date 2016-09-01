unit sslServer9Main;

interface

{ SIMPLE INDY 9 SSL SERVER

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
}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdServerIOHandler, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPServer, StdCtrls, ExtCtrls, Buttons;

const
  maxConnections = 4;

type
  AShape = array of TShape;
  
  TForm1 = class(TForm)
    IdTCPServer: TIdTCPServer;
    Timer1: TTimer;
    Panel1: TPanel;
    btnExit: TSpeedButton;
    IdServerIOHandlerSSL: TIdServerIOHandlerSSL;
    ledListening: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure IdServerIOHandlerSSLGetPassword(var Password: String);
    procedure IdTCPServerExecute(AThread: TIdPeerThread);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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

  appDir:= extractFilePath(application.exename);
  IdServerIOHandlerSSL.SSLOptions.KeyFile:= appDir + 'sample.key';
  IdServerIOHandlerSSL.SSLOptions.CertFile:= appDir + 'sample.crt';
  IdServerIOHandlerSSL.SSLOptions.RootCertFile:= appDir + 'sampleRoot.pem';

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
      brush.color:= clRed;
    end; { do with ledConnected[i] }
  end; { for i:= 0 to (maxConnections - 1) }

  timer1.enabled:= true;

end; { FORM CREATE }

{===================================================================================}

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  timer1.enabled:= false;
  IdTCPServer.Active:= true;
  ledListening.Brush.color:= clLime;

end; { TIMER1 TIMER }

{===================================================================================}

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  idTcpServer.Active:= false;
  ledListening.Brush.Color:= clRed;
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

procedure TForm1.IdServerIOHandlerSSLGetPassword(var Password: String);
begin
  password:= 'aaaa';
end; { ID SERVER IO HANDLER SSL GET PASSWORD }

{===================================================================================}

procedure TForm1.IdTCPServerExecute(AThread: TIdPeerThread);
var
  connected: boolean;
  line: string;
  connectionNumber: integer;
begin
  { [!] NOTE: since this is a simple example to show how SSL works, we did not bother to synchronize
              any of the VCL/display calls - remember that the VCL is NOT thread-safe! }

  { Find an open connection... [!] }
  connectionNumber:= 0;
  while (ledConnected[connectionNumber].Brush.Color = clLime) do inc(connectionNumber);

  ledConnected[connectionNumber].Brush.Color:= clLime;  { show that we're connected [!] }

  AThread.Connection.WriteLn('hello');
  connected:= true;
  while connected do begin
    try
      line:= AThread.connection.ReadLn;
      AThread.connection.WriteLn('>>'+line);
      memo1.Lines.add(format('[%d] %s',[connectionNumber,line]));
      if (ansiUpperCase(line) = 'BYE') or (ansiUpperCase(line) = 'QUIT') then begin
        AThread.Connection.Disconnect;
        connected:= false;
      end; { if (ansiUpperCase(line) = 'BYE') or (ansiUpperCase(line) = 'QUIT') }
    except
      connected:= false;
    end; { try/except }
  end; { do while connected }

  ledConnected[connectionNumber].Brush.Color:= clRed;    { show that we've disconnected [!] }

end; { ID TCP SERVER EXECUTE }

{===================================================================================}
{===================================================================================}

end. {*}

