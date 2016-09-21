{*******************************************************}
{                                                       }
{  simple dialog to display the used compiler version   }
{                                                       }
{       Copyright (C) 2011 BDLM                         }
{                                                       }
{*******************************************************}

unit Unit_DelphiCompilerversionDLG;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TOKRightDlgDelphi = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    EditCompilerVersion: TEdit;
    RadioGroupBits: TRadioGroup;
    Label1: TLabel;
    CharSizeRadioGroup: TRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  OKRightDlgDelphi: TOKRightDlgDelphi;

implementation

uses Unit_DelphiCompilerVersion;

{$R *.dfm}




{-------------------------------------------------------------------------------
  Procedure: TOKRightDlgDelphi.FormShow
  Author:    b.
  DateTime:  2011.09.04
  Arguments: Sender: TObject
  Result:    set radio box and Edit  to correct information
-------------------------------------------------------------------------------}
procedure TOKRightDlgDelphi.FormShow(Sender: TObject);
var
       aSize   : Integer;
begin

     ///  display the used delphi compiler version
     EditCompilerVersion.Text := DelphiCompilerVersion ;


     if Isx64Code then
           begin
           RadioGroupBits.ItemIndex := 1;
           end
           else
           begin
           RadioGroupBits.ItemIndex := 0;
           end;

     aSize := sizeof(PChar);

     case aSize  of

     4:   CharSizeRadioGroup.ItemIndex := 0;

     8:   CharSizeRadioGroup.ItemIndex := 1;
     else
          CharSizeRadioGroup.ItemIndex := 3;
     end;



end;

{-------------------------------------------------------------------------------
  Procedure: TOKRightDlgDelphi.OKBtnClick
  Author:    bdlm
  DateTime:  2011.10.11
  Arguments: Sender: TObject
  Result:    set radio box and Edit  to correct information
-------------------------------------------------------------------------------}

procedure TOKRightDlgDelphi.OKBtnClick(Sender: TObject);
begin
    Close;
end;

end.
