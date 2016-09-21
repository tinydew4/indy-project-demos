object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Record Exchange Server Demo Indy 10.5.5'
  ClientHeight = 241
  ClientWidth = 414
  Color = clRed
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object CheckBox1: TCheckBox
    Left = 16
    Top = 24
    Width = 153
    Height = 17
    Caption = 'Start server/ Stop server'
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 56
    Width = 398
    Height = 177
    Lines.Strings = (
      '<  VERSION 06.03.2012>'
      ''
      '* http://sourceforge.net/projects/indy10clieservr/)'
      '* no support - no help - no warrenty - no ...'
      '* feel free to post your comments on source forge'
      '* add new features ..'
      ''
      'GENERIC RECORD TYPE EXCHANGE VERSION')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 296
    Top = 25
    Width = 75
    Height = 25
    Caption = 'x32/x64?'
    TabOrder = 2
    OnClick = Button1Click
  end
  object IdTCPServer1: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    OnConnect = IdTCPServer1Connect
    OnDisconnect = IdTCPServer1Disconnect
    OnExecute = IdTCPServer1Execute
    Left = 96
    Top = 176
  end
end
