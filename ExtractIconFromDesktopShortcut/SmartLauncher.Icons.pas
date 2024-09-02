unit SmartLauncher.Icons;

interface
uses
  WinApi.Windows, // HICON
  Vcl.Graphics; // TIcon

type
 TIconExtractor = class
 private
   FExeFile : String;
   FIconFile : String;
   FIconIndex : Integer;
   function _getConfiguredIcon : HICON;
   function _getFirstExecutableIcon : HICON;
   function _getFirstIconFromExecutable(FileName : String) : HICON;
   function _getOwnIcon : HICON;
 public
   Constructor Create(const ExeFile : String; const IconFile : String; const IconIndex : Integer = 0);
   function GetIcon : HICON;
 end;

implementation
Uses
  System.SysUtils,
  Vcl.Forms,
  WinApi.ShellAPI;

Constructor TIconExtractor.Create(const ExeFile: string; const IconFile: string; const IconIndex: Integer = 0);
begin
  inherited Create;
  FExeFile := ExeFile;
  FIconFile := IconFile;
  FIconIndex := IconIndex;
end;

  // https://blogs.embarcadero.com/extracting-icons/

type ThIconArray = array[0..1024] of HICON;
type PhIconArray = ^ThIconArray;

function ExtractIconExW(lpszFile: PWideChar;
                        nIconIndex: Integer;
                        phiconLarge: PhIconArray;
                        phiconSmall: PhIconArray;
                        nIcons: UINT): UINT; stdcall;
  external 'shell32.dll' name 'ExtractIconExW';

  const UINT_MAX = $ffffffff;      // max value for an unsigned int

function TIconExtractor.GetIcon : HICON;
begin
  Result := _getConfiguredIcon;
  if Result = 0 then
    Result := _getFirstExecutableIcon;
  if Result = 0 then
    Result := _getOwnIcon;
end;

function TIconExtractor._getConfiguredIcon : HICON;
var LargeIcon : HICON;
var SmallIcon : HICON;
var PFileName : PWideChar;
begin
  if not FileExists(FIconFile) then
  begin
    var len := MAX_PATH * SizeOf(WideChar);
    GetMem(PFileName, len);
    ExpandEnvironmentStrings(PWideChar(FIconFile), PFileName, len);
    FIconFile := PFileName;
    FreeMem(PFileName);
  end;

  if not FileExists(FIconFile) then
    Exit(0);

  LargeIcon := 0;
  SmallIcon := 0;
  ExtractIconEx(PWideChar(FIconFile), FIconIndex, LargeIcon, SmallIcon, 1);
  Result := LargeIcon;
  if Result = 0 then
    Result := SmallIcon;
end;

function TIconExtractor._getFirstIconFromExecutable(FileName : String) : HICON;
var num_icons : UINT;
var pSmallIcons, pLargeIcons : phIconArray;
begin
  if not FileExists(FileName) then
    Exit(0);

  Result := 0;
  num_icons := ExtractIconExW(PWideChar(FileName), -1, nil, nil, 0);
  if num_icons > 0 then
  begin
    pSmallIcons := nil;
    pLargeIcons := nil;
    try
        // get and zero memory for handle list
      var ihsize := num_icons * SizeOf(HICON);
      GetMem(pSmallIcons, ihsize);
      FillChar(pSmallIcons^, ihsize, 0);
      GetMem(pLargeIcons, ihsize);
      FillChar(pLargeIcons^, ihsize, 0);
        // find icons in file
      if(ExtractIconExW(PWideChar(FileName), 0, pLargeIcons, pSmallIcons, num_icons) = UINT_MAX) then
        raise Exception.Create('Fehler in ExtractIconExW');
        // we only care for large icons, but settle for a small one if no large icon is present
      Result := pLargeIcons^[0];
      if Result = 0 then
        Result := pSmallIcons^[0];

    finally
      if(pSmallIcons <> nil) then
        FreeMem(pSmallIcons);
      if(pLargeIcons <> nil) then
        FreeMem(pLargeIcons);
    end;
  end;
end;

function TIconExtractor._getFirstExecutableIcon: HICON;
begin
  Result := _getFirstIconFromExecutable(FIconFile);
  if Result = 0 then
    Result := _getFirstIconFromExecutable(FExeFile);
end;

function TIconExtractor._getOwnIcon: HICON;
begin
  Result := Application.Icon.Handle;
end;

end.
