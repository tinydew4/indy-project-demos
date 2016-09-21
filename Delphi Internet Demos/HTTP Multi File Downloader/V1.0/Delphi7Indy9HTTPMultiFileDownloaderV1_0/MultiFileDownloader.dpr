program MultiFileDownloader;

uses
  Forms,
  MultiFileDownloaderMain in 'MultiFileDownloaderMain.pas' {fMultiFileDownloaderMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMultiFileDownloaderMain, fMultiFileDownloaderMain);
  Application.Run;
end.
