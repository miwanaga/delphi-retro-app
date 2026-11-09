program RetroUID13Modern;

uses
  Vcl.Forms,
  RetroUIUnit in 'RetroUIUnit.pas' {RetroUIForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows Modern');
  Application.CreateForm(TRetroUIForm, RetroUIForm);
  Application.Run;
end.