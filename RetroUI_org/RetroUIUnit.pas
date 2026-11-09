unit RetroUIUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

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
    procedure btnCloseClick(Sender: TObject);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

var
  RetroUIForm: TRetroUIForm;

implementation

{$R *.dfm}

procedure TRetroUIForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
