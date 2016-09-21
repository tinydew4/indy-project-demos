object IndyClientMainForm: TIndyClientMainForm
  Left = 0
  Top = 0
  Caption = 'Indy 10 TCP Client'
  ClientHeight = 702
  ClientWidth = 589
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 177
    Top = 0
    Height = 676
    ExplicitLeft = 200
    ExplicitTop = 200
    ExplicitHeight = 100
  end
  object MainStatusBar: TStatusBar
    Left = 0
    Top = 676
    Width = 589
    Height = 26
    Panels = <>
    ParentShowHint = False
    ShowHint = True
    SimplePanel = True
    SimpleText = 'Hello !!'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 177
    Height = 676
    Align = alLeft
    Caption = 'Panel1'
    Color = clLime
    ParentBackground = False
    TabOrder = 1
    object Label1: TLabel
      Left = 17
      Top = 15
      Width = 46
      Height = 13
      Caption = 'IP Adress'
    end
    object Label2: TLabel
      Left = 17
      Top = 183
      Width = 20
      Height = 13
      Caption = 'Port'
    end
    object LEDShape: TShape
      Left = 17
      Top = 409
      Width = 121
      Height = 80
    end
    object ClientImage: TImage
      Left = 17
      Top = 528
      Width = 121
      Height = 121
    end
    object IPListCheckListBox: TCheckListBox
      Left = 17
      Top = 34
      Width = 121
      Height = 143
      ItemHeight = 13
      TabOrder = 0
      OnClick = IPListCheckListBoxClick
    end
    object PortEdit: TEdit
      Left = 17
      Top = 202
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '6000'
    end
    object SetComunicationParameterButton: TButton
      Left = 17
      Top = 250
      Width = 121
      Height = 102
      Caption = 'Set Comunication Parameter'
      TabOrder = 2
      WordWrap = True
      OnClick = SetComunicationParameterButtonClick
    end
    object ClientActiveCheckBox: TCheckBox
      Left = 17
      Top = 386
      Width = 178
      Height = 17
      Caption = 'Activate TCP Client '
      TabOrder = 3
      OnClick = ClientActiveCheckBoxClick
    end
  end
  object Panel2: TPanel
    Left = 180
    Top = 0
    Width = 409
    Height = 676
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 2
    object Label3: TLabel
      Left = 32
      Top = 128
      Width = 246
      Height = 13
      Caption = 'Enter Text to send to the server with CMD#0 here '
    end
    object ClientExecuteButton: TButton
      Left = 32
      Top = 34
      Width = 329
      Height = 25
      Caption = 'Execute Client Command'
      TabOrder = 0
      OnClick = ClientExecuteButtonClick
    end
    object CommandComboBox: TComboBox
      Left = 32
      Top = 80
      Width = 329
      Height = 21
      TabOrder = 1
      Text = 'CommandComboBox'
      Items.Strings = (
        '#0 send a string to the server'
        
          '#1 get SERVER date & time (send record (Type A) and get a record' +
          ' from the server (Type A ))'
        
          '#2 get SERVER INFO  (send record (Type A) and get a record from ' +
          'the server (Type B ))'
        
          '#3 send SERVER COMAND  (send record (Type A)  - no reply by the ' +
          'server)'
        '#4 get a file from the server')
    end
    object SendTextEdit: TEdit
      Left = 32
      Top = 156
      Width = 329
      Height = 21
      TabOrder = 2
      Text = 'SendTextEdit'
    end
    object Memo1: TMemo
      Left = 32
      Top = 224
      Width = 329
      Height = 409
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
      TabOrder = 3
    end
  end
  object IdIPWatch: TIdIPWatch
    Active = False
    HistoryFilename = 'iphist.dat'
    Left = 16
    Top = 312
  end
  object MyIdTCPClient: TIdTCPClient
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 144
    Top = 304
  end
  object MainMenu1: TMainMenu
    Left = 432
    object File1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object About1: TMenuItem
      Caption = 'About'
      object BUILDINFO1: TMenuItem
        Caption = 'BUILD INFO'
        OnClick = BUILDINFO1Click
      end
    end
  end
end
