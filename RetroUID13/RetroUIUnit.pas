unit RetroUIUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Winapi.ShellAPI, System.UITypes;

type
  TRetroUIForm = class(TForm)
    pnlTitle: TPanel;
    lblTitle: TLabel;
    grpHoushiki: TGroupBox;
    rbSerial: TRadioButton;
    rbModem: TRadioButton;
    rbLan: TRadioButton;
    grpPort: TGroupBox;
    lblPort: TLabel;
    edtPort: TEdit;
    lblBaud: TLabel;
    cmbBaud: TComboBox;
    chkParity: TCheckBox;
    grpOption: TGroupBox;
    chkAuto: TCheckBox;
    chkLog: TCheckBox;
    btnOpenLog: TButton;
    chkWarn: TCheckBox;
    chkFull: TCheckBox;
    bvlLog: TBevel;
    lblLog: TLabel;
    lstLog: TListBox;
    lblProgress: TLabel;
    prgStatus: TProgressBar;
    pnlButtons: TPanel;
    btnExec: TButton;
    btnStop: TButton;
    btnHelp: TButton;
    btnClose: TButton;
    pnlStatus: TPanel;
    pnlStat1: TPanel;
    pnlStat2: TPanel;
    pnlStat3: TPanel;
    tmrSim: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure btnExecClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure chkLogClick(Sender: TObject);
    procedure btnOpenLogClick(Sender: TObject);
    procedure chkFullClick(Sender: TObject);
    procedure rbMethodClick(Sender: TObject);
    procedure tmrSimTimer(Sender: TObject);
  private
    FRunning: Boolean;
    FSeconds: Integer;
    FAllLogs: TStringList;
    FStepIndex: Integer;
    FDisconnectCountdown: Integer;
    procedure AddLog(const S: string);
    procedure UpdatePortSettings;
    procedure UpdateControlsState;
    procedure PlayAlertSound;
    procedure StopSimulation(const Reason: string);
    function GetLogFilePath: string;
    procedure SaveLogToFile;
  public
    { Public 宣言 }
  end;

var
  RetroUIForm: TRetroUIForm;

implementation

{$R *.dfm}

procedure TRetroUIForm.FormCreate(Sender: TObject);
begin
  FAllLogs := TStringList.Create;
  FRunning := False;
  FSeconds := 0;
  FStepIndex := 0;
  FDisconnectCountdown := 0;

  lstLog.Clear;
  AddLog('> ・ｼ・ｽ・・ｾ・・ｼ・橸ｽｭ・晢ｾ具ｾ・・ｶ・晢ｾ假ｽｮ・ｳ.');
  UpdatePortSettings;
  UpdateControlsState;
end;

procedure TRetroUIForm.FormDestroy(Sender: TObject);
begin
  FAllLogs.Free;
end;

function TRetroUIForm.GetLogFilePath: string;
begin
  Result := ExtractFilePath(Application.ExeName) + 'retroui_d13.log';
end;

procedure TRetroUIForm.SaveLogToFile;
begin
  try
    FAllLogs.SaveToFile(GetLogFilePath, TEncoding.UTF8);
  except
    // ignore file write errors in demo
  end;
end;

procedure TRetroUIForm.PlayAlertSound;
begin
  if chkWarn.Checked then
    MessageBeep(MB_ICONWARNING);
end;

procedure TRetroUIForm.AddLog(const S: string);
const
  MaxVisibleLines = 4;
begin
  FAllLogs.Add(FormatDateTime('[hh:nn:ss] ', Now) + S);
  if chkLog.Checked then
    SaveLogToFile;

  while lstLog.Items.Count >= MaxVisibleLines do
    lstLog.Items.Delete(0);

  lstLog.Items.Add(S);
  lstLog.ItemIndex := -1;
end;

procedure TRetroUIForm.UpdatePortSettings;
begin
  if rbSerial.Checked then
  begin
    edtPort.Text := 'COM1';
    cmbBaud.Enabled := True;
    chkParity.Enabled := True;
    if cmbBaud.ItemIndex < 0 then
      cmbBaud.ItemIndex := 2;
  end
  else if rbModem.Checked then
  begin
    edtPort.Text := 'COM3 (MODEM)';
    cmbBaud.Enabled := True;
    chkParity.Enabled := True;
  end
  else if rbLan.Checked then
  begin
    edtPort.Text := '192.168.1.10:8080';
    cmbBaud.Enabled := False;
    chkParity.Enabled := False;
  end;
end;

procedure TRetroUIForm.UpdateControlsState;
begin
  btnExec.Enabled := not FRunning;
  btnStop.Enabled := FRunning;

  grpHoushiki.Enabled := not FRunning;
  grpPort.Enabled := not FRunning;

  if not FRunning then
  begin
    prgStatus.Position := 0;
    pnlStat1.Caption := ' ・ｽ・・ｽｰ・€・ｽ 蠕・ｩ滉ｸｭ';
    pnlStat1.Color := clBtnFace;
    pnlStat2.Caption := ' ・難ｽｰ・・ｾ・・ｱ・ｲ・・ｾ橸ｾ・';
    pnlStat2.Color := clYellow;
  end;
