object StringServerForm: TStringServerForm
  Left = 0
  Top = 0
  Caption = 'Very Simple String Exchange Server Indy 10.5.5'
  ClientHeight = 311
  ClientWidth = 413
  Color = clRed
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object CheckBox1: TCheckBox
    Left = 14
    Top = 24
    Width = 79
    Height = 17
    Caption = 'Start/Stop'
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 62
    Width = 394
    Height = 241
    Lines.Strings = (
      '<  VERSION 01.05.2012>'
      ''
      '* http://sourceforge.net/projects/indy10clieservr/)'
      '* no support - no help - no warrenty - no ...'
      '* feel free to post your comments on source forge'
      '* add new features ..'
      '')
    TabOrder = 1
  end
  object IdTCPServer1: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    OnConnect = IdTCPServer1Connect
    OnDisconnect = IdTCPServer1Disconnect
    OnException = IdTCPServer1Exception
    OnExecute = IdTCPServer1Execute
    Left = 16
    Top = 264
  end
end
