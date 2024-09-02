program ExtractIconFromDesktopShortcut;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {Form1},
  SmartLauncher.Icons in 'SmartLauncher.Icons.pas',
  SmartLauncher.ShortCut in 'SmartLauncher.ShortCut.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
