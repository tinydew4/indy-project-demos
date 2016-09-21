program Server;

uses
  Forms,
  servermain in 'servermain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfServerMain, fServerMain);
  Application.Run;
end.
