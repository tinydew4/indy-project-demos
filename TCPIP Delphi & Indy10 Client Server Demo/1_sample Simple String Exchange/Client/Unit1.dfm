object ClientForm: TClientForm
  Left = 0
  Top = 0
  Caption = 'Very Simple String Exchange Client Indy 10.5.5'
  ClientHeight = 306
  ClientWidth = 430
  Color = clLime
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object CheckBoxConnectDisconnet: TCheckBox
    Left = 8
    Top = 8
    Width = 148
    Height = 17
    Caption = 'Connect/Disconnect'
    TabOrder = 0
    OnClick = CheckBoxConnectDisconnetClick
  end
  object ButtonSendString: TButton
    Left = 180
    Top = 8
    Width = 241
    Height = 25
    Caption = 'Send String'
    TabOrder = 1
    OnClick = ButtonSendStringClick
  end
  object Edit1: TEdit
    Left = 8
    Top = 48
    Width = 413
    Height = 21
    TabOrder = 2
    Text = 'Write Text here'
  end
  object Memo1: TMemo
    Left = 8
    Top = 88
    Width = 413
    Height = 211
    Lines.Strings = (
      '<  VERSION 01.05.2012>'
      ''
      '* http://sourceforge.net/projects/indy10clieservr/)'
      '* no support - no help - no warrenty - no ...'
      '* feel free to post your comments on source forge'
      '* add new features ..')
    TabOrder = 3
  end
  object IdTCPClient1: TIdTCPClient
    OnDisconnected = IdTCPClient1Disconnected
    OnConnected = IdTCPClient1Connected
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 24
    Top = 256
  end
end
