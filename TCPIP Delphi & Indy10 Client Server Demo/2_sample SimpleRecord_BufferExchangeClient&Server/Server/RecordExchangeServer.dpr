program RecordExchangeServer;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit_DelphiCompilerVersion in '..\..\Shared\Unit_DelphiCompilerVersion.pas',
  Unit_DelphiCompilerversionDLG in '..\..\Shared\Unit_DelphiCompilerversionDLG.pas' {OKRightDlgDelphi},
  Unit_Indy_Classes in '..\..\Shared\Unit_Indy_Classes.pas',
  Unit_Indy_Functions in '..\..\Shared\Unit_Indy_Functions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TOKRightDlgDelphi, OKRightDlgDelphi);
  Application.Run;
end.
