unit Executor.Monitor.ByProcessName;

interface
uses
  Winapi.Windows,
  Executor.Interfaces;

type
  {
      TProcessExitByName - walks the process map and looks for the process by
        image name. Returns True when the last process with that name has ended
  }
  TProcessExitByName = class (TInterfacedObject, IProcessExitWaiter)
  strict private
    FProcessImageName: String;
  public
    procedure SetParameter(const Value: Variant);
    function GetIdentifier: TExitMonitorMethod;
    function ProcessExists: Boolean;
  end;

implementation
uses
  System.SysUtils,
  System.Variants,
  TlHelp32; // walking process list

{ TProcessExitByName }

function TProcessExitByName.GetIdentifier: TExitMonitorMethod;
begin
  Result := emByProcessName;
end;

function TProcessExitByName.ProcessExists(): Boolean;
var ContinueLoop: BOOL;
    FSnapshotHandle: THandle;
    FProcessEntry32: TProcessEntry32;
    UpperProcessImageName: String;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  UpperProcessImageName := UpperCase(FProcessImageName);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while ContinueLoop do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperProcessImageName) or
        (UpperCase(FProcessEntry32.szExeFile) = UpperProcessImageName)) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure TProcessExitByName.SetParameter(const Value: Variant);
begin
  if not VarIsType(Value, varUString) then
    raise Exception.Create('Value must be a string');
  FProcessImageName := Value;
end;

end.
