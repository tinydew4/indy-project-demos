object Form1: TForm1
  Left = 193
  Top = 149
  BorderStyle = bsDialog
  Caption = 'IdSMTPServer Demo'
  ClientHeight = 276
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 48
    Width = 16
    Height = 13
    Caption = 'To:'
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 26
    Height = 13
    Caption = 'From:'
  end
  object Label3: TLabel
    Left = 8
    Top = 80
    Width = 39
    Height = 13
    Caption = 'Subject:'
  end
  object ToLabel: TLabel
    Left = 56
    Top = 48
    Width = 3
    Height = 13
  end
  object FromLabel: TLabel
    Left = 56
    Top = 64
    Width = 3
    Height = 13
  end
  object SubjectLabel: TLabel
    Left = 56
    Top = 80
    Width = 3
    Height = 13
  end
  object Label4: TLabel
    Left = 8
    Top = 237
    Width = 286
    Height = 26
    Caption = 
      'Remember to set the SMTPServer property "ReceiveMode" to the app' +
      'ropriate type before compiling'
    WordWrap = True
  end
  object Memo1: TMemo
    Left = 8
    Top = 96
    Width = 361
    Height = 137
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnServerOn: TButton
    Left = 242
    Top = 7
    Width = 65
    Height = 25
    Caption = 'Server on'
    TabOrder = 1
    OnClick = btnServerOnClick
  end
  object btnServerOff: TButton
    Left = 307
    Top = 7
    Width = 65
    Height = 25
    Caption = 'Server off'
    Enabled = False
    TabOrder = 2
    OnClick = btnServerOffClick
  end
  object IdSMTPServer1: TIdSMTPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 25
    Greeting.NumericCode = 220
    Greeting.Text.Strings = (
      'Welcome to the INDY SMTP Server')
    Greeting.TextCode = '220'
    MaxConnectionReply.NumericCode = 0
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 500
    ReplyUnknownCommand.Text.Strings = (
      'Syntax Error')
    ReplyUnknownCommand.TextCode = '500'
    AuthMode = False
    Messages.NoopReply = 'Ok'
    Messages.RSetReply = 'Ok'
    Messages.QuitReply = 'Signing Off'
    Messages.ErrorReply = 'Syntax Error - Command not understood: %s'
    Messages.XServer = 'Indy SMTP Server'
    Messages.ReceivedHeader = 'by DNSName [127.0.0.1] running Indy SMTP'
    Messages.SyntaxErrorReply = 'Syntax Error - Command not understood: %s'
    Messages.Greeting.EHLONotSupported = 'Command Not Recognised'
    Messages.Greeting.HelloReply = 'Hello %s'
    Messages.Greeting.NoHello = 'Polite people say HELO'
    Messages.Greeting.AuthFailed = 'Authentication Failed'
    Messages.Greeting.EHLOReply.Strings = (
      '250-w2ksrv'
      '250-AUTH LOGIN'
      '250 HELP')
    Messages.RcpReplies.AddressOkReply = '%s Address Okay'
    Messages.RcpReplies.AddressErrorReply = '%s Address Error'
    Messages.RcpReplies.AddressWillForwardReply = 'User not local, Will forward'
    Messages.DataReplies.StartDataReply = 'Start mail input; end with <CRLF>.<CRLF>'
    Messages.DataReplies.EndDataReply = 'Ok'
    OnReceiveRaw = IdSMTPServer1ReceiveRaw
    OnReceiveMessage = IdSMTPServer1ReceiveMessage
    OnReceiveMessageParsed = IdSMTPServer1ReceiveMessageParsed
    ReceiveMode = rmMessageParsed
    AllowEHLO = False
    NoDecode = False
    NoEncode = False
    OnCommandRCPT = IdSMTPServer1CommandRCPT
    OnCommandMAIL = IdSMTPServer1CommandMAIL
    RawStreamType = stFileStream
    OnCommandHELP = IdSMTPServer1CommandHELP
    OnCommandSOML = IdSMTPServer1CommandSOML
    OnCommandSEND = IdSMTPServer1CommandSEND
    OnCommandSAML = IdSMTPServer1CommandSAML
    OnCommandVRFY = IdSMTPServer1CommandVRFY
    OnCommandTURN = IdSMTPServer1CommandTURN
    Left = 6
    Top = 2
  end
end
