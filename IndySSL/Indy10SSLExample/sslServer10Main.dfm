object Form1: TForm1
  Left = 501
  Top = 87
  Width = 482
  Height = 430
  Caption = 'Simple SSL Server (Indy 10)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 474
    Height = 41
    Align = alTop
    TabOrder = 0
    DesignSize = (
      474
      41)
    object btnExit: TSpeedButton
      Left = 428
      Top = 8
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
    object ledListening: TShape
      Left = 80
      Top = 15
      Width = 20
      Height = 8
      Brush.Color = clRed
    end
    object Label1: TLabel
      Left = 15
      Top = 11
      Width = 54
      Height = 15
      Caption = 'Listening:'
    end
    object Label2: TLabel
      Left = 140
      Top = 11
      Width = 73
      Height = 15
      Caption = 'Connections:'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 474
    Height = 362
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 5
    TabOrder = 1
    object Memo1: TMemo
      Left = 7
      Top = 7
      Width = 460
      Height = 348
      Align = alClient
      BorderStyle = bsNone
      ReadOnly = True
      TabOrder = 0
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 311
    Top = 87
  end
  object IdTCPServer: TIdTCPServer
    Bindings = <>
    DefaultPort = 3000
    IOHandler = IdServerIOHandlerSSLOpenSSL
    OnConnect = IdTCPServerConnect
    OnExecute = IdTCPServerExecute
    Left = 200
    Top = 89
  end
  object IdServerIOHandlerSSLOpenSSL: TIdServerIOHandlerSSLOpenSSL
    SSLOptions.Method = sslvTLSv1
    SSLOptions.Mode = sslmServer
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    OnGetPassword = IdServerIOHandlerSSLOpenSSLGetPassword
    Left = 256
    Top = 89
  end
end
