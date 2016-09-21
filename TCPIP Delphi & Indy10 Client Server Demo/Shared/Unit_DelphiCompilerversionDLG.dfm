object OKRightDlgDelphi: TOKRightDlgDelphi
  Left = 833
  Top = 360
  BorderStyle = bsDialog
  Caption = 'Program Build Information'
  ClientHeight = 315
  ClientWidth = 392
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 16
    Top = 8
    Width = 281
    Height = 285
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 33
    Top = 21
    Width = 100
    Height = 13
    Caption = 'Compiler Information'
  end
  object OKBtn: TButton
    Left = 300
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 300
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 1
    Visible = False
  end
  object EditCompilerVersion: TEdit
    Left = 33
    Top = 46
    Width = 221
    Height = 21
    TabOrder = 2
    Text = 'EditCompilerVersion'
    OnChange = FormShow
  end
  object RadioGroupBits: TRadioGroup
    Left = 33
    Top = 85
    Width = 221
    Height = 85
    Caption = 'Application Mode'
    Items.Strings = (
      '32 BIT'
      '64 BIT')
    TabOrder = 3
    OnClick = FormShow
  end
  object CharSizeRadioGroup: TRadioGroup
    Left = 33
    Top = 183
    Width = 221
    Height = 84
    Caption = 'Char Size '
    Items.Strings = (
      'AnsiChar'
      'WideChar'
      'unknown')
    TabOrder = 4
  end
end
