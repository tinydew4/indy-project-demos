object frmMain: TfrmMain
  Left = 203
  Top = 107
  BorderStyle = bsToolWindow
  Caption = 'Basic TCP client/server demo - Command handlers'
  ClientHeight = 283
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    385
    283)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 4
    Width = 62
    Height = 24
    Caption = 'Server'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object pgeMain: TPageControl
    Left = 4
    Top = 32
    Width = 377
    Height = 203
    ActivePage = tabProcesses
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tabProcesses: TTabSheet
      Caption = 'Processes'
      object lbProcesses: TListBox
        Left = 0
        Top = 0
        Width = 369
        Height = 175
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object tabMain: TTabSheet
      Caption = 'Settings'
      ImageIndex = 1
      object Label2: TLabel
        Left = 4
        Top = 8
        Width = 51
        Height = 13
        Caption = 'Bind to IPs'
      end
      object Label3: TLabel
        Left = 120
        Top = 8
        Width = 54
        Height = 13
        Caption = 'Bind to port'
      end
      object Label4: TLabel
        Left = 120
        Top = 64
        Width = 118
        Height = 13
        Caption = 'Select port from stack list'
      end
      object lbIPs: TCheckListBox
        Left = 4
        Top = 24
        Width = 109
        Height = 133
        ItemHeight = 13
        TabOrder = 0
      end
      object cboPorts: TComboBox
        Left = 120
        Top = 80
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = cboPortsChange
      end
      object edtPort: TEdit
        Left = 120
        Top = 24
        Width = 65
        Height = 21
        TabOrder = 2
        Text = '9099'
      end
    end
  end
  object btnStartServer: TButton
    Left = 4
    Top = 238
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Start server'
    TabOrder = 1
    OnClick = btnStartServerClick
  end
  object btnStopServer: TButton
    Left = 81
    Top = 238
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'S&top server'
    TabOrder = 2
    OnClick = btnStopServerClick
  end
  object btnExit: TButton
    Left = 306
    Top = 238
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'E&xit'
    TabOrder = 3
    OnClick = btnExitClick
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 264
    Width = 385
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = 'Server stopped'
  end
  object btnClearMessages: TButton
    Left = 158
    Top = 238
    Width = 90
    Height = 25
    Caption = 'Clear messages'
    TabOrder = 5
    OnClick = btnClearMessagesClick
  end
  object IdTCPServer: TIdTCPServer
    Bindings = <
      item
        IP = '0.0.0.0'
        Port = 7
      end
      item
        IP = '192.168.226.1'
        Port = 11
      end
      item
        IP = '192.168.157.1'
        Port = 20
      end>
    CommandHandlers = <
      item
        CmdDelimiter = ' '
        Command = 'TIME'
        Disconnect = False
        Name = 'chTime'
        OnCommand = IdTCPServerchTimeCommand
        ParamDelimiter = ' '
        ReplyExceptionCode = 0
        ReplyNormal.NumericCode = 0
        Tag = 0
      end
      item
        CmdDelimiter = ' '
        Command = 'DATE'
        Disconnect = False
        Name = 'chDate'
        OnCommand = IdTCPServerchDateCommand
        ParamDelimiter = ' '
        ReplyExceptionCode = 0
        ReplyNormal.NumericCode = 0
        Tag = 0
      end
      item
        CmdDelimiter = ' '
        Command = 'TICKCOUNT'
        Disconnect = False
        Name = 'chTickCount'
        OnCommand = IdTCPServerchTickCountCommand
        ParamDelimiter = ' '
        ReplyExceptionCode = 0
        ReplyNormal.NumericCode = 0
        Tag = 0
      end
      item
        CmdDelimiter = ' '
        Command = 'QUIT'
        Disconnect = False
        Name = 'chQuit'
        OnCommand = IdTCPServerchQuitCommand
        ParamDelimiter = ' '
        ReplyExceptionCode = 0
        ReplyNormal.NumericCode = 0
        Tag = 0
      end>
    DefaultPort = 0
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = IdTCPServerConnect
    OnNoCommandHandler = IdTCPServerNoCommandHandler
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    Left = 348
    Top = 4
  end
end
