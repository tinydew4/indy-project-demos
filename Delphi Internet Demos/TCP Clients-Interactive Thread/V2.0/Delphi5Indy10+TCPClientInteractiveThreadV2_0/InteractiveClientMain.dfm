object fInteractiveClientMain: TfInteractiveClientMain
  Left = 328
  Top = 183
  Width = 618
  Height = 539
  Caption = 
    'Later than Indy 10 Delphi 5 TCP Interactive Client }-=Loki=-{ lo' +
    'kiwashere@yahoo.co.nz'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
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
    object bDisconnect: TButton
      Left = 248
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Disconnect'
      TabOrder = 4
      OnClick = bDisconnectClick
    end
    object bConnect: TButton
      Left = 248
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 2
      OnClick = bConnectClick
    end
  end
  object ListBox1: TListBox
    Left = 0
    Top = 73
    Width = 610
    Height = 279
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
  object gbUserInput: TGroupBox
    Left = 0
    Top = 352
    Width = 610
    Height = 160
    Align = alBottom
    Caption = 'User Input'
    TabOrder = 2
    object pEdit: TPanel
      Left = 2
      Top = 15
      Width = 606
      Height = 28
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object eCommand: TEdit
        Left = 4
        Top = 4
        Width = 261
        Height = 21
        CharCase = ecUpperCase
        TabOrder = 0
        OnKeyDown = eCommandKeyDown
      end
      object bSendFileToServer: TButton
        Left = 288
        Top = 0
        Width = 105
        Height = 25
        Caption = 'Send File to Server'
        TabOrder = 1
        Visible = False
        OnClick = bSendFileToServerClick
      end
      object bLoadBatch: TButton
        Left = 520
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Load Batch'
        TabOrder = 2
        OnClick = bLoadBatchClick
      end
    end
    object lbPendingCommands: TListBox
      Left = 2
      Top = 43
      Width = 606
      Height = 115
      Align = alClient
      ItemHeight = 13
      TabOrder = 1
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'batch text files|*.txt|all files|*.*'
    Left = 490
    Top = 367
  end
end
