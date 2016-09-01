{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110654: MsgEdtAdv.pas 
{
{   Rev 1.0    25/10/2004 23:18:34  ANeillans    Version: 9.0.17
{ Verified
}
unit MsgEdtAdv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmAdvancedOptions = class(TForm)
    lblSender: TLabel;
    edtSender: TEdit;
    mmoExtraHeaders: TMemo;
    bbtnOk: TBitBtn;
    bbtnCancel: TBitBtn;
    Label1: TLabel;
  private
    { Private declarations }
  protected
  public
    { Public declarations }
  end;

var
  frmAdvancedOptions: TfrmAdvancedOptions;

implementation

{$R *.DFM}

end.
