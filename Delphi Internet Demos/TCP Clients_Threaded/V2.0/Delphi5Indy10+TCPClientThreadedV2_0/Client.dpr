program Client;

uses
  Forms,
  clientmain in 'clientmain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfClientMain, fClientMain);
  Application.Run;
end.
