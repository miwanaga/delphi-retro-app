program RetroUID13;

uses
  Forms,
  RetroUIUnit in 'RetroUIUnit.pas' {RetroUIForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TRetroUIForm, RetroUIForm);
  Application.Run;
end.
