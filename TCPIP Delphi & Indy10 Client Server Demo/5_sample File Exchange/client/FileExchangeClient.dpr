program FileExchangeClient;

uses
  Forms,
  Unit_Indy_Classes in '..\..\Shared\Unit_Indy_Classes.pas',
  Unit_DelphiCompilerVersion in '..\..\Shared\Unit_DelphiCompilerVersion.pas',
  Unit_DelphiCompilerversionDLG in '..\..\Shared\Unit_DelphiCompilerversionDLG.pas' {OKRightDlgDelphi},
  Unit_Indy_Functions in '..\..\Shared\Unit_Indy_Functions.pas',
  Unit_FileClient in 'Unit_FileClient.pas' {FileExchangeClientForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFileExchangeClientForm, FileExchangeClientForm);
  Application.CreateForm(TOKRightDlgDelphi, OKRightDlgDelphi);
  Application.Run;
end.
