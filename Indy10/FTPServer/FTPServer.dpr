program FTPServer;

uses
  Forms,
  uFTPServer in 'uFTPServer.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Indy FTP Server';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
