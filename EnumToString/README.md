# TEnumConverter

Provides conversion between Enum, Integer and strings. It also allows incrementing (select next enum value) and decrementing
(selecting previous enum value), getting a list of all enum values as strings, finding the upper and lower bounds of the
enum values and testing if an Integer is within the valid bounds of an enum type.

Explicit type casts create a possibility of circumventing compiler range checks. Therefore all functions have a range check and 
will raise an ERangeError exception if any invalid integer is attempted to be converted to an enum or an invalid string is 
attempted to be converted to an enum.

I use Spring4D in all but the smallest projects. Defining the USE_SPRING4D compiler condition will make GetValueList<T> return
an interfaced IList. If USE_SPRING4D is omitted it returns a TList<string> instead which is owned by the calling process and
must be freed manually.

Usage: Please refer to EnumConverterTest.pas

```
  IEnumValueRange = interface
    function GetMinValue: Integer;
    function GetMaxValue: Integer;
    function InBounds(const AValue: Integer): Boolean;
  end;

  TEnumConverter = class
[...]
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
class function GetValueList<T>: IList<string>;
class function GetValueList<T>: TList<string>; { when USE_SPRING4D is undefined }
  // get min/max Integer values for any enum
class function Range<T>: IEnumValueRange;
```

Do not instantiiate this class, it only contains class functions.

I had to place the default implementation of IEnumValueRange (TEnumValueRange) at the interface section although
it doesn't belong there to get rid of a compiler error E2506.
