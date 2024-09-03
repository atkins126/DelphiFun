program UseWMIForMachineUUID;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {Form1},
  WbemScripting_TLB in 'WbemScripting_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
