unit DataTransferHelper;

interface
uses
  System.Classes,
  System.Rtti,
  System.Generics.Collections;

type
  TComponentLink = record
    AComponent: TComponent;
    AFieldName: string;
    APropertyName: string;
  end;

  TDataTransferObject = class
  private
    FContext: TRttiContext;
    FLinks: TList<TComponentLink>;
    procedure _Distribute(const FieldName: string; Component: TComponent; SourceProperty: string);
    procedure _Collect(const FieldName: string; Component: TComponent; SourceProperty: string);
  public
    constructor Create;

    function Fields: TList<string>;
    function GetVariant(const FieldName: string): Variant;
    function AsString(const FieldName: string): string;
    procedure AddControlLink(const FieldName: string; Component: TComponent; SourceProperty: string);
    procedure ClearControlLinks;
    procedure Distribute;
    procedure Collect;
  end;

implementation
uses
  System.SysUtils,
  System.Variants,
  System.TypInfo;

{ TDataTransferObject }

procedure TDataTransferObject.ClearControlLinks;
begin
  if Assigned(FLinks) then
    FreeAndNil(FLinks);
end;

procedure TDataTransferObject.AddControlLink(const FieldName: string; Component: TComponent;
  SourceProperty: string);
var ARec : TComponentLink;
begin
 if not Assigned(FLinks) then
   FLinks := TList<TComponentLink>.Create;

  ARec.AFieldName := FieldName;
  ARec.AComponent := Component;
  ARec.APropertyName := SourceProperty;
  FLinks.Add(ARec);
end;

procedure TDataTransferObject.Collect;
var LLink: TComponentLink;
begin
  for LLink in FLinks do
    _Collect(LLink.AFieldName, LLink.AComponent, LLink.APropertyName);
end;

procedure TDataTransferObject.Distribute;
var LLink: TComponentLink;
begin
  for LLink in FLinks do
    _Distribute(LLink.AFieldName, LLink.AComponent, LLink.APropertyName);
end;

function TDataTransferObject.AsString(const FieldName: string): string;
var LValue: Variant;
    LInfoS: string;
begin
  LValue := GetVariant(FieldName);
  if(VarType(LValue) = varString) or (VarType(LValue) = varUString) then
    Result := LValue
  else if(VarType(LValue) = varBoolean) then
  begin
    if LValue then
      Result := 'True'
    else
      Result := 'False';
  end
  else if(VarType(LValue) = varInteger) then
    Result := IntToStr(LValue)
  else
    raise Exception.CreateFmt('Field %s is of unknown type (allowed: string, Integer, Boolean)', [FieldName]);
end;

constructor TDataTransferObject.Create;
begin
  FContext := TRttiContext.Create;
end;

  // returns a list of all public fields in the dto
function TDataTransferObject.Fields: TList<string>;
var Lrti: TRTTIType;
    LField: TRTTIField;
    LType: TRTTIType;
begin
  Result := TList<string>.Create;
  Lrti := FContext.GetType(Self.ClassType);
  for LField in Lrti.GetFields do
     if LField.Visibility = mvPublic then
       Result.Add(LField.Name);
end;

function TDataTransferObject.GetVariant(const FieldName: string): Variant;
var LField: TRTTIField;
    LValue: Variant;
begin
  LField := FContext.GetType(Self.ClassType).GetField(FieldName);
  Result := LField.GetValue(Self).AsVariant;
end;

  // export a value to a form control
procedure TDataTransferObject._Distribute(const FieldName: string; Component: TComponent;
  SourceProperty: string);
var LField: TRTTIProperty;
    LValue: Variant;
    LType: TRTTIType;
    tString: string;
    tBool: Boolean;
    tInteger: Integer;
begin
  LType := FContext.GetType(Component.ClassType);
  LField := LType.GetProperty(SourceProperty);
  if SourceProperty = 'Checked' then // Boolean
  begin
    tBool := GetVariant(FieldName);
    LField.SetValue(Component, tBool);
  end
  else if(SourceProperty = 'Text') or (SourceProperty = 'Caption') then // string
  begin
    tString := AsString(FieldName);
    LField.SetValue(Component, tString);
  end;

end;

  // import a value from a form control
procedure TDataTransferObject._Collect(const FieldName: string; Component: TComponent;
  SourceProperty: string);
var LOwnField: TRTTIField;
    LForeignProperty: TRTTIProperty;
    LValue: Variant;
    LType: TRTTIType;
    tString: string;
    tBool: Boolean;
    tInteger: Integer;
begin
    // type of field to write (string, Integer, Boolean)
  LOwnField := FContext.GetType(Self.ClassType).GetField(FieldName);
    // the linked property + value
  LForeignProperty := FContext.GetType(Component.ClassType).GetProperty(SourceProperty);
  LValue := LForeignProperty.GetValue(Component).AsVariant;
  var test := LOwnField.FieldType.ToString;
    // target is a string?
  if(LOwnField.FieldType.TypeKind = tkUString) then
  begin
    if(VarType(LValue) = varUString) then
      tString := LValue
    else if(VarType(LValue) = varInteger) then
      tString := IntToStr(LValue);
    LOwnField.SetValue(Self, tString);
  end
  else if (LOwnField.FieldType.ToString = 'Boolean') then
  begin
    tBool := LValue;
    LOwnField.SetValue(Self, tBool);
  end
  else if(LOwnField.FieldType.TypeKind = tkInteger) then
  begin
    tString := LValue;
    if TryStrToInt(tString, tInteger) then
      LOwnField.SetValue(Self, tInteger);
  end;
end;

end.
