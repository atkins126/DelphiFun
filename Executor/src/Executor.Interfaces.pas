unit Executor.Interfaces;

interface
uses
  System.Generics.Collections, // TDictionary
  System.SysUtils, // Exception
  System.Classes; // TStrings

type

{$REGION 'Executor and Monitors'}

  TExitMonitorMethod = (emByProcessId, emByProcessName, emByProcessPath);

  { The IProcessExitWaiter interface allows waiting for a main process to end
    in multiple ways.
	
    TProcessExitByPath - Inspired by Playnite - https://playnite.link/
	  execution ends when all applications in the same path or subdirectory
	  have ended
    TProcessExitByName - walks the process map and looks for the process by
      image name. Returns True when the last process with that name has ended
    TProcessExitByProcessId - uses WaitForSingleObject with a timeout of 0
      suitable for processes that uses container applications like "cmd.exe"
      or perhaps "rundll32.dll" (to be tested). }

  IProcessExitWaiter = interface
    ['{45CF01D4-4513-47AC-8658-3D6D56226C01}']
    procedure SetParameter(const Value: Variant);
    function GetIdentifier: TExitMonitorMethod;
    function ProcessExists: Boolean;
  end;

  ICreateProcess = interface
    ['{167FF7AA-580C-4D52-9F23-E65AD9C4C68F}']
    procedure SetExecutable(const Value: string);
    function GetExecutable: string;
    procedure SetExecutableRootPath(const Value: string);
    function GetExecutableRootPath: string;
    procedure SetParameterString(const Value: string);
    function GetParameterString: string;
    procedure SetShowWindow(const Value: Boolean);
    function GetShowWindow: Boolean;
    procedure SetAllowUnsafe(const Value: Boolean);
    function GetAllowUnsafe: Boolean;
      // calls Winapi.CreateProcess and returns the error code or ERROR_SUCCESS
    function CreateProcess: Cardinal;
      // returns true if Winapi.CreateProcess failed
    function Error: Boolean;
      // returns the Process Id if Error is false or 0 otherwise
    function GetProcessId: Cardinal;
  end;

  EDigitallyUnsigned = class(Exception);
  TWaitMethod = (wmWaitInBackground, wmWaitInForeground);
  TSuccessCallbackMethod = reference to procedure;
  TErrorCallbackMethod = reference to procedure(const win32_errorcode : Cardinal);

  IExecutor = interface
    ['{01A85594-D6ED-43F2-9863-A79BA7C0E2F9}']
    procedure Execute(
          const WaitMethod: TWaitMethod;
          const ShowWindow: Boolean;
          const OnSuccess: TSuccessCallbackMethod = nil;
          const OnError: TErrorCallbackMethod = nil;
          const AllowUnsafe: Boolean = True);

  end;

{$ENDREGION}


implementation

end.
