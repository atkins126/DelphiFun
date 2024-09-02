unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    IconImage: TImage;
  private
    FIcon : TIcon;
      // manage file drop from windows
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure WMDropFiles(var msg : TWMDropFiles) ; message WM_DROPFILES;
    procedure ReadShortCutFile(const SourceName : String);
    procedure SetIcon(Icon : TIcon);
    procedure SetIconByHandle(Icon : HICON);
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation
Uses
  Winapi.ShellApi, // DragQueryFile
  WinApi.ShlObj, // PickIconDlg

  SmartLauncher.Icons,
  SmartLauncher.ShortCut;

{$R *.dfm}

{ TForm1 }

procedure TForm1.CreateWnd;
begin
  inherited;
  DragAcceptFiles(WindowHandle, True);
end;

procedure TForm1.DestroyWnd;
begin
  DragAcceptFiles(WindowHandle, false);
  inherited;
end;

procedure TForm1.SetIcon(Icon: TIcon);
begin
  if Assigned(FIcon) then
    FIcon.Free;
  FIcon := Icon;
  IconImage.Picture.Bitmap.Assign(Icon);
end;

procedure TForm1.SetIconByHandle(Icon: HICON);
var LIcon : TIcon;
begin
  LIcon := TIcon.Create;
  LIcon.Width := 32;
  LIcon.Height := 32;
  LIcon.Handle := Icon;
  SetIcon(LIcon);
end;

procedure TForm1.ReadShortCutFile(const SourceName: String);
VAR LData : TShortCutDTO;
VAR IconExtractor : TIconExtractor;
begin
  if not FileExists(SourceName) then
    Exit;

  LData := NIL;
  try
    LData := TShortCut.Load(SourceName);
    IconImage.Picture.Bitmap := NIL;
    IconExtractor := TIconExtractor.Create(LData.Path, LData.IconFile, LData.IconIndex);
    try
      SetIconByHandle(IconExtractor.GetIcon);
    finally
      IconExtractor.Free;
    end;
  finally
    LData.Free;
  end;
end;

// accept file drop from windows when in edit mode
procedure TForm1.WMDropFiles(var msg: TWMDropFiles);
var
  fileCount: integer;
  fileName: array[0..MAX_PATH-1] of WideChar;
begin
  fileCount := DragQueryFile(msg.Drop, $FFFFFFFF, fileName, MAX_PATH);
    // accept single file only
  if(fileCount <> 1) then exit;

  DragQueryFile(msg.Drop, 0, fileName, sizeof(fileName));
  ReadShortCutFile(fileName);
  DragFinish(msg.Drop);
end;


end.
