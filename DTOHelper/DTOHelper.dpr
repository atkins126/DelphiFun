program DTOHelper;

uses
  Vcl.Forms,
  DTOHelper.MainForm in 'DTOHelper.MainForm.pas' {Form1},
  DataTransferHelper in 'DataTransferHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
