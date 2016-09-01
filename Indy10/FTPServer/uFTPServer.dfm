object Form1: TForm1
  Left = 287
  Top = 249
  Width = 311
  Height = 252
  Caption = 'Indy FTP Server'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnClose: TButton
    Left = 116
    Top = 188
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = btnCloseClick
  end
  object moNotes: TMemo
    Left = 8
    Top = 8
    Width = 289
    Height = 177
    Color = clBtnFace
    Lines.Strings = (
      'This is a demo for the IdFTPServer component.'
      ''
      'The FTP server is already active ; fire up an FTP client and '
      'connection to port 21.'
      ''
      'The server will accept any combination of usernames / '
      'passwords.')
    ReadOnly = True
    TabOrder = 1
  end
  object IdFTPServer1: TIdFTPServer
    Active = True
    Bindings = <>
    DefaultPort = 21
    CommandHandlers = <>
    ExceptionReply.Code = '500'
    ExceptionReply.Text.Strings = (
      'Unknown Internal Error')
    Greeting.Code = '220'
    Greeting.Text.Strings = (
      'Indy FTP Server ready.')
    HelpReply.Text.Strings = (
      'Help follows')
    MaxConnectionReply.Code = '300'
    MaxConnectionReply.Text.Strings = (
      'Too many connections. Try again later.')
    ReplyTexts = <>
    ReplyUnknownCommand.Code = '500'
    ReplyUnknownCommand.Text.Strings = (
      'Syntax error, command unrecognized.')
    AllowAnonymousLogin = True
    AnonymousAccounts.Strings = (
      'anonymous'
      'ftp'
      'guest')
    AnonymousPassStrictCheck = False
    SystemType = 'WIN32'
    OnChangeDirectory = IdFTPServer1ChangeDirectory
    OnGetFileSize = IdFTPServer1GetFileSize
    OnUserLogin = IdFTPServer1UserLogin
    OnListDirectory = IdFTPServer1ListDirectory
    OnDeleteFile = IdFTPServer1DeleteFile
    OnRetrieveFile = IdFTPServer1RetrieveFile
    OnStoreFile = IdFTPServer1StoreFile
    OnMakeDirectory = IdFTPServer1MakeDirectory
    OnRemoveDirectory = IdFTPServer1RemoveDirectory
    SITECommands = <>
    MLSDFacts = []
    ReplyUnknownSITCommand.Code = '500'
    ReplyUnknownSITCommand.Text.Strings = (
      'Invalid SITE command.')
    Left = 8
    Top = 92
  end
end
