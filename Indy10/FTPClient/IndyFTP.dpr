{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  23000: IndyFTP.dpr 
{
{   Rev 1.1    09/11/2003 3:20:50 PM  Jeremy Darling
{ Completed Log Color customization.
}
{
{   Rev 1.0    09/11/2003 12:48:56 PM  Jeremy Darling
{ Project Added to TC
}
program IndyFTP;

uses
  Forms,
  MainForm in 'MainForm.pas' {frmMain},
  FTPSiteInfo in 'FTPSiteInfo.pas',
  ConfigureSiteForm in 'ConfigureSiteForm.pas' {frmConfigureSite},
  ConfigureApplicationForm in 'ConfigureApplicationForm.pas' {frmConfigureApplication},
  ApplicationConfiguration in 'ApplicationConfiguration.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