end;

procedure TRetroUIForm.StopSimulation(const Reason: string);
begin
  tmrSim.Enabled := False;
  FRunning := False;
  FDisconnectCountdown := 0;
  UpdateControlsState;
  if Reason <> '' then
    AddLog('> ' + Reason);
end;

procedure TRetroUIForm.btnExecClick(Sender: TObject);
begin
  FRunning := True;
  FSeconds := 0;
  FStepIndex := 0;
  FDisconnectCountdown := 0;

  UpdateControlsState;

  pnlStat1.Caption := ' ・ｽ・・ｽｰ・€・ｽ 豁｣蟶ｸ';
  pnlStat1.Color := clLime;
  pnlStat2.Caption := ' ・難ｽｰ・・ｾ・騾壻ｿ｡荳ｭ';
  pnlStat2.Color := clAqua;
  pnlStat3.Caption := ' 00:00:00';

  AddLog('> 騾壻ｿ｡ 髢句ｧ・ ' + edtPort.Text);
  tmrSim.Enabled := True;
end;

procedure TRetroUIForm.btnStopClick(Sender: TObject);
begin
  PlayAlertSound;
  if MessageDlg('騾壻ｿ｡繧剃ｸｭ豁｢縺励∪縺吶°・・', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    StopSimulation('・包ｽｰ・ｻ・橸ｽｰ ・・ｾ厄ｾ・・・ｽｭ・ｳ・ｼ ・ｻ・夲ｾ擾ｽｼ・€.');
  end;
end;

procedure TRetroUIForm.btnHelpClick(Sender: TObject);
var
  Msg: string;
begin
  PlayAlertSound;
  Msg := '========================================' + sLineBreak +
         '  騾壻ｿ｡邂｡逅・・ゑｽｰ・・ Ver 1.00 (Delphi 13.2)' + sLineBreak +
         '  (C) 1998-2026 Retro Communications Corp.' + sLineBreak +
         '========================================' + sLineBreak + sLineBreak +
         '縲仙推繧ｪ繝励す繝ｧ繝ｳ縺ｮ隱ｬ譏弱€・' + sLineBreak +
         '繝ｻ螳溯｡・&E): 騾壻ｿ｡繧ｷ繝溘Η繝ｬ繝ｼ繧ｷ繝ｧ繝ｳ繧帝幕蟋九＠縺ｾ縺吶€・' + sLineBreak +
         '繝ｻ荳ｭ豁｢(&C): 騾壻ｿ｡繧剃ｸｭ譁ｭ縺励€∝ｾ・ｩ溽憾諷九↓謌ｻ縺励∪縺吶€・' + sLineBreak +
         '繝ｻ閾ｪ蜍募・謗･邯・ 騾壻ｿ｡荳ｭ縺ｫ蝗樒ｷ夂椪譁ｭ繧呈､懃衍縺励◆髫帙€∬・蜍募ｾｩ蟶ｰ繧定ｩｦ縺ｿ縺ｾ縺吶€・' + sLineBreak +
         '繝ｻ・幢ｽｸ・槭ｒ菫晏ｭ倥☆繧・ 譛牙柑譎ゅ↓[髢九￥]繝懊ち繝ｳ縺ｧ繝ｭ繧ｰ繝輔ぃ繧､繝ｫ繧帝幕縺代∪縺吶€・' + sLineBreak +
         '繝ｻ隴ｦ蜻企浹繧帝ｳｴ繧峨☆: 隴ｦ蜻翫・遒ｺ隱肴凾縺ｫ繧ｷ繧ｹ繝・Β繝薙・繝鈴浹繧帝ｳｴ繧峨＠縺ｾ縺吶€・' + sLineBreak +
         '繝ｻ・鯉ｾ呻ｽｽ・ｸ・假ｽｰ・晁｡ｨ遉ｺ: 逕ｻ髱｢譛€螟ｧ蛹冶｡ｨ遉ｺ縺ｫ蛻・ｊ譖ｿ縺医∪縺吶€・' + sLineBreak + sLineBreak +
         '窶ｻ騾∽ｿ｡繝ｭ繧ｰ鬆伜沺縺ｯ蟶ｸ縺ｫ譛€譁ｰ縺ｮ謨ｰ陦後ｒ豬√ｌ繧九ｈ縺・↓陦ｨ遉ｺ縺励∪縺吶€・';
  MessageDlg(Msg, mtInformation, [mbOK], 0);
end;

procedure TRetroUIForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TRetroUIForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Prompt: string;
begin
  PlayAlertSound;
  if FRunning then
    Prompt := '迴ｾ蝨ｨ縲・€壻ｿ｡繧貞ｮ溯｡御ｸｭ縺ｧ縺吶€る€壻ｿ｡繧貞ｼｷ蛻ｶ荳ｭ譁ｭ縺励※邨ゆｺ・＠縺ｾ縺吶°・・'
  else
    Prompt := '騾壻ｿ｡邂｡逅・・ゑｽｰ・・繧堤ｵゆｺ・＠縺ｾ縺吶°・・';

  CanClose := (MessageDlg(Prompt, mtConfirmation, [mbYes, mbNo], 0) = mrYes);
end;

procedure TRetroUIForm.chkLogClick(Sender: TObject);
begin
  btnOpenLog.Visible := chkLog.Checked;
  if chkLog.Checked then
    SaveLogToFile;
end;

procedure TRetroUIForm.btnOpenLogClick(Sender: TObject);
var
  LogFile: string;
begin
  LogFile := GetLogFilePath;
  SaveLogToFile;
  if FileExists(LogFile) then
    ShellExecute(Handle, 'open', PChar(LogFile), nil, nil, SW_SHOWNORMAL)
  else
    ShowMessage('菫晏ｭ倥＆繧後◆繝ｭ繧ｰ縺後≠繧翫∪縺帙ｓ縲・');
end;

procedure TRetroUIForm.chkFullClick(Sender: TObject);
begin
  if chkFull.Checked then
  begin
    BorderStyle := bsSizeable;
    WindowState := wsMaximized;
  end
  else
  begin
    WindowState := wsNormal;
    BorderStyle := bsSingle;
    ClientWidth := 400;
    ClientHeight := 406;
  end;
end;

procedure TRetroUIForm.rbMethodClick(Sender: TObject);
begin
  UpdatePortSettings;
end;

procedure TRetroUIForm.tmrSimTimer(Sender: TObject);
begin
  if not FRunning then
    Exit;

  Inc(FSeconds);
  pnlStat3.Caption := Format(' %.2d:%.2d:%.2d',
    [FSeconds div 3600, (FSeconds mod 3600) div 60, FSeconds mod 60]);

  if chkAuto.Checked and (FDisconnectCountdown > 0) then
  begin
    Dec(FDisconnectCountdown);
    prgStatus.Position := Random(15);
    pnlStat1.Caption := ' ・ｽ・・ｽｰ・€・ｽ 蛻・妙';
    pnlStat1.Color := clRed;
    pnlStat2.Caption := ' ・難ｽｰ・・ｾ・蜀肴磁邯壻ｸｭ';
    pnlStat2.Color := clYellow;

    if FDisconnectCountdown = 0 then
    begin
      PlayAlertSound;
      AddLog('> 蜀肴磁邯・謌仙粥! 騾壻ｿ｡ 蠕ｩ蟶ｰ.');
      pnlStat1.Caption := ' ・ｽ・・ｽｰ・€・ｽ 豁｣蟶ｸ';
      pnlStat1.Color := clLime;
      pnlStat2.Caption := ' ・難ｽｰ・・ｾ・騾壻ｿ｡荳ｭ';
      pnlStat2.Color := clAqua;
    end;
    Exit;
  end;

  if chkAuto.Checked and (FSeconds > 10) and (Random(25) = 0) then
  begin
    FDisconnectCountdown := 3;
    PlayAlertSound;
    prgStatus.Position := 10;
    AddLog('> ! 蝗樒ｷ夂椪譁ｭ 讀懷・ !');
    AddLog('> 閾ｪ蜍募・謗･邯・隧ｦ縺ｿ荳ｭ...');
    Exit;
  end;

  prgStatus.Position := 50 + Random(48);

  Inc(FStepIndex);
  case FStepIndex mod 6 of
    0:
      if rbSerial.Checked then
        AddLog('> TX: [ENQ] 繝・ｼ繧ｿ 隕∵ｱ・')
      else if rbModem.Checked then
        AddLog('> ATDT 03-3501-XXXX')
      else
        AddLog('> TCP: SYN_SENT -> 192.168.1.100');
    1:
      if rbSerial.Checked then
        AddLog('> RX: [ACK] 繝昴・繝・蠢懷・')
      else if rbModem.Checked then
        AddLog('> CONNECT 28800/V.34')
      else
        AddLog('> TCP: ESTABLISHED 繝昴・繝・8080');
    2:
      AddLog(Format('> 繝代こ繝・ヨ 騾∽ｿ｡ #%.4d (%d bytes)', [FStepIndex * 16, 64 + Random(192)]));
    3:
      AddLog(Format('> 繝代こ繝・ヨ 蜿嶺ｿ｡ #%.4d [CRC OK]', [FStepIndex * 16]));
    4:
      AddLog('> 菫｡蜿ｷ 繝ｬ繝吶Ν: ' + IntToStr(prgStatus.Position) + '% 螳牙ｮ・');
    5:
      AddLog('> 繝舌ャ繝輔ぃ 豸郁ｲｻ: 繝弱・繝槭Ν');
  end;
end;

end.