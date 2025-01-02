unit DTOHelper.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  DataTransferHelper;


type
  TConfigFileDTO = class(TDataTransferObject)
    id: string;
    exeFile: string;
    exePath: string;
    arguments: string;
    icon_file: string;
    icon_index: Integer;
    script: string;
    script_path: string;
    post_exit_delay: Integer;
    allow_unsafe: Boolean;
    report_enabled: Boolean;
    report_days : Integer;
    monitor_method: string;
  end;

  TForm1 = class(TForm)
    Memo1: TMemo;
    btnTest: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure btnDumpClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnDistributeClick(Sender: TObject);
    procedure btnCollectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FTestObject: TConfigFileDTO;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  FTestObject := TConfigFileDTO.Create;
  with FTestObject do
  begin
      // some demo data
    id := 'ApplicationId';
    exeFile := 'exeFile Value';
    exePath := 'exePath Value';
    arguments := 'arguments Value';
    icon_file := 'icon_file Value';
    icon_index := 1;
    script := 'script Value';
    script_path := 'script_path Value';
    post_exit_delay := 2;
    allow_unsafe := True;
    report_enabled := False;
    report_days := 3;
    monitor_method := 'monitor_method Value';

      // link some fields from the DTO to form elements
    ClearControlLinks;
    AddControlLink('id', Label1, 'Caption');
    AddControlLink('exeFile', Edit1, 'Text');
    AddControlLink('icon_index', Edit2, 'Text');
    AddControlLink('allow_unsafe', CheckBox1, 'Checked');
  end;
end;

procedure TForm1.btnDumpClick (Sender: TObject);
var BufS: string;
    LInfoS: string;
begin
  Form1.Memo1.Lines.Clear;

  for BufS in FTestObject.Fields do
  begin
    LInfoS := FTestObject.AsString(BufS);
    Form1.Memo1.Lines.Add(BufS + ': ' + LInfoS);
  end;
end;

procedure TForm1.btnCollectClick(Sender: TObject);
begin
  FTestObject.Collect;
end;

procedure TForm1.btnDistributeClick(Sender: TObject);
begin
  FTestObject.Distribute;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  btnDumpClick(btnTest);
end;

end.
