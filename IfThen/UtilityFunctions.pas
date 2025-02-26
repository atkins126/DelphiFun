unit UtilityFunctions;

interface

type
  TLazyCalcFunc<T> = reference to function: T;
  IfThen<T> = class
  public
    class function Get(Condition: Boolean; WhenTrue: T; WhenFalse: T): T; overload;
    class function Get(Condition: Boolean; WhenTrue, WhenFalse: TLazyCalcFunc<T>): T; overload;
    class function Get(Condition: Boolean; WhenTrue: T; WhenFalse: TLazyCalcFunc<T>): T; overload;
    class function Get(Condition: Boolean; WhenTrue: TLazyCalcFunc<T>; WhenFalse: T): T; overload;
  end;

implementation

{ IfThen<T> }

class function IfThen<T>.Get(Condition: Boolean; WhenTrue, WhenFalse: T): T;
begin
  if Condition then
    Result := WhenTrue
  else
    Result := WhenFalse;
end;

class function IfThen<T>.Get(Condition: Boolean; WhenTrue, WhenFalse: TLazyCalcFunc<T>): T;
begin
  if Condition then
    Result := WhenTrue
  else
    Result := WhenFalse;
end;

class function IfThen<T>.Get(Condition: Boolean; WhenTrue: TLazyCalcFunc<T>; WhenFalse: T): T;
begin
  if Condition then
    Result := WhenTrue
  else
    Result := WhenFalse;
end;

class function IfThen<T>.Get(Condition: Boolean; WhenTrue: T; WhenFalse: TLazyCalcFunc<T>): T;
begin
  if Condition then
    Result := WhenTrue
  else
    Result := WhenFalse;
end;


end.
