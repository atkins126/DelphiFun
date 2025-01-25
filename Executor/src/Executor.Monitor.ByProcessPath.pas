unit Executor.Monitor.ByProcessPath;

interface
uses
  System.Generics.Collections,
  Winapi.Windows,
  Executor.Interfaces;

  {
      TProcessExitByPath - walks the process list and tries to determine the
      full path of the executable. Returns True when there are no more
      active processes that share the executables path
  }
type
  TProcessExitByPath = class (TInterfacedObject, IProcessExitWaiter)
  strict private
    FUpperProcessImagePath: String;
  public
    function GetApplicableProcessList(InPath: String): TList<Cardinal>;
    procedure SetParameter(const Value: Variant);
    function GetIdentifier: TExitMonitorMethod;
    function ProcessExists: Boolean;
  end;


implementation
uses
  System.SysUtils,
  System.StrUtils,
  System.Variants,
  Winapi.PsAPI; // walking process list

{ TProcessExitByName }

function TProcessExitByPath.GetApplicableProcessList(InPath: String): TList<Cardinal>;
var cbNeeded: Cardinal;
    LProcessIds: array of Cardinal;
    hProcess: Cardinal;
    ImagePath: array[0..MAX_PATH] of Char;
    UpperPath: String;
begin
  Result := TList<Cardinal>.Create;
  InPath := InPath.ToUpper;

  SetLength(LProcessIds, 1024);
  if EnumProcesses(@LProcessIds[0], 1024*SizeOf(Cardinal), cbNeeded) then
  begin
    for var i := Low(LProcessIds) to High(LProcessIds) do
    begin
      hProcess := OpenProcess($1000, false, LProcessIds[i]);
      if(hProcess > 0) then
      begin
        try
          GetModuleFileNameEx(hProcess, 0, ImagePath, MAX_PATH);
          UpperPath := ImagePath;
          UpperPath := UpperPath.ToUpper;
          if(LeftStr(UpperPath, Length(InPath)) = InPath) then
            Result.Add(LProcessIds[i]);
        finally
          CloseHandle(hProcess);
        end;
      end;
    end
  end
  else
    raise Exception.Create('EnumProcesses didn''t find any accessible processes');
end;

function TProcessExitByPath.GetIdentifier: TExitMonitorMethod;
begin
  Result := emByProcessPath;
end;

function TProcessExitByPath.ProcessExists(): Boolean;
var pList: TList<Cardinal>;
begin
  pList := GetApplicableProcessList(FUpperProcessImagePath);
  Result := pList.Count > 0;
  pList.Free;
end;


procedure TProcessExitByPath.SetParameter(const Value: Variant);
begin
  if not VarIsType(Value, varUString) then
    raise Exception.Create('Value must be a string');
  var BufS := Value;
  FUpperProcessImagePath := ExtractFilePath(BufS).ToUpper;
  if(FUpperProcessImagePath = '') then
    raise Exception.Create('TProcessExitByPath needs a full image name with path');
end;

end.
