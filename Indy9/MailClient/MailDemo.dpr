{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110650: MailDemo.dpr 
{
{   Rev 1.0    25/10/2004 23:18:32  ANeillans    Version: 9.0.17
{ Verified
}
// NOTE: This demo ONLY runs under Windows.

// There is a seperate Kylix version of this demo.
program MailDemo;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  Setup in 'Setup.pas' {fmSetup},
  msgEdtAdv in 'msgEdtAdv.pas' {frmAdvancedOptions},
  MsgEditor in 'MsgEditor.pas' {frmMessageEditor0},
  smtpauth in 'smtpauth.pas' {frmSMTPAuthentication};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAdvancedOptions, frmAdvancedOptions);
  Application.CreateForm(TfrmMessageEditor, frmMessageEditor);
  Application.CreateForm(TfrmSMTPAuthentication, frmSMTPAuthentication);
  Application.Run;
end.
