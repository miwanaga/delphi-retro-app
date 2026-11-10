unit RetroUIUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Winapi.ShellAPI, System.UITypes, Vcl.WinXCtrls;

type
  TRetroUIForm = class(TForm)
    lblLog: TLabel;
    lblProgress: TLabel;
    actIndicator: TActivityIndicator;
    pnlTitle: TRelativePanel;
    lblTitle: TLabel;
    lblVersion: TLabel;
    grpHoushiki: TGroupBox;
    rbSerial: TRadioButton;
    rbModem: TRadioButton;
    rbLan: TRadioButton;
    grpPort: TGroupBox;
    lblPort: TLabel;
    lblBaud: TLabel;
    lblParity: TLabel;
    edtPort: TSearchBox;
    cmbBaud: TComboBox;
    swParity: TToggleSwitch;
    grpOption: TGroupBox;
    lblAuto: TLabel;
    lblLogOpt: TLabel;
    lblWarn: TLabel;
    lblFull: TLabel;
    swAuto: TToggleSwitch;
    swLog: TToggleSwitch;
    btnOpenLog: TButton;
    swWarn: TToggleSwitch;
    swFull: TToggleSwitch;
    lstLog: TListBox;
    prgStatus: TProgressBar;
    statusBar: TStatusBar;
    pnlButtons: TPanel;
    btnHelp: TButton;
    btnStop: TButton;
    btnExec: TButton;
    btnClose: TButton;
    tmrSim: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure btnExecClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure swLogClick(Sender: TObject);
    procedure btnOpenLogClick(Sender: TObject);
    procedure swFullClick(Sender: TObject);
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
  AddLog('> 初期化が完了しました');
  UpdatePortSettings;
  UpdateControlsState;
end;

procedure TRetroUIForm.FormDestroy(Sender: TObject);
begin
  FAllLogs.Free;
end;

function TRetroUIForm.GetLogFilePath: string;
begin
  Result := ExtractFilePath(Application.ExeName) + 'retroui_win10.log';
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
  if swWarn.State = tssOn then
    MessageBeep(MB_ICONWARNING);
end;

procedure TRetroUIForm.AddLog(const S: string);
const
  MaxVisibleLines = 6;
begin
  FAllLogs.Add(FormatDateTime('[hh:nn:ss] ', Now) + S);
  if swLog.State = tssOn then
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
    swParity.Enabled := True;
    if cmbBaud.ItemIndex < 0 then
      cmbBaud.ItemIndex := 2;
  end
  else if rbModem.Checked then
  begin
    edtPort.Text := 'COM3 (MODEM)';
    cmbBaud.Enabled := True;
    swParity.Enabled := True;
  end
  else if rbLan.Checked then
  begin
    edtPort.Text := '192.168.1.10:8080';
    cmbBaud.Enabled := False;
    swParity.Enabled := False;
  end;
end;

procedure TRetroUIForm.UpdateControlsState;
begin
  btnExec.Enabled := not FRunning;
  btnStop.Enabled := FRunning;

  grpHoushiki.Enabled := not FRunning;
  grpPort.Enabled := not FRunning;

  actIndicator.Animate := FRunning;

  if not FRunning then
  begin
    prgStatus.Position := 0;
    statusBar.Panels[0].Text := '準備完了';
    statusBar.Panels[1].Text := '通信状態: 停止中';
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

  statusBar.Panels[0].Text := 'ステータス: 正常';
  statusBar.Panels[1].Text := '通信状態: 通信中';
  statusBar.Panels[2].Text := '経過時間 00:00:00';

  AddLog('> 通信開始: ' + edtPort.Text);
  tmrSim.Enabled := True;
end;

