object FileExchangeClientForm: TFileExchangeClientForm
  Left = 0
  Top = 0
  Caption = 'File  Exchange Client Demo Indy 10.5.5'
  ClientHeight = 407
  ClientWidth = 402
  Color = clLime
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 148
    Width = 134
    Height = 13
    Caption = 'File name (get from  server)'
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 23
    Width = 124
    Height = 17
    Caption = 'Connect/Disconnect'
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object Button_SendStream: TButton
    Left = 8
    Top = 70
    Width = 377
    Height = 56
    Caption = 'Send File'
    TabOrder = 1
    OnClick = Button_SendStreamClick
  end
  object BuildButton: TButton
    Left = 316
    Top = 19
    Width = 69
    Height = 25
    Caption = 'x32/x64'
    TabOrder = 2
    OnClick = BuildButtonClick
  end
  object FileNameEdit: TEdit
    Left = 8
    Top = 167
    Width = 297
    Height = 21
    TabOrder = 3
    Text = 'c:\temp\test_from_server.txt'
  end
  object LoadFileButton: TButton
    Left = 311
    Top = 132
    Width = 75
    Height = 56
    Caption = 'LoadFile'
    TabOrder = 4
    OnClick = LoadFileButtonClick
  end
  object Memo1: TMemo
    Left = 9
    Top = 194
    Width = 376
    Height = 191
    Lines.Strings = (
      '<  VERSION 06.03.2012>'
      ''
      '* http://sourceforge.net/projects/indy10clieservr/ '
      '* no support - no help - no warrenty - no ...'
      '* feel free to post your comments on source forge'
      '* add new features ..')
    TabOrder = 5
  end
  object IdTCPClient1: TIdTCPClient
    OnDisconnected = IdTCPClient1Disconnected
    OnConnected = IdTCPClient1Connected
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 40
    Top = 248
  end
  object aOpenDialog: TOpenDialog
    Left = 160
    Top = 248
  end
end
