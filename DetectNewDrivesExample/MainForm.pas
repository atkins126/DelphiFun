unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  DBTTypes;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    log: TMemo;
  private
  public
    procedure WMDeviceChange(var Message: TMessage); Message WM_DEVICECHANGE;
    procedure DriveLetterAttached(const DriveLetter : Char);
    procedure DriveLetterRemoved(const DriveLetter : Char);
  end;

var
  Form1: TForm1;

implementation

resourcestring
  sNewDriveLetterArrivedString = 'A new drive letter was detected: %s';
  sDriveLetterRemovedString = 'A drive letter was removed: %s';

{$R *.dfm}

{ TForm1 }

  // try to detect whether a new USB device has been plugged in
procedure TForm1.WMDeviceChange(var Message: TMessage);
var DevStruct : PDEV_BROADCAST_HDR;
var DVolStruct : PDEV_BROADCAST_VOLUME;
var NewDriveLetter : Char;
begin
  if(Message.WParam = DBT_DEVICEARRIVAL) then
  begin
    DevStruct := Pointer(Message.LParam);
    if DevStruct^.dbch_devicetype = DBT_DEVTYP_VOLUME then
    begin
      DVolStruct := Pointer(Message.lParam);
      NewDriveLetter := DVolStruct.getDriveLetter;
      DriveLetterAttached(NewDriveLetter);
    end;
  end
  else if(Message.WParam = DBT_DEVICEREMOVECOMPLETE) then
  begin
    DevStruct := Pointer(Message.LParam);
    if DevStruct^.dbch_devicetype = DBT_DEVTYP_VOLUME then
    begin
      DVolStruct := Pointer(Message.lParam);
      NewDriveLetter := DVolStruct.getDriveLetter;
      DriveLetterRemoved(NewDriveLetter);
    end;
  end;

end;

procedure TForm1.DriveLetterAttached(const DriveLetter: Char);
begin
  log.Lines.Add(Format(sNewDriveLetterArrivedString, [DriveLetter]));
end;

procedure TForm1.DriveLetterRemoved(const DriveLetter: Char);
begin
  log.Lines.Add(Format(sDriveLetterRemovedString, [DriveLetter]));
end;


end.
