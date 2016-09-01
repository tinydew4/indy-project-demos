object ClientFrmMain: TClientFrmMain
  Left = 255
  Top = 394
  Width = 351
  Height = 289
  Caption = 'Test-Client'
  Color = clBtnFace
  Constraints.MinHeight = 285
  Constraints.MinWidth = 350
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    343
    255)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 28
    Width = 95
    Height = 13
    Caption = 'incoming messages:'
  end
  object Label2: TLabel
    Left = 4
    Top = 176
    Width = 51
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Command:'
  end
  object Label3: TLabel
    Left = 4
    Top = 220
    Width = 46
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Message:'
  end
  object Label4: TLabel
    Left = 156
    Top = 176
    Width = 107
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Recipient (empty=all):'
  end
  object CBClientActive: TCheckBox
    Left = 4
    Top = 4
    Width = 65
    Height = 17
    Caption = 'active'
    TabOrder = 0
    OnClick = CBClientActiveClick
  end
  object IncomingMessages: TMemo
    Left = 4
    Top = 44
    Width = 335
    Height = 125
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object EditCommand: TComboBox
    Left = 4
    Top = 192
    Width = 149
    Height = 21
    Anchors = [akLeft, akBottom]
    ItemHeight = 13
    TabOrder = 2
    Text = 'MESSAGE'
    Items.Strings = (
      'MESSAGE'
      'DIALOG'
      '<custom>')
  end
  object EditMessage: TEdit
    Left = 4
    Top = 236
    Width = 265
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 4
  end
  object EditRecipient: TEdit
    Left = 156
    Top = 192
    Width = 183
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
  end
  object ButtonSend: TButton
    Left = 272
    Top = 236
    Width = 67
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'Send'
    Enabled = False
    TabOrder = 5
    OnClick = ButtonSendClick
  end
  object Client: TIdTCPClient
    MaxLineAction = maException
    Host = 'localhost'
    Port = 47110
    Left = 132
    Top = 96
  end
end
