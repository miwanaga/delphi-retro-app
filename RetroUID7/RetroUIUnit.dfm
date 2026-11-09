object RetroUIForm: TRetroUIForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #36890#20449#31649#29702' '#65410#65392#65433'  Ver 1.00 (Full)'
  ClientHeight = 406
  ClientWidth = 400
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS UI Gothic'
  Font.Style = []
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 12
  object bvlLog: TBevel
    Left = 4
    Top = 208
    Width = 392
    Height = 136
    Shape = bsFrame
  end
  object lblLog: TLabel
    Left = 10
    Top = 212
    Width = 42
    Height = 12
    Caption = #36865#20449#65435#65400#65438':'
  end
  object lblProgress: TLabel
    Left = 10
    Top = 308
    Width = 50
    Height = 12
    Caption = #20449#21495#29366#27841':'
  end
  object pnlTitle: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 26
    Align = alTop
    BevelInner = bvLowered
    Color = clNavy
        TabOrder = 0
    object lblTitle: TLabel
      Left = 8
      Top = 5
      Width = 88
      Height = 12
      Caption = #9632' '#36890#20449#30435#29702' '#9632
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -12
      Font.Name = 'MS UI Gothic'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object grpHoushiki: TGroupBox
    Left = 8
    Top = 32
    Width = 182
    Height = 92
    Caption = #36890#20449#26041#24335
    Color = clAqua
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'MS UI Gothic'
    Font.Style = [fsBold]
        ParentColor = False
    ParentFont = False
    TabOrder = 1
    object rbSerial: TRadioButton
      Left = 12
      Top = 20
      Width = 160
      Height = 17
      Caption = #65404#65432#65393#65433' '#65422#65439#65392#65412'(&S)'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbMethodClick
    end
    object rbModem: TRadioButton
      Left = 12
      Top = 42
      Width = 160
      Height = 17
      Caption = #65427#65411#65438#65425'(&M)'
      TabOrder = 1
      OnClick = rbMethodClick
    end
    object rbLan: TRadioButton
      Left = 12
      Top = 64
      Width = 160
      Height = 17
      Caption = 'LAN '#25509#32154'(&L)'
      TabOrder = 2
      OnClick = rbMethodClick
    end
  end
  object grpPort: TGroupBox
    Left = 196
    Top = 32
    Width = 196
    Height = 92
    Caption = #65422#65439#65392#65412' '#35443#32048
    Color = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -12
    Font.Name = 'MS UI Gothic'
    Font.Style = [fsBold]
        ParentColor = False
    ParentFont = False
    TabOrder = 2
    object lblPort: TLabel
      Left = 12
      Top = 22
      Width = 32
      Height = 12
      Caption = #65422#65439#65392#65412':'
    end
    object lblBaud: TLabel
      Left = 12
      Top = 52
      Width = 29
      Height = 12
      Caption = #36895#24230':'
    end
    object edtPort: TEdit
      Left = 66
      Top = 19
      Width = 120
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS UI Gothic'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'COM1'
    end
    object cmbBaud: TComboBox
      Left = 66
      Top = 45
      Width = 120
      Height = 20
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS UI Gothic'
      Font.Style = []
      ItemIndex = 2
      ParentFont = False
      TabOrder = 1
      Text = '38400'
      Items.Strings = (
        '9600'
        '19200'
        '38400'
        '115200')
    end
    object chkParity: TCheckBox
      Left = 12
      Top = 70
      Width = 170
      Height = 17
      Caption = #65418#65439#65432#65411#65384' '#65409#65386#65391#65400#12354#12426
      TabOrder = 2
    end
  end
  object grpOption: TGroupBox
    Left = 8
    Top = 130
    Width = 384
    Height = 78
    Caption = #65397#65420#65439#65404#65390#65437' '#35373#23450
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -12
    Font.Name = 'MS UI Gothic'
    Font.Style = [fsBold]
        ParentColor = False
    ParentFont = False
    TabOrder = 3
    object chkAuto: TCheckBox
      Left = 14
      Top = 19
      Width = 180
      Height = 17
      Caption = #33258#21205#20877#25509#32154#12377#12427
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object chkLog: TCheckBox
      Left = 12
      Top = 45
      Width = 110
      Height = 17
      Caption = #65435#65400#65438#12434#20445#23384#12377#12427
      TabOrder = 1
      OnClick = chkLogClick
    end
    object btnOpenLog: TButton
      Left = 124
      Top = 42
      Width = 58
      Height = 22
      Caption = #38283#12367'(&O)'
      TabOrder = 4
      Visible = False
      OnClick = btnOpenLogClick
    end
    object chkWarn: TCheckBox
      Left = 200
      Top = 20
      Width = 180
      Height = 17
      Caption = #35686#21578#38899#12434#40180#12425#12377
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object chkFull: TCheckBox
      Left = 200
      Top = 45
      Width = 180
      Height = 17
      Caption = #65420#65433#65405#65400#65432#65392#65437#34920#31034
      TabOrder = 3
      OnClick = chkFullClick
    end
  end
  object lstLog: TListBox
    Left = 10
    Top = 228
    Width = 380
    Height = 76
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -13
    Font.Name = 'Terminal'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 4
  end
  object prgStatus: TProgressBar
    Left = 10
    Top = 324
    Width = 380
    Height = 18
    Position = 0
    TabOrder = 5
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 350
    Width = 400
    Height = 34
    Align = alBottom
    Color = clSilver
        TabOrder = 6
    object btnExec: TButton
      Left = 8
      Top = 4
      Width = 88
      Height = 25
      Caption = #23455#34892'(&E)'
      Default = True
      TabOrder = 0
      OnClick = btnExecClick
    end
    object btnStop: TButton
      Left = 100
      Top = 4
      Width = 88
      Height = 25
      Caption = #20013#27490'(&C)'
      Enabled = False
      TabOrder = 1
      OnClick = btnStopClick
    end
    object btnHelp: TButton
      Left = 224
      Top = 4
      Width = 80
      Height = 25
      Caption = #65421#65433#65420#65439'(&H)'
      TabOrder = 2
      OnClick = btnHelpClick
    end
    object btnClose: TButton
      Left = 308
      Top = 4
      Width = 84
      Height = 25
      Cancel = True
      Caption = #38281#12376#12427'(&X)'
      TabOrder = 3
      OnClick = btnCloseClick
    end
  end
  object pnlStatus: TPanel
    Left = 0
    Top = 384
    Width = 400
    Height = 22
    Align = alBottom
    BevelOuter = bvLowered
    Color = clSilver
        TabOrder = 7
    object pnlStat1: TPanel
      Left = 2
      Top = 2
      Width = 140
      Height = 18
      Alignment = taLeftJustify
      BevelOuter = bvLowered
      Caption = ' '#65404#65438#65389#65437#65419#65438' '#24453#27231#20013
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS UI Gothic'
      Font.Style = []
            ParentFont = False
      TabOrder = 0
    end
    object pnlStat2: TPanel
      Left = 144
      Top = 2
      Width = 140
      Height = 18
      Alignment = taLeftJustify
      BevelOuter = bvLowered
      Caption = ' '#65410#65395#65404#65437':'#65411#65394#65404#65409#65389#65395
      Color = clYellow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'MS UI Gothic'
      Font.Style = []
            ParentFont = False
      TabOrder = 1
    end
    object pnlStat3: TPanel
      Left = 286
      Top = 2
      Width = 112
      Height = 18
      Alignment = taLeftJustify
      BevelOuter = bvLowered
      Caption = ' 00:00:00'
      Color = clAqua
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'MS UI Gothic'
      Font.Style = []
            ParentFont = False
      TabOrder = 2
    end
  end
  object tmrSim: TTimer
    Enabled = False
    Interval = 800
    OnTimer = tmrSimTimer
    Left = 344
    Top = 136
  end
end
