program sslClient10;

uses
  Forms,
  sslClient10Main in 'sslClient10Main.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

