unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Executor;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    FBatchExecutor : TBatchExecutor;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FBatchExecutor := TBatchExecutor.Create;
  FBatchExecutor.ExecuteBatch;
  FBatchExecutor.Free;
  Memo1.Lines.LoadFromFile('output.txt')
end;

end.
