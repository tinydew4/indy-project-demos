object Form1: TForm1
  Left = 415
  Top = 119
  Width = 458
  Height = 428
  Caption = 'Sample SSL Client (Indy 10)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 450
    Height = 41
    Align = alTop
    TabOrder = 0
    DesignSize = (
      450
      41)
    object ledConnected: TShape
      Left = 270
      Top = 18
      Width = 20
      Height = 10
      Brush.Color = clRed
    end
    object Label1: TLabel
      Left = 15
      Top = 15
      Width = 29
      Height = 15
      Caption = 'Host:'
    end
    object btnExit: TSpeedButton
      Left = 399
      Top = 11
      Width = 41
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'E&xit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btnExitClick
    end
    object btnConnect: TButton
      Left = 173
      Top = 11
      Width = 75
      Height = 23
      Caption = 'Connect'
      TabOrder = 0
      OnClick = btnConnectClick
    end
    object edtHostAddr: TEdit
      Left = 45
      Top = 12
      Width = 121
      Height = 23
      TabOrder = 1
      Text = '127.0.0.1'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 450
    Height = 41
    Align = alTop
    BorderWidth = 12
    TabOrder = 1
    DesignSize = (
      450
      41)
    object Edit1: TEdit
      Left = 10
      Top = 9
      Width = 431
      Height = 23
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 0
      OnKeyPress = Edit1KeyPress
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 82
    Width = 450
    Height = 319
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 8
    TabOrder = 2
    object Memo1: TMemo
      Left = 10
      Top = 10
      Width = 430
      Height = 299
      Align = alClient
      BorderStyle = bsNone
      ReadOnly = True
      TabOrder = 0
    end
  end
  object IdTCPClient: TIdTCPClient
    IOHandler = IdSSLIOHandlerSocketOpenSSL
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 3000
    ReadTimeout = 0
    Left = 304
    Top = 8
  end
  object IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL
    Destination = ':3000'
    MaxLineAction = maException
    Port = 3000
    DefaultPort = 0
    SSLOptions.Method = sslvTLSv1
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 344
    Top = 8
  end
end
