program stream_server;

uses
  Vcl.Forms,
  Unit_Indy_Classes in '..\..\Shared\Unit_Indy_Classes.pas',
  Unit_Indy_Functions in '..\..\Shared\Unit_Indy_Functions.pas',
  Unit_DelphiCompilerVersion in '..\..\Shared\Unit_DelphiCompilerVersion.pas',
  Unit_DelphiCompilerversionDLG in '..\..\Shared\Unit_DelphiCompilerversionDLG.pas' {OKRightDlgDelphi},
  Unit_StreamServer in 'Unit_StreamServer.pas' {StreamServerForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TStreamServerForm, StreamServerForm);
  Application.CreateForm(TOKRightDlgDelphi, OKRightDlgDelphi);
  Application.CreateForm(TStreamServerForm, StreamServerForm);
  Application.Run;
end.
