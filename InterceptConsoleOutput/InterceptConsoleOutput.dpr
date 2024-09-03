program InterceptConsoleOutput;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {Form1},
  Executor in 'Executor.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
