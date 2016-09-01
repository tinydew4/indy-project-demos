object DNS_Main: TDNS_Main
  Left = 563
  Top = 116
  Width = 257
  Height = 443
  Caption = 'DNS Resolver'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 249
    Height = 51
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 249
      Height = 13
      Align = alTop
      Caption = 'Please input the DN or IP address to query'
    end
    object Ed_Query: TEdit
      Left = 2
      Top = 26
      Width = 169
      Height = 21
      ImeName = '?? (??) - ???'
      TabOrder = 0
    end
    object Btn_Query: TButton
      Left = 182
      Top = 26
      Width = 57
      Height = 23
      Caption = '&Query'
      TabOrder = 1
      OnClick = Btn_QueryClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 51
    Width = 249
    Height = 158
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label2: TLabel
      Left = 0
      Top = 0
      Width = 249
      Height = 13
      Align = alTop
      Caption = 'Please select the record type you want to get:'
    end
    object LB_QueryType: TListBox
      Left = 0
      Top = 20
      Width = 249
      Height = 138
      Align = alBottom
      ImeName = '?? (??) - ???'
      ItemHeight = 13
      Items.Strings = (
        'Query IP address (A Record)'
        'Query Name Server (NS Record)'
        'Query Alias (CName Record'
        'Query SOA Record (SOA Record)'
        'Query Machine informaiton (HINFO Record)'
        'Query Text record (TXT Record)'
        'Query Mail Exchange Server (MX Record)'
        'Query Mail server information (MINFO Record)'
        'Query Mail group (MG Record)'
        'Query Mail server rename(MRRecord)')
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 209
    Width = 249
    Height = 18
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label3: TLabel
      Left = 0
      Top = 0
      Width = 249
      Height = 13
      Align = alTop
      Caption = 'Query Result:'
    end
  end
  object Memo_Result: TMemo
    Left = 0
    Top = 227
    Width = 249
    Height = 162
    Align = alClient
    ImeName = '?? (??) - ???'
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object MainMenu1: TMainMenu
    Left = 42
    Top = 254
    object S1: TMenuItem
      Caption = '&System'
      object MItem_Config: TMenuItem
        Caption = '&Configuration'
        OnClick = MItem_ConfigClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MItem_Exit: TMenuItem
        Caption = 'E&xit'
        OnClick = MItem_ExitClick
      end
    end
    object About1: TMenuItem
      Caption = '&Help'
      object About2: TMenuItem
        Caption = '&About DNS Resolver'
        OnClick = About2Click
      end
    end
  end
end