procedure TRetroUIForm.btnStopClick(Sender: TObject);
begin
  PlayAlertSound;
  if MessageDlg('通信を中止しますか？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    StopSimulation('ユーザーにより中止されました');
  end;
end;

procedure TRetroUIForm.btnHelpClick(Sender: TObject);
var
  Msg: string;
begin
  PlayAlertSound;
  Msg := '========================================' + sLineBreak +
         '  通信管理ツール  Ver 1.00 (Win10)' + sLineBreak +
         '  (C) 2026 Modern Communications Corp.' + sLineBreak +
         '========================================' + sLineBreak + sLineBreak +
         '【各オプションの説明】' + sLineBreak +
         '・実行(&E): 通信シミュレーションを開始します。' + sLineBreak +
         '・中止(&C): 通信を中断し、待機状態に戻します。' + sLineBreak +
         '・自動的に再接続する: 通信中に回線瞬断を検知した際、自動復帰を試みます。' + sLineBreak +
         '・ログを保存する: 有効時に[開く]ボタンでログファイルを開けます。' + sLineBreak +
         '・警告音を鳴らす: 警告・確認時にシステムビープ音を鳴らします。' + sLineBreak +
         '・フルスクリーン表示にする: 画面最大化表示に切り替えます。' + sLineBreak + sLineBreak +
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
    Prompt := '通信管理ツールを終了しますか？';

  CanClose := (MessageDlg(Prompt, mtConfirmation, [mbYes, mbNo], 0) = mrYes);
end;

procedure TRetroUIForm.swLogClick(Sender: TObject);
begin
  btnOpenLog.Visible := (swLog.State = tssOn);
  if swLog.State = tssOn then
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

procedure TRetroUIForm.swFullClick(Sender: TObject);
begin
  if swFull.State = tssOn then
  begin
    BorderStyle := bsSizeable;
    WindowState := wsMaximized;
  end
  else
  begin
    WindowState := wsNormal;
    BorderStyle := bsSingle;
    ClientWidth := 640;
    ClientHeight := 680;
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
  statusBar.Panels[2].Text := Format('経過時間 %.2d:%.2d:%.2d',
    [FSeconds div 3600, (FSeconds mod 3600) div 60, FSeconds mod 60]);

  // 自動再接続シミュレーション
  if (swAuto.State = tssOn) and (FDisconnectCountdown > 0) then
  begin
    Dec(FDisconnectCountdown);
    prgStatus.Position := Random(15);
    statusBar.Panels[0].Text := 'ステータス: 切断';
    statusBar.Panels[1].Text := '通信状態: 再接続中';

    if FDisconnectCountdown = 0 then
    begin
      PlayAlertSound;
      AddLog('> 再接続に成功しました。通信を復帰します');
      statusBar.Panels[0].Text := 'ステータス: 正常';
      statusBar.Panels[1].Text := '通信状態: 通信中';
    end;
    Exit;
  end;

  // 自動再接続がONの場合、たまに瞬断をシミュレート
  if (swAuto.State = tssOn) and (FSeconds > 10) and (Random(25) = 0) then
  begin
    FDisconnectCountdown := 3;
    PlayAlertSound;
    prgStatus.Position := 10;
    AddLog('> 【警告】回線切断を検出しました');
    AddLog('> 自動再接続を試行しています...');
    Exit;
  end;

  // 通常通信の信号変動
  prgStatus.Position := 50 + Random(48);

  // 通信ログの生成
  Inc(FStepIndex);
  case FStepIndex mod 6 of
    0:
      if rbSerial.Checked then
        AddLog('> TX: [ENQ] データ要求')
      else if rbModem.Checked then
        AddLog('> ATDT 03-3501-XXXX')
      else
        AddLog('> TCP: SYN_SENT -> 192.168.1.100');
    1:
      if rbSerial.Checked then
        AddLog('> RX: [ACK] ポート応答')
      else if rbModem.Checked then
        AddLog('> CONNECT 28800/V.34')
      else
        AddLog('> TCP: ESTABLISHED ポート:8080');
    2:
      AddLog(Format('> パケット送信 #%.4d (%d bytes)', [FStepIndex * 16, 64 + Random(192)]));
    3:
      AddLog(Format('> パケット受信 #%.4d [CRC OK]', [FStepIndex * 16]));
    4:
      AddLog('> 信号レベル: ' + IntToStr(prgStatus.Position) + '% 安定');
    5:
      AddLog('> バッファ消費: 通常');
  end;
end;

end.
