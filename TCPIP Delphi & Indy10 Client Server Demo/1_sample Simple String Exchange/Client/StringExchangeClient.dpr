program StringExchangeClient;

uses
  Forms,
  Unit1 in 'Unit1.pas' {ClientForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
