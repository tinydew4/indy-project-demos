{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110663: MessageSaveLoad.dpr 
{
{   Rev 1.0    25/10/2004 23:20:16  ANeillans    Version: 9.0.17
{ Verified
}
program MessageSaveLoad;

uses
  Forms,
  fMain in 'fMain.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
