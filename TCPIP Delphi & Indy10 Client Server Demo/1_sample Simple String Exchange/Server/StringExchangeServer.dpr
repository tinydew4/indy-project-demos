program StringExchangeServer;

uses
  Forms,
  Unit1 in 'Unit1.pas' {StringServerForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TStringServerForm, StringServerForm);
  Application.Run;
end.
