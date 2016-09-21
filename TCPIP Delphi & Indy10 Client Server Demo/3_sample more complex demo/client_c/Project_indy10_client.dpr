program Project_indy10_client;

uses
  Forms,
  Unit_DelphiCompilerversionDLG in '..\..\Shared\Unit_DelphiCompilerversionDLG.pas' {OKRightDlgDelphi},
  Unit_DelphiCompilerVersion in '..\..\Shared\Unit_DelphiCompilerVersion.pas',
  Unit_Indy_Classes in '..\..\Shared\Unit_Indy_Classes.pas',
  Unit_Indy_Functions in '..\..\Shared\Unit_Indy_Functions.pas',
  Unit_indy10_complexdemo in 'Unit_indy10_complexdemo.pas' {IndyClientMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TIndyClientMainForm, IndyClientMainForm);
  Application.CreateForm(TOKRightDlgDelphi, OKRightDlgDelphi);
  Application.CreateForm(TIndyClientMainForm, IndyClientMainForm);
  Application.Run;
end.
