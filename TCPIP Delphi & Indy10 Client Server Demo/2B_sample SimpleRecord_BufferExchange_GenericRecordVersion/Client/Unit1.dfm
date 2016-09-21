object RecordClientForm: TRecordClientForm
  Left = 0
  Top = 0
  Caption = 'Record Exchange Client Demo Indy 10.5.5'
  ClientHeight = 322
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
  object CheckBox1: TCheckBox
    Left = 8
    Top = 23
    Width = 124
    Height = 17
    Caption = 'Connect/Disconnect'
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object Memo1: TMemo
    Left = 9
    Top = 137
    Width = 385
    Height = 177
    Lines.Strings = (
      '<  VERSION 06.04.2012>'
      ''
      '* http://sourceforge.net/projects/indy10clieservr/)'
      '* no support - no help - no warrenty - no ...'
      '* feel free to post your comments on source forge'
      '* add new features ..'
      ''
      'GENERIC RECORD TYPE EXCHANGE VERSION ')
    TabOrder = 1
  end
  object Button_SendBuffer: TButton
    Left = 8
    Top = 62
    Width = 386
    Height = 56
    Caption = 'Send Buffer'
    TabOrder = 2
    OnClick = Button_SendBufferClick
  end
  object BuildButton: TButton
    Left = 320
    Top = 19
    Width = 69
    Height = 25
    Caption = 'x32/x64'
    TabOrder = 3
    OnClick = BuildButtonClick
  end
  object IdTCPClient1: TIdTCPClient
    OnDisconnected = IdTCPClient1Disconnected
    OnConnected = IdTCPClient1Connected
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 32
    Top = 248
  end
end
