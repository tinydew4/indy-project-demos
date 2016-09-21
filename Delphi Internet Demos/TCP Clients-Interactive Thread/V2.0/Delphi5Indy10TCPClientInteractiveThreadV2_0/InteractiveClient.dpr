program InteractiveClient;

uses
  Forms,
  InteractiveClientMain in 'InteractiveClientMain.pas' {fInteractiveClientMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfInteractiveClientMain, fInteractiveClientMain);
  Application.Run;
end.
