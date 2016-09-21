object ServerMainForm: TServerMainForm
  Left = 0
  Top = 0
  Caption = 'Indy 10 TCP SERVER'
  ClientHeight = 672
  ClientWidth = 668
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 217
    Top = 0
    Height = 653
    ExplicitLeft = 232
    ExplicitTop = 176
    ExplicitHeight = 100
  end
  object MainStatusBar: TStatusBar
    Left = 0
    Top = 653
    Width = 668
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 217
    Height = 653
    Align = alLeft
    Color = clPurple
    ParentBackground = False
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 45
      Height = 13
      Caption = 'Server IP'
    end
    object Label2: TLabel
      Left = 24
      Top = 62
      Width = 55
      Height = 13
      Caption = 'Server Port'
    end
    object LEDShape: TShape
      Left = 24
      Top = 414
      Width = 129
      Height = 107
    end
    object ServerImage: TImage
      Left = 24
      Top = 527
      Width = 129
      Height = 120
    end
    object IPEdit: TEdit
      Left = 24
      Top = 35
      Width = 129
      Height = 21
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object PortEdit: TEdit
      Left = 24
      Top = 81
      Width = 129
      Height = 21
      TabOrder = 1
      Text = '6000'
    end
    object ServerBindingsButton: TButton
      Left = 24
      Top = 120
      Width = 129
      Height = 25
      Caption = 'Set Server Bindings'
      TabOrder = 2
      OnClick = ServerBindingsButtonClick
    end
    object IPListCheckListBox: TCheckListBox
      Left = 24
      Top = 151
      Width = 129
      Height = 194
      ItemHeight = 13
      TabOrder = 3
    end
    object ServerActiveCheckBox: TCheckBox
      Left = 24
      Top = 382
      Width = 177
      Height = 17
      Caption = 'ServerActive '
      TabOrder = 4
      OnClick = ServerActiveCheckBoxClick
    end
  end
  object Panel2: TPanel
    Left = 220
    Top = 0
    Width = 448
    Height = 653
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 2
    object Label3: TLabel
      Left = 6
      Top = 16
      Width = 94
      Height = 13
      Caption = 'version 11.04.2012'
    end
    object Label4: TLabel
      Left = 6
      Top = 132
      Width = 58
      Height = 13
      Caption = 'Log Window'
    end
    object SendTextEdit: TEdit
      Left = 6
      Top = 81
      Width = 403
      Height = 21
      TabOrder = 0
      Text = 'SendTextEdit'
    end
    object Memo1: TMemo
      Left = 1
      Top = 168
      Width = 446
      Height = 484
      Align = alBottom
      Lines.Strings = (
        '<  VERSION 20.04.2012>'
        ''
        '* http://sourceforge.net/projects/indy10clieservr/)'
        '* no support - no help - no warrenty - no ...'
        '* feel free to post your comments on source forge'
        '* add new features ..'
        ''
        ''
        ''
        '<a  bit more complex demo - INDY TCP Client/ server>')
      TabOrder = 1
    end
  end
  object IdTCPServer: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    OnConnect = IdTCPServerConnect
    OnDisconnect = IdTCPServerDisconnect
    OnException = IdTCPServerException
    OnExecute = IdTCPServerExecute
    Left = 160
    Top = 320
  end
  object IdIPWatch: TIdIPWatch
    Active = False
    HistoryFilename = 'iphist.dat'
    Left = 160
    Top = 248
  end
  object MainMenu1: TMainMenu
    Left = 432
    Top = 16
    object File1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object About1: TMenuItem
      Caption = 'About'
      object Build1: TMenuItem
        Caption = 'Build'
        OnClick = Build1Click
      end
    end
  end
end
