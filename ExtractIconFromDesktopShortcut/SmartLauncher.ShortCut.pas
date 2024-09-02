unit SmartLauncher.ShortCut;

interface
uses
  System.SysUtils,
  System.Win.ComObj,
  WinApi.Windows,
  WinApi.ShlObj,
  WinApi.ActiveX;

type
  TShortCutDTO = class
  protected
  public
    Path : String;
    Description : String;
    WorkingDirectory : String;
    Arguments : String;
    ShowCmd : Integer;
    IconFile : String;
    IconIndex : Integer;
  end;

  TShortCut = class
    class function Load(const FileName : String) : TShortCutDTO;
    class function Save(FileName : String; Data : TShortCutDTO): Boolean;
  end;

implementation
Uses
  System.IOUtils,
  Vcl.Forms;

resourcestring
  sErrorCannotLoadShellLink = 'Failed to load shortcut file: %s';
  sApplicationName = 'Demo application';
  sCreatedWithInformationString = 'Saved with my demo application!';

{ TShortCutDTO }

  // under some unknown circumstances the GetPath() and GetIconLocation()
  // interface functions return C:\Program Files (x86)\... instead of the
  // correct C:\Program Files\...
  // check if the file exists and remove " (x86)"
function __fix_ShortCut_Bug(const FileName : String) : String;
begin
  Result := FileName;
  if not FileExists(Result) then
  begin
    Result := StringReplace(FileName, ' (x86)', '', []);
    if not FileExists(Result) then
      Result := '';
  end;
end;

  // Embarcadero's forgotten function: (TPath.)GetDesktopDirectory()
function GetDesktopDirectory : String;
var
  LStr: array[0 .. MAX_PATH] of Char;
begin
  SetLastError(ERROR_SUCCESS);
  if SHGetFolderPath(0, CSIDL_DESKTOPDIRECTORY, 0, 0, @LStr) = S_OK then
    Result := LStr
  else
    Result := '';
end;

{ TShortCut }

class function TShortCut.Load(const FileName: String): TShortCutDTO;
var
  IObject: IUnknown;
  ISLink: IShellLink;
  IPFile: IPersistFile;
  FindData: TWIN32FINDDATA;

  procedure LoadShellLinkData(const ShellLinkInterface: IShellLink);
  var
    Data: array[0..MAX_PATH-1] of WideChar;
  begin
    with ShellLinkInterface do
    begin
      GetPath(Data, MAX_PATH, FindData, 0);
      Result.Path := __fix_ShortCut_Bug(Data);
      GetDescription(Data, SizeOf(Data));
      Result.Description := Data;
      GetArguments(Data, SizeOf(Data));
      Result.Arguments := Data;
      GetWorkingDirectory(Data, SizeOf(Data));
      Result.WorkingDirectory := Data;
      GetShowCmd(Result.ShowCmd);
      GetIconLocation(Data, SizeOf(Data), Result.IconIndex);
      if Data[0] = #0 then
        Result.IconFile := Result.Path
      else
        Result.IconFile := __fix_ShortCut_Bug(Data);
    end;
  end;

begin
  if not FileExists(FileName) then
    Exit(nil);

  Result := TShortCutDTO.Create;
  try
    IObject := CreateComObject(CLSID_ShellLink);
    ISLink := IObject as IShellLink;
    IPFile := IObject as IPersistFile;

    if Succeeded(IPFile.Load(PChar(FileName), STGM_READ or STGM_SHARE_DENY_NONE)) then
    begin
      LoadShellLinkData(ISLink);
    end
    else
    begin
      FreeAndNil(Result);
      raise Exception.CreateFmt(sErrorCannotLoadShellLink, [FileName]);
    end;
  except
    FreeAndNil(Result);
    raise;
  end;
end;

class function TShortCut.Save(FileName : String; Data : TShortCutDTO) : Boolean;
var
  IObject: IUnknown;
  ISLink: IShellLink;
  IPFile: IPersistFile;
begin
  IObject := CreateComObject(CLSID_ShellLink);
  ISLink := IObject as IShellLink;
  IPFile := IObject as IPersistFile;

  with ISLink do
  begin
    SetPath(PWideChar(Data.Path));
    var description := sCreatedWithInformationString;
    SetDescription(PWideChar(description));
    SetArguments(PWideChar(Data.Arguments));
    SetWorkingDirectory(PWideChar(Data.WorkingDirectory));
    SetIconLocation(PWideChar(Data.IconFile), Data.IconIndex);
  end;

  var new_file_name := IncludeTrailingPathDelimiter(GetDesktopDirectory) + FileName;
  Result := IPFile.Save(PWideChar(new_file_name), True) = S_OK;
end;

end.
