object RetroUIForm: TRetroUIForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #36890#20449#31649#29702#12484#12540#12523' Ver 1.00'
  ClientHeight = 680
  ClientWidth = 640
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Yu Gothic UI'
  Font.Style = []
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object lblLog: TLabel
    Left = 24
    Top = 382
    Width = 45
    Height = 15
    Caption = #36865#20449#12525#12464':'
  end
  object lblProgress: TLabel
    Left = 24
    Top = 528
    Width = 51
    Height = 15
    Caption = #20449#21495#29366#24907':'
  end
  object pnlTitle: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 76
    Align = alTop
    BevelOuter = bvNone
    Color = 16250871
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 24
      Top = 16
      Width = 125
      Height = 28
      Caption = #36890#20449#31649#29702#12484#12540#12523
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Yu Gothic UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblVersion: TLabel
      Left = 26
      Top = 46
      Width = 40
      Height = 15
      Caption = 'Ver 1.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -12
      Font.Name = 'Yu Gothic UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object grpHoushiki: TGroupBox
    Left = 24
    Top = 96
    Width = 280
    Height = 148
    Caption = #36890#20449#26041#24335
    TabOrder = 1
    object rbSerial: TRadioButton
      Left = 20
      Top = 30
      Width = 240
      Height = 17
      Caption = #12471#12522#12450#12523#12509#12540#12488'(&S)'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbMethodClick
    end
    object rbModem: TRadioButton
      Left = 20
      Top = 66
      Width = 240
      Height = 17
      Caption = #12514#12487#12512'(&M)'
      TabOrder = 1
      OnClick = rbMethodClick
    end
    object rbLan: TRadioButton
      Left = 20
      Top = 102
      Width = 240
      Height = 17
      Caption = 'LAN '#25509#32154'(&L)'
      TabOrder = 2
      OnClick = rbMethodClick
    end
  end
  object grpPort: TGroupBox
    Left = 320
    Top = 96
    Width = 296
    Height = 148
    Caption = #12509#12540#12488#35443#32048
    TabOrder = 2
    object lblPort: TLabel
      Left = 20
      Top = 34
      Width = 29
      Height = 15
      Caption = #12509#12540#12488':'
    end
    object lblBaud: TLabel
      Left = 20
      Top = 70
      Width = 27
      Height = 15
      Caption = #36895#24230':'
    end
    object edtPort: TEdit
      Left = 110
      Top = 30
      Width = 100
      Height = 23
      TabOrder = 0
      Text = 'COM1'
    end
    object cmbBaud: TComboBox
      Left = 110
      Top = 66
      Width = 150
      Height = 23
      Style = csDropDownList
      ItemIndex = 2
      TabOrder = 1
      Text = '38400'
      Items.Strings = (
        '9600'
        '19200'
        '38400'
        '115200')
    end
    object chkParity: TCheckBox
      Left = 20
      Top = 108
      Width = 250
      Height = 17
      Caption = #12497#12522#12486#12451#12481#12455#12483#12463#12434#34892#12358
      TabOrder = 2
    end
  end
  object grpOption: TGroupBox
    Left = 24
    Top = 260
    Width = 592
    Height = 104
    Caption = #12458#12503#12471#12519#12531#35373#23450
    TabOrder = 3
    object chkAuto: TCheckBox
      Left = 20
      Top = 28
      Width = 260
      Height = 17
      Caption = #33258#21205#30340#12395#20877#25509#32154#12377#12427
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object chkLog: TCheckBox
      Left = 20
      Top = 60
      Width = 150
      Height = 17
      Caption = #12525#12464#12434#20445#23384#12377#12427
      TabOrder = 1
      OnClick = chkLogClick
    end
    object btnOpenLog: TButton
      Left = 175
      Top = 56
      Width = 75
      Height = 24
      Caption = #38283#12367'(&O)'
      TabOrder = 4
      Visible = False
      OnClick = btnOpenLogClick
    end
    object chkWarn: TCheckBox
      Left = 310
      Top = 28
      Width = 260
      Height = 17
      Caption = #35686#21578#38899#12434#40180#12425#12377
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object chkFull: TCheckBox
      Left = 310
      Top = 60
      Width = 260
      Height = 17
      Caption = #12501#12523#12473#12463#12522#12540#12531#34920#31034#12395#12377#12427
      TabOrder = 3
      OnClick = chkFullClick
    end
  end
  object lstLog: TListBox
    Left = 24
    Top = 402
    Width = 592
    Height = 112
    Color = 2499877
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 13421772
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    TabOrder = 4
  end
  object prgStatus: TProgressBar
    Left = 24
    Top = 548
    Width = 592
    Height = 24
    Position = 0
    BarColor = clBackground
    TabOrder = 5
  end
  object statusBar: TStatusBar
    Left = 0
    Top = 657
    Width = 640
    Height = 23
    Panels = <
      item
        Bevel = pbNone
        Text = #28310#20633#23436#20102
        Width = 220
      end
      item
        Bevel = pbNone
        Text = #36890#20449#29366#24907': '#20572#27490#20013
        Width = 220
      end
      item
        Bevel = pbNone
        Text = #32076#36942#26178#38291' 00:00:00'
        Width = 200
      end>
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 597
    Width = 640
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    Color = 16250871
    ParentBackground = False
    TabOrder = 6
    object btnHelp: TButton
      Left = 24
      Top = 14
      Width = 110
      Height = 32
      Caption = #12504#12523#12503'(&H)'
      TabOrder = 0
      OnClick = btnHelpClick
    end
    object btnStop: TButton
      Left = 262
      Top = 14
      Width = 110
      Height = 32
      Caption = #20013#27490'(&C)'
      Enabled = False
      TabOrder = 1
      OnClick = btnStopClick
    end
    object btnExec: TButton
      Left = 384
      Top = 14
      Width = 110
      Height = 32
      Caption = #23455#34892'(&E)'
      Default = True
      TabOrder = 2
      OnClick = btnExecClick
    end
    object btnClose: TButton
      Left = 506
      Top = 14
      Width = 110
      Height = 32
      Cancel = True
      Caption = #38281#12376#12427'(&X)'
      TabOrder = 3
      OnClick = btnCloseClick
    end
  end
  object tmrSim: TTimer
    Enabled = False
    Interval = 800
    OnTimer = tmrSimTimer
    Left = 40
    Top = 24
  end
end