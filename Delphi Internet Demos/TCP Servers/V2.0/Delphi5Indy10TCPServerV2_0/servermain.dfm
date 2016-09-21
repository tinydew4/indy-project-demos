object fServerMain: TfServerMain
  Left = 274
  Top = 107
  Width = 569
  Height = 507
  Caption = 'Delphi 5 Indy 10 TCP Server - }-Loki=-{ lokiwashere@yahoo.co.nz'
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
  object Splitter1: TSplitter
    Left = 169
    Top = 49
    Width = 3
    Height = 431
    Cursor = crHSplit
  end
  object ListBox1: TListBox
    Left = 172
    Top = 49
    Width = 389
    Height = 431
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
  end
  object gbSettings: TGroupBox
    Left = 0
    Top = 0
    Width = 561
    Height = 49
    Align = alTop
    Caption = 'Server'
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 20
      Width = 19
      Height = 13
      Caption = 'Port'
    end
    object lConnectionCount: TLabel
      Left = 264
      Top = 20
      Width = 67
      Height = 13
      Caption = '0 connections'
    end
    object ePort: TEdit
      Left = 40
      Top = 16
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '2000'
    end
    object bListen: TButton
      Left = 88
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Listen'
      TabOrder = 1
      OnClick = bListenClick
    end
    object bOffline: TButton
      Left = 168
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Offline'
      TabOrder = 2
      OnClick = bOfflineClick
    end
  end
  object lbConnections: TListBox
    Left = 0
    Top = 49
    Width = 169
    Height = 431
    Align = alLeft
    ItemHeight = 16
    Style = lbOwnerDrawFixed
    TabOrder = 2
    OnDrawItem = lbConnectionsDrawItem
  end
  object IdTCPServer1: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    OnAfterBind = IdTCPServer1AfterBind
    OnConnect = IdTCPServer1Connect
    OnExecute = IdTCPServer1Execute
    OnDisconnect = IdTCPServer1Disconnect
    Left = 112
    Top = 56
  end
end
