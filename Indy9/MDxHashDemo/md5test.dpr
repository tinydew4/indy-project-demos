{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110727: md5test.dpr 
{
{   Rev 1.0    25/10/2004 23:43:38  ANeillans    Version: 9.0.17
{ Verified
}
program md5test;

uses
  {$IFDEF LINUX}
  QForms,
  {$ELSE}
  Forms,
  {$ENDIF}
  md5f in 'md5f.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
