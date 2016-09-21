object fClientMain: TfClientMain
  Left = 328
  Top = 183
  Width = 618
  Height = 539
  Caption = 
    'Delphi 5 Indy 10TCP Client (later version of Indy 10) }-=Loki=-{' +
    ' lokiwashere@yahoo.co.nz'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object gbSettings: TGroupBox
    Left = 0
    Top = 0
    Width = 610
    Height = 73
    Align = alTop
    Caption = 'Client'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 20
      Width = 38
      Height = 13
      Caption = 'Address'
    end
    object Label2: TLabel
      Left = 160
      Top = 20
      Width = 19
      Height = 13
      Caption = 'Port'
    end
    object eAddress: TEdit
      Left = 56
      Top = 16
      Width = 89
      Height = 21
      TabOrder = 0
      Text = 'localhost'
    end
    object bConnect: TButton
      Left = 256
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 2
      OnClick = bConnectClick
    end
    object ePort: TEdit
      Left = 184
      Top = 16
      Width = 41
      Height = 21
      TabOrder = 1
      Text = '2000'
    end
    object ProgressBar1: TProgressBar
      Left = 8
      Top = 48
      Width = 281
      Height = 16
      Min = 0
      Max = 100
      TabOrder = 3
      Visible = False
    end
  end
  object ListBox1: TListBox
    Left = 0
    Top = 73
    Width = 610
    Height = 439
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 1
  end
end
