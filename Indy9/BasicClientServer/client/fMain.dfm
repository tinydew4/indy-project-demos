object frmMain: TfrmMain
  Left = 192
  Top = 107
  Width = 429
  Height = 392
  Caption = 'Basic TCP client/server - client'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 8
    Width = 54
    Height = 24
    Caption = 'Client'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 9
    Top = 45
    Width = 22
    Height = 13
    Caption = 'Host'
  end
  object Label3: TLabel
    Left = 165
    Top = 45
    Width = 19
    Height = 13
    Caption = 'Port'
  end
  object Bevel1: TBevel
    Left = 6
    Top = 37
    Width = 233
    Height = 61
  end
  object Label4: TLabel
    Tag = 99
    Left = 9
    Top = 136
    Width = 97
    Height = 13
    Caption = 'Available commands'
    Enabled = False
  end
  object Label5: TLabel
    Left = 8
    Top = 108
    Width = 142
    Height = 13
    Caption = 'Communicate with server'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtHost: TEdit
    Left = 38
    Top = 41
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '127.0.0.1'
  end
  object edtPort: TEdit
    Left = 194
    Top = 41
    Width = 41
    Height = 21
    TabOrder = 1
    Text = '9099'
  end
  object btnConnect: TButton
    Left = 82
    Top = 69
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 2
    OnClick = btnConnectClick
  end
  object btnDisconnect: TButton
    Left = 160
    Top = 69
    Width = 75
    Height = 25
    Caption = 'Disconnect'
    TabOrder = 3
    OnClick = btnDisconnectClick
  end
  object cboCommands: TComboBox
    Tag = 99
    Left = 9
    Top = 152
    Width = 145
    Height = 21
    Enabled = False
    ItemHeight = 13
    TabOrder = 4
    Text = 'Date'
    Items.Strings = (
      'Date'
      'Time'
      'TickCount'
      'Doh! an unknown Command...'
      'Quit')
  end
  object lbCommunication: TListBox
    Tag = 99
    Left = 8
    Top = 192
    Width = 405
    Height = 129
    Enabled = False
    ItemHeight = 13
    TabOrder = 5
  end
  object btnExit: TButton
    Left = 338
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 6
    OnClick = btnExitClick
  end
  object btnSendCommand: TButton
    Tag = 99
    Left = 157
    Top = 150
    Width = 84
    Height = 25
    Caption = 'Send command'
    Enabled = False
    TabOrder = 7
    OnClick = btnSendCommandClick
  end
  object IdTCPClient: TIdTCPClient
    MaxLineAction = maException
    OnDisconnected = IdTCPClientDisconnected
    OnConnected = IdTCPClientConnected
    Port = 0
    Left = 212
    Top = 4
  end
end
