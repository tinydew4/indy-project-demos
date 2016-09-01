{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110670: main.pas 
{
{   Rev 1.0    25/10/2004 23:21:20  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: URI Demo
 Author:    < unknown - please contact me to claim credit! - Allen O'Neill >
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------

Verified:
  Indy 9:
    D7: 25th Oct 2004 By Andy Neillans

}

unit main;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls,
  SysUtils, Classes;

type
  TfrmDemo = class(TForm)
    edtURI: TEdit;
    edtProtocol: TEdit;
    edtHost: TEdit;
    edtPort: TEdit;
    lblProtocol: TLabel;
    lblHost: TLabel;
    lblPort: TLabel;
    lblPath: TLabel;
    lblDocument: TLabel;
    edtPath: TEdit;
    edtDocument: TEdit;
    btnDoIt: TButton;
    lblURI: TLabel;
    lblInstructions: TLabel;
    procedure btnDoItClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDemo: TfrmDemo;

implementation
uses IdURI;

{$R *.DFM}

procedure TfrmDemo.btnDoItClick(Sender: TObject);
var URI : TIdURI;
begin
  URI := TIdURI.Create(edtURI.Text);
  try
    edtProtocol.Text := URI.Protocol;
    edtHost.Text := URI.Host;
    edtPort.Text := URI.Port;
    edtPath.Text := URI.Path;
    edtDocument.Text := URI.Document;
  finally
    URI.Free;
  end;
end;

end.
