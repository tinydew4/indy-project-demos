object StreamExchangeClientForm: TStreamExchangeClientForm
  Left = 0
  Top = 0
  Caption = 'Stream Exchange Client Demo Indy 10.5.5'
  ClientHeight = 735
  ClientWidth = 402
  Color = clLime
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 315
    Width = 386
    Height = 286
    Stretch = True
  end
  object Label1: TLabel
    Left = 8
    Top = 621
    Width = 73
    Height = 13
    Caption = 'Client send file '
  end
  object Label2: TLabel
    Left = 8
    Top = 687
    Width = 111
    Height = 13
    Caption = 'Client receive file name'
  end
  object CheckBox1: TCheckBox
    Left = 12
    Top = 23
    Width = 124
    Height = 17
    Caption = 'Connect/Disconnect'
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object Memo1: TMemo
    Left = 9
    Top = 132
    Width = 385
    Height = 177
    Lines.Strings = (
      '<  VERSION 06.03.2012>'
      ''
      '* http://sourceforge.net/projects/indy10clieservr/'
      '* no support - no help - no warrenty - no ...'
      '* feel free to post your comments on source forge'
      '* add new features ..'
      '')
    TabOrder = 1
  end
  object Button_SendStream: TButton
    Left = 8
    Top = 70
    Width = 377
    Height = 56
    Caption = 'Send Stream'
    TabOrder = 2
    OnClick = Button_SendStreamClick
  end
  object BuildButton: TButton
    Left = 316
    Top = 19
    Width = 69
    Height = 25
    Caption = 'x32/x64'
    TabOrder = 3
    OnClick = BuildButtonClick
  end
  object ClientSendFileEdit: TEdit
    Left = 8
    Top = 640
    Width = 386
    Height = 21
    TabOrder = 4
    Text = 'ClientSendFileEdit'
    OnExit = ClientSendFileEditExit
  end
  object ClientReceiveFileEdit: TEdit
    Left = 8
    Top = 706
    Width = 386
    Height = 21
    TabOrder = 5
    Text = 'ClientReceiveFileEdit'
    OnExit = ClientReceiveFileEditExit
  end
  object IdTCPClient1: TIdTCPClient
    OnDisconnected = IdTCPClient1Disconnected
    OnConnected = IdTCPClient1Connected
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 64
    Top = 248
  end
end
