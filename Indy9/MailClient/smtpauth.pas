{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110656: smtpauth.pas 
{
{   Rev 1.0    25/10/2004 23:18:36  ANeillans    Version: 9.0.17
{ Verified
}
unit smtpauth;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmSMTPAuthentication = class(TForm)
    BitBtn1: TBitBtn;
    GroupBox1: TGroupBox;
    cboAuthType: TComboBox;
    lblAuthenticationType: TLabel;
    edtAccount: TEdit;
    edtPassword: TEdit;
    lbAccount: TLabel;
    lbPassword: TLabel;
    procedure cboAuthTypeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure EnableControls;
  end;

var
  frmSMTPAuthentication: TfrmSMTPAuthentication;

implementation

{$R *.DFM}

{ TfrmSMTPAuthentication }

procedure TfrmSMTPAuthentication.EnableControls;
begin
  edtAccount.Enabled := (cboAuthType.ItemIndex <> 0);
  lbAccount.Enabled := (cboAuthType.ItemIndex <> 0);
  edtPassword.Enabled := (cboAuthType.ItemIndex <> 0);
  lbPassword.Enabled := (cboAuthType.ItemIndex <> 0);
end;

procedure TfrmSMTPAuthentication.cboAuthTypeChange(Sender: TObject);
begin
  EnableControls;
end;

end.
