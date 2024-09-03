unit Executor;

interface

uses
  Winapi.Windows, System.SysUtils, Vcl.StdCtrls, Classes;

type
  TBatchExecutor = class
  private
    FOutputStream: TMemoryStream;
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure ExecuteBatch;
  end;

implementation
Uses
  System.Diagnostics;

constructor TBatchExecutor.Create;
begin
  FOutputStream := TMemoryStream.Create;
  if FileExists('output.txt') then
    DeleteFile('output.txt');
end;

Destructor TBatchExecutor.Destroy;
begin
  FOutputStream.SaveToFile('output.txt');
  FOutputStream.Free;
  inherited;
end;

procedure TBatchExecutor.ExecuteBatch;
var ElapsedMS : Int64;

  function AttachChildConsole(ProcessId : Cardinal; TimeoutMS : Int64) : Boolean;
  var sw : TStopWatch;
  begin
    sw := TStopWatch.Create;
    sw.Start;
    Result := False;
    while(sw.ElapsedMilliseconds < TimeoutMS) do
    begin
      Result := AttachConsole(ProcessId);
      ElapsedMS := sw.ElapsedMilliseconds;
      if not Result then
        Sleep(1)
      else
        Exit;
    end;
  end;

var
  SecurityAttributes: TSecurityAttributes;
  ReadPipe, WritePipe: THandle;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  Buffer: array[0..255] of AnsiChar;
  BytesRead: DWORD;
  CommandLine: string;
begin
  // Initialize security attributes
  SecurityAttributes.nLength := SizeOf(SecurityAttributes);
  SecurityAttributes.bInheritHandle := True;
  SecurityAttributes.lpSecurityDescriptor := nil;

  // Create the anonymous pipe
  if not CreatePipe(ReadPipe, WritePipe, @SecurityAttributes, 0) then
  begin
    Exit;
  end;

  try
    // Ensure the write handle to the pipe is inherited
    if not SetHandleInformation(WritePipe, HANDLE_FLAG_INHERIT, HANDLE_FLAG_INHERIT) then
    begin
      Exit;
    end;

    // Initialize the startup info structure
    ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
    StartupInfo.cb := SizeOf(StartupInfo);
    StartupInfo.hStdOutput := WritePipe;
    StartupInfo.hStdError := WritePipe;
    StartupInfo.dwFlags := STARTF_USESTDHANDLES;

    // Command line to execute the batch file
    CommandLine := 'cmd.exe /C test.bat';

    // Create the child process
    if not CreateProcess ('c:\WINDOWS\system32\cmd.exe',   // lpApplicationName
                    '/c ..\..\test.bat',  // lpCommandLine
                    nil,      // lpProcessAttributes
                    nil,      // lpThreadAttributes
                    True,                      // bInheritHandles
                    NORMAL_PRIORITY_CLASS or CREATE_NEW_CONSOLE,     // dwCreationFlags
                    nil,                       // lpEnvironment
                    nil,  // lpCurrentDirectory
                    StartupInfo,                      // lpStartupInfo
                    ProcessInfo) Then                 // lpProcessInformation

    begin
      Exit;
    end;

      // attach ourself to the console window
    if AttachChildConsole(ProcessInfo.dwProcessId, 5000) then
    begin
        // Redirect standard input/output to the console
      AssignFile(Output, 'CONOUT$');
      Rewrite(Output);

        // write to the console
      Writeln('Attached to the console of the child process.');
      WriteLn(Format('Took %d milliseconds.', [ElapsedMS]));
    end;

    try
        // Close the write end of the pipe
      CloseHandle(WritePipe);
      WritePipe := 0;

        // Read from the pipe
      while ReadFile(ReadPipe, Buffer, SizeOf(Buffer) - 1, BytesRead, nil) and (BytesRead > 0) do
      begin
        Buffer[BytesRead] := #0;
        FOutputStream.Write(Buffer, BytesRead);
          // echo output to attached console
        Write(Buffer);
      end;

    finally
      // Close process and thread handles
      CloseHandle(ProcessInfo.hProcess);
      CloseHandle(ProcessInfo.hThread);
    end;

  finally
    if WritePipe <> 0 then
      CloseHandle(WritePipe);
    CloseHandle(ReadPipe);
  end;
end;

end.
