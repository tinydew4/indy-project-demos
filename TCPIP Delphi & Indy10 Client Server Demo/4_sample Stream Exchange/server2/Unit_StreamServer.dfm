object StreamServerForm: TStreamServerForm
  Left = 0
  Top = 0
  Caption = 'STREAM  Exchange Server Demo Indy 10.5.5'
  ClientHeight = 649
  ClientWidth = 417
  Color = clFuchsia
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
  object Image1: TImage
    Left = 8
    Top = 256
    Width = 393
    Height = 257
    Stretch = True
  end
  object Label1: TLabel
    Left = 8
    Top = 533
    Width = 98
    Height = 13
    Caption = 'Server_Receive_File'
  end
  object Label2: TLabel
    Left = 8
    Top = 581
    Width = 84
    Height = 13
    Caption = 'Server_Send_File'
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
      '<  VERSION 06.03.2012>'
      ''
      '* http://sourceforge.net/projects/indy10clieservr/)'
      '* no support - no help - no warrenty - no ...'
      '* feel free to post your comments on source forge'
      '* add new features ..'
      ''
      'Instructions:'
      '---------------'
      ''
      'Set the file edits to valid path/file names'
      'Start the server before you try to connect the client'
      'Disconnect the client by yourself  - and in time :-) ')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 331
    Top = 25
    Width = 75
    Height = 25
    Caption = 'x32/x64?'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Receive_Edit: TEdit
    Left = 8
    Top = 552
    Width = 393
    Height = 21
    TabOrder = 3
    Text = 'c:\temp\test_s_r.bmp'
    OnExit = Receive_EditExit
  end
  object Send_Edit: TEdit
    Left = 8
    Top = 600
    Width = 393
    Height = 21
    TabOrder = 4
    Text = 'c:\temp\test_s_s.bmp'
    OnExit = Send_EditExit
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
