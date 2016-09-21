program Project_INDY10_SERVER;
{-------------------------------------------------------------------

     INDY 10 DEMo PROJECT   ---  

  project start :   September 2010  


  ------------------------------------------------------------------}

uses
  Forms,
  Unit_INDY10_server in 'Unit_INDY10_server.pas' {ServerMainForm},
  Unit_DelphiCompilerVersion in '..\..\Shared\Unit_DelphiCompilerVersion.pas',
  Unit_DelphiCompilerversionDLG in '..\..\Shared\Unit_DelphiCompilerversionDLG.pas' {OKRightDlgDelphi},
  Unit_Indy_Classes in '..\..\Shared\Unit_Indy_Classes.pas',
  Unit_Indy_Functions in '..\..\Shared\Unit_Indy_Functions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TServerMainForm, ServerMainForm);
  Application.CreateForm(TOKRightDlgDelphi, OKRightDlgDelphi);
  Application.Run;
end.
