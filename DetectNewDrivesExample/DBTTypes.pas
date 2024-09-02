unit DBTTypes;

interface
Uses Winapi.Windows; // DWORD

const
  DBT_DEVNODES_CHANGED = $0007;
  DBT_QUERYCHANGECONFIG = $0017;
  DBT_CONFIGCHANGED = $0018;
  DBT_CONFIGCHANGECANCELED = $0019;
  DBT_DEVICEARRIVAL = $8000;
  DBT_DEVICEQUERYREMOVE = $8001;
  DBT_DEVICEQUERYREMOVEFAILED = $8002;
  DBT_DEVICEREMOVEPENDING = $8003;
  DBT_DEVICEREMOVECOMPLETE = $8004;
  DBT_DEVICETYPESPECIFIC = $8005;
  DBT_CUSTOMEVENT = $8006;
  DBT_USERDEFINED = $ffff;

    // dbch_devicetype
  DBT_DEVTYP_DEVICEINTERFACE = $00000005;
  DBT_DEVTYP_HANDLE = $00000006;
  DBT_DEVTYP_OEM = $00000000;
  DBT_DEVTYP_PORT = $00000003;
  DBT_DEVTYP_VOLUME = $00000002;

type
  PDEV_BROADCAST_HDR = ^DEV_BROADCAST_HDR;
  DEV_BROADCAST_HDR = record
    dbch_size : DWORD;
    dbch_devicetype : DWORD;
    dbch_reserved : DWORD;
  end;

  PDEV_BROADCAST_VOLUME = ^DEV_BROADCAST_VOLUME;
  DEV_BROADCAST_VOLUME = record
    dbch_size : DWORD;
    dbch_devicetype : DWORD;
    dbch_reserved : DWORD;
    dbcv_unitmask : DWORD;
    dbcv_flags: WORD;
      // helper function to convert unitmask to drive letter
    function getDriveLetter : Char;
  end;

implementation

{ DEV_BROADCAST_VOLUME }

function DEV_BROADCAST_VOLUME.getDriveLetter: Char;
var i : Integer;
var umask : DWORD;
begin
  umask := dbcv_unitmask;
  for i := 0 to 25 do
  begin
    if(umask and $1) <> 0 then
      break;
    umask := umask shr 1;
  end;
  Result := Chr(Ord('A') + i);
end;


end.
