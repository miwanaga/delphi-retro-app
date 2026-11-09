program RetroUIProject;

uses
  Vcl.Forms,
  RetroUIUnit in 'RetroUIUnit.pas' {RetroUIForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TRetroUIForm, RetroUIForm);
  Application.Run;
end.
