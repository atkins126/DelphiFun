unit Executor.Monitor.ByProcessId;

interface
uses
  Executor.Interfaces;

type
  {
    TProcessExitByProcessId - uses WaitForSingleObject with a timeout of 0
    suitable for processes that uses container applications like "cmd.exe"
    or perhaps "rundll32.dll" (to be tested).
  }

  TProcessExitByProcessId = class(TInterfacedObject, IProcessExitWaiter)
  strict private
    FProcessHandle: THandle;
  public
    procedure SetParameter(const Value: Variant);
    function GetIdentifier: TExitMonitorMethod;
    function ProcessExists: Boolean;
  end;

implementation
uses
  Winapi.Windows,
  System.SysUtils,
  System.Variants;

{ TProcessExitByProcessId }

function TProcessExitByProcessId.GetIdentifier: TExitMonitorMethod;
begin
  Result := emByProcessId;
end;

function TProcessExitByProcessId.ProcessExists(): Boolean;
var WaitResult: DWORD;
begin
  Assert(FProcessHandle <> 0, 'FProcessHandle cannot be 0');

  WaitResult := WaitForSingleObject(FProcessHandle, 0);
  Result := WaitResult = WAIT_TIMEOUT;
end;

procedure TProcessExitByProcessId.SetParameter(const Value: Variant);
begin
  if not VarIsType(Value, varUInt32) then // Cardinal is varUInt32
    raise Exception.Create('Value must be a numeric process ID');
  FProcessHandle := Value;  
end;


end.
