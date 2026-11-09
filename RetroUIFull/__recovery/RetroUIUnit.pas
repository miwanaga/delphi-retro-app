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
  AddLog('> ｼｽﾃﾑ ｼﾞｭﾝﾋﾞ ｶﾝﾘｮｳ.');
  UpdatePortSettings;
  UpdateControlsState;
end;

procedure TRetroUIForm.FormDestroy(Sender: TObject);
begin
  FAllLogs.Free;
end;

function TRetroUIForm.GetLogFilePath: string;
begin
  Result := ExtractFilePath(Application.ExeName) + 'retroui_full.log';
end;

procedure TRetroUIForm.SaveLogToFile;
begin
  try
    FAllLogs.SaveToFile(GetLogFilePath, TEncoding.UTF8);
  except
    // ignore errors in demo
  end;
end;

procedure TRetroUIForm.PlayAlertSound;
begin
  if chkWarn.Checked then
    MessageBeep(MB_ICONWARNING);
end;

procedure TRetroUIForm.AddLog(const S: string);
const
  MaxVisibleLines = 4; // 領域にスクロールバーを出さずに収める行数
begin
  FAllLogs.Add(FormatDateTime('[hh:nn:ss] ', Now) + S);
  if chkLog.Checked then
    SaveLogToFile;

  // 領域からはみ出る古い行は破棄する（スクロールバーは出さない）
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

  // 通信実行中は設定変更を禁止
  grpHoushiki.Enabled := not FRunning;
  grpPort.Enabled := not FRunning;

  if not FRunning then
  begin
    prgStatus.Position := 0;
    pnlStat1.Caption := ' ｽﾃｰﾀｽ 待機中';
    pnlStat1.Color := clBtnFace;
    pnlStat2.Caption := ' ﾓｰﾄﾞ:ｱｲﾄﾞﾙ';
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

  pnlStat1.Caption := ' ｽﾃｰﾀｽ 正常';
  pnlStat1.Color := clLime;
  pnlStat2.Caption := ' ﾓｰﾄﾞ:通信中';
  pnlStat2.Color := clAqua;
  pnlStat3.Caption := ' 00:00:00';

  AddLog('> ﾂｳｼﾝ ｶｲｼ: ' + edtPort.Text);
  tmrSim.Enabled := True;
end;

procedure TRetroUIForm.btnStopClick(Sender: TObject);
begin
  PlayAlertSound;
  if MessageDlg('通信を中止しますか？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    StopSimulation('ﾕｰｻﾞｰ ﾆﾖﾘ ﾁｭｳｼ ｻﾚﾏｼﾀ.');
  end;
end;

procedure TRetroUIForm.btnHelpClick(Sender: TObject);
var
  Msg: string;
begin
  PlayAlertSound;
  Msg := '========================================' + sLineBreak +
         '  通信管理 ﾂｰﾙ  Ver 1.00 (Full)' + sLineBreak +
         '  (C) 1998-2026 Retro Communications Corp.' + sLineBreak +
         '========================================' + sLineBreak + sLineBreak +
         '【各オプションの説明】' + sLineBreak +
         '・実行(&E): 通信シミュレーションを開始します。' + sLineBreak +
         '・中止(&C): 通信を中断し、待機状態に戻します。' + sLineBreak +
         '・自動再接続: 通信中に回線瞬断を検知した際、自動復帰を試みます。' + sLineBreak +
         '・ﾛｸﾞを保存する: 有効時に[開く]ボタンでログファイルを開けます。' + sLineBreak +
         '・警告音を鳴らす: 警告・確認時にシステムビープ音を鳴らします。' + sLineBreak +
         '・ﾌﾙｽｸﾘｰﾝ表示: 画面最大化表示に切り替えます。' + sLineBreak + sLineBreak +
         '※送信ログ領域は常に最新の数行を流れるように表示します。';
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
    Prompt := '現在、通信を実行中です。' + sLineBreak + '通信を強制中断して終了しますか？'
  else
    Prompt := '通信管理 ﾂｰﾙ を終了しますか？';

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
    ShowMessage('保存されたログがありません。');
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

  // 自動再接続シミュレーション
  if chkAuto.Checked and (FDisconnectCountdown > 0) then
  begin
    Dec(FDisconnectCountdown);
    prgStatus.Position := Random(15);
    pnlStat1.Caption := ' ｽﾃｰﾀｽ 切断';
    pnlStat1.Color := clRed;
    pnlStat2.Caption := ' ﾓｰﾄﾞ:再接続中';
    pnlStat2.Color := clYellow;

    if FDisconnectCountdown = 0 then
    begin
      PlayAlertSound;
      AddLog('> ｻｲｾﾂｿﾞｸ ｾｲｺｳ! ﾂｳｼﾝ ﾌｯｷ.');
      pnlStat1.Caption := ' ｽﾃｰﾀｽ 正常';
      pnlStat1.Color := clLime;
      pnlStat2.Caption := ' ﾓｰﾄﾞ:通信中';
      pnlStat2.Color := clAqua;
    end;
    Exit;
  end;

  // 自動再接続がONの場合、たまに瞬断をシミュレート (約30秒に1回程度の確率)
  if chkAuto.Checked and (FSeconds > 10) and (Random(25) = 0) then
  begin
    FDisconnectCountdown := 3;
    PlayAlertSound;
    prgStatus.Position := 10;
    AddLog('> ! ｶｲｾﾝ ｾﾂﾀﾞﾝ ｹﾝｼｭﾂ !');
    AddLog('> ｼﾞﾄﾞｳ ｻｲｾﾂｿﾞｸ ｺｺﾛﾐﾁｭｳ...');
    Exit;
  end;

  // 通常通信の信号変動
  prgStatus.Position := 50 + Random(48);

  // 通信ログの生成
  Inc(FStepIndex);
  case FStepIndex mod 6 of
    0:
      if rbSerial.Checked then
        AddLog('> TX: [ENQ] ﾃﾞｰﾀ ﾖｳｷｭｳ')
      else if rbModem.Checked then
        AddLog('> ATDT 03-3501-XXXX')
      else
        AddLog('> TCP: SYN_SENT -> 192.168.1.100');
    1:
      if rbSerial.Checked then
        AddLog('> RX: [ACK] ﾎﾟｰﾄ ｵｳﾄｳ')
      else if rbModem.Checked then
        AddLog('> CONNECT 28800/V.34')
      else
        AddLog('> TCP: ESTABLISHED ﾎﾟｰﾄ:8080');
    2:
      AddLog(Format('> ﾊﾟｹｯﾄ 送信 #%.4d (%d bytes)', [FStepIndex * 16, 64 + Random(192)]));
    3:
      AddLog(Format('> ﾊﾟｹｯﾄ 受信 #%.4d [CRC OK]', [FStepIndex * 16]));
    4:
      AddLog('> ｼﾝｺﾞｳ ﾚﾍﾞﾙ: ' + IntToStr(prgStatus.Position) + '% ｱﾝﾃｲ');
    5:
      AddLog('> ﾊﾞｯﾌｧ ｼｮｳﾋ: ﾉｰﾏﾙ');
  end;
end;

end.
