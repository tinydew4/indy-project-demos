program sslServer10;

uses
  Forms,
  sslServer10Main in 'sslServer10Main.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

