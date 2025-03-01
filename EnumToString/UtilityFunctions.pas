unit UtilityFunctions;

interface
uses
{$IFDEF USE_SPRING4D}
  Spring.Collections,
  Spring.Collections.Lists
{$ELSE}
  System.Generics.Collections // TList
{$ENDIF}
  ;

type
  IEnumValueRange = interface
    function GetMinValue: Integer;
    function GetMaxValue: Integer;
    function InBounds(const AValue: Integer): Boolean;
  end;

  TEnumConverter = class
  private const
    sEnumRangeError = 'Enum out of bounds';
    type PByteRec = ^ByteRec;
         ByteRec = packed record
           case Integer of
             0: (AByte: UInt8);
             1: (AWord: UInt16);
             2: (ALongWord: UInt32);
         end;
    class procedure CheckRangeAndRaise<T>(const IntValue: Integer);
  public
      // converts an enum value to Integer
    class function EnumToInt<T>(const EnumValue: T): Integer;
      // converts Integer value to enum with range check
    class function IntToEnum<T>(const IntValue: Integer): T; static;
      // converts enum to corresponding string
    class function EnumToString<T>(EnumValue: T): string;
      // converts string to corresponding enum, raises ERangeError for invalid values
    class function StringToEnum<T>(StringValue: string): T;
      // increment or decrement enum value with range check
    class function Inc<T>(const EnumValue: T; const ByValue: Integer = 1): T;
    class function Dec<T>(const EnumValue: T; const ByValue: Integer = 1): T;
    class function Succ<T>(const EnumValue: T): T;
    class function Pred<T>(const EnumValue: T): T;
      // get a list of strings for enum values
{$IFDEF USE_SPRING4D}
    class function GetValueList<T>: IList<string>;
{$ELSE}
    class function GetValueList<T>: TList<string>;
{$ENDIF}
      // get min/max Integer values for any enum
    class function Range<T>: IEnumValueRange;
  end;

  TEnumValueRange = class(TInterfacedObject, IEnumValueRange)
  strict private
    FMinValue: Integer;
    FMaxValue: Integer;
  public
    constructor Create(MinValue, MaxValue: Integer);
    function GetMinValue: Integer;
    function GetMaxValue: Integer;
    function InBounds(const AValue: Integer): Boolean;
  end;

implementation
uses
  System.SysUtils, // ERangeError
  System.TypInfo;


{ TEnumConverter }

class procedure TEnumConverter.CheckRangeAndRaise<T>(const IntValue: Integer);
begin
    // range check
  if not TEnumConverter.Range<T>.InBounds(IntValue) then
    raise ERangeError.Create(sEnumRangeError);
end;

class function TEnumConverter.EnumToInt<T>(const EnumValue: T): Integer;
var PResult: PByteRec;
begin
  PResult := @EnumValue;
  case SizeOf(EnumValue) of
    1: Result := PResult^.AByte;
    2: Result := PResult^.AWord;
    4: Result := PResult^.ALongWord;
  else
    raise ERangeError.Create(sEnumRangeError);
  end;
end;

class function TEnumConverter.IntToEnum<T>(const IntValue: Integer): T;
var PEnum: PByteRec;
begin
  TEnumConverter.CheckRangeAndRaise<T>(IntValue);

  PEnum := @Result;
  case SizeOf(T) of
    1: PEnum^.AByte := IntValue;
    2: PEnum^.AWord := IntValue;
    4: PEnum^.ALongWord := IntValue;
  else
    raise ERangeError.Create(sEnumRangeError);
  end;
end;

class function TEnumConverter.EnumToString<T>(EnumValue: T): string;
var LEnumValue: Integer;
begin
  LEnumValue := EnumToInt(EnumValue);
  Result := GetEnumName(TypeInfo(T), LEnumValue);
end;

class function TEnumConverter.StringToEnum<T>(StringValue: string) : T;
var LEnumValue: Integer;
begin
  LEnumValue := GetEnumValue(TypeInfo(T), StringValue);
  Result := TEnumConverter.IntToEnum<T>(LEnumValue);
end;

class function TEnumConverter.Inc<T>(const EnumValue: T;
  const ByValue: Integer = 1): T;
var LIntValue: Integer;
begin
  LIntValue := TEnumConverter.EnumToInt<T>(EnumValue);
  System.Inc(LIntValue, ByValue);
  TEnumConverter.CheckRangeAndRaise<T>(LIntValue);
  Result := IntToEnum<T>(LIntValue);
end;

class function TEnumConverter.Dec<T>(const EnumValue: T;
  const ByValue: Integer = 1): T;
begin
  Result := TEnumConverter.Inc<T>(EnumValue, -ByValue);
end;

class function TEnumConverter.Succ<T>(const EnumValue: T): T;
begin
  Result := TEnumConverter.Inc<T>(EnumValue);
end;

class function TEnumConverter.Pred<T>(const EnumValue: T): T;
begin
  Result := TEnumConverter.Dec<T>(EnumValue);
end;

{$IFDEF USE_SPRING4D}
class function TEnumConverter.GetValueList<T>(): IList<string>;
{$ELSE}
class function TEnumConverter.GetValueList<T>(): TList<string>;
{$ENDIF}
var LPTypeData: PTypeData;
    LPSymbolList: Pointer;
    LMinValue,
    LMaxValue: Integer;
begin
  Result := TList<string>.Create;

  LPTypeData := GetTypeData(TypeInfo(T));
  LMinValue := LPTypeData^.MinValue;
  LMaxValue := LPTypeData^.MaxValue;
  LPSymbolList := @(LPTypeData^.NameList);
  for var i := LMinValue to LMaxValue do
  begin
    Result.Add(UTF8IdentToString(LPSymbolList));
    var LengthPlusOne := Succ(PByte(LPSymbolList)^);
    Cardinal(LPSymbolList) := Cardinal(LPSymbolList) + LengthPlusOne;
  end;
end;

class function TEnumConverter.Range<T>: IEnumValueRange;
var LPTypeData: PTypeData;
begin
  LPTypeData := GetTypeData(TypeInfo(T));
  Result := TEnumValueRange.Create(LPTypeData^.MinValue, LPTypeData^.MaxValue);
end;

{ TEnumValueRange }

constructor TEnumValueRange.Create(MinValue, MaxValue: Integer);
begin
  FMinValue := MinValue;
  FMaxValue := MaxValue;
end;

function TEnumValueRange.GetMaxValue: Integer;
begin
  Result := FMaxValue;
end;

function TEnumValueRange.GetMinValue: Integer;
begin
  Result := FMinValue;
end;

function TEnumValueRange.InBounds(const AValue: Integer): Boolean;
begin
  Result := (AValue >= FMinValue) and (AValue <= FMaxValue);
end;

end.
