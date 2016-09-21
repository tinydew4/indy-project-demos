program FileExchangeServer;

uses
  Forms,
  Unit_FileExchangeServer in 'Unit_FileExchangeServer.pas' {FileExchangeServerForm},
  Unit_DelphiCompilerVersion in '..\..\Shared\Unit_DelphiCompilerVersion.pas',
  Unit_Indy_Classes in '..\..\Shared\Unit_Indy_Classes.pas',
  Unit_Indy_Functions in '..\..\Shared\Unit_Indy_Functions.pas',
  Unit_DelphiCompilerversionDLG in '..\..\Shared\Unit_DelphiCompilerversionDLG.pas' {OKRightDlgDelphi};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFileExchangeServerForm, FileExchangeServerForm);
  Application.CreateForm(TOKRightDlgDelphi, OKRightDlgDelphi);
  Application.Run;
end.
