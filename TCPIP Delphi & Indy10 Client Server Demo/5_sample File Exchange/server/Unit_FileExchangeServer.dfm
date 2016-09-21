object FileExchangeServerForm: TFileExchangeServerForm
  Left = 0
  Top = 0
  Caption = 'FILE Exchange Server Demo Indy 10.5.5'
  ClientHeight = 357
  ClientWidth = 417
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
  object Label1: TLabel
    Left = 8
    Top = 256
    Width = 130
    Height = 13
    Caption = 'Save File from Client as ... '
  end
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
      'FEBRUARY  12-02-2011')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 280
    Top = 8
    Width = 75
    Height = 25
    Caption = 'x32/x64?'
    TabOrder = 2
    OnClick = Button1Click
  end
  object SaveFileEdit: TEdit
    Left = 8
    Top = 288
    Width = 398
    Height = 21
    TabOrder = 3
    Text = 'c:\temp\save_file_from_client.txt'
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
