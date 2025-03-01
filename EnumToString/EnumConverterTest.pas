unit EnumConverterTest;

interface

uses
{$IFDEF USE_SPRING4D}
  Spring.Collections,
  Spring.Collections.Lists, // IList
{$ELSE}
  System.Generics.Collections, // TList
{$ENDIF}
  DUnitX.TestFramework;

type

  TestEnum = (צהü {!}, One, Two, Three, Four, Five, Six, Seven, Eight, Nine);

  TDestroyListProc = reference to procedure(AList: TObject);
{$IFDEF USE_SPRING4D}
  ListType = IList<string>;
{$ELSE}
  ListType = System.Generics.Collections.TList<string>;
{$ENDIF}

  [TestFixture]
  TTestEnumConverter = class
  public
    const EnumList: array[0..9] of TestEnum =
      (צהü {!}, One, Two, Three, Four, Five, Six, Seven, Eight, Nine);
    const ExpectedResults: array[0..9] of string =
      ('צהü' {!}, 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine');

    [Test]
    procedure TestEnumToString;
    [Test]
    procedure TestEnumToInt;
    [Test]
    procedure TestIntToEnum;
    [Test]
    procedure TestStringToEnum;
    [Test]
    procedure TestIncrementEnum;
    [Test]
    procedure TestDecrementEnum;
    [Test]
    procedure TestGetValueList;
    [Test]
    procedure TestRange;
  end;

implementation
uses
  System.SysUtils, // ERangeError
  UtilityFunctions;

{ TTestEnumConverter }

procedure TTestEnumConverter.TestEnumToString;
begin
  for var i := Low(ExpectedResults) to High(ExpectedResults) do
  begin
    Assert.AreEqual(ExpectedResults[i], TEnumConverter.EnumToString<TestEnum>(EnumList[i]));
  end;
end;

procedure TTestEnumConverter.TestIntToEnum;
var LTestEnum : TestEnum;
begin
  for var i := Low(ExpectedResults) to High(ExpectedResults) do
  begin
    Assert.AreEqual(EnumList[i], TEnumConverter.IntToEnum<TestEnum>(i));
  end;

  Assert.WillRaise(
    procedure
    begin
      LTestEnum := TEnumConverter.IntToEnum<TestEnum>(High(ExpectedResults)+1);
    end,
    ERangeError
  );
end;

procedure TTestEnumConverter.TestStringToEnum;
var LTestEnum : TestEnum;
begin
  for var i := Low(ExpectedResults) to High(ExpectedResults) do
  begin
    Assert.AreEqual(EnumList[i], TEnumConverter.StringToEnum<TestEnum>(ExpectedResults[i]));
  end;

  Assert.WillRaise(
    procedure
    begin
      LTestEnum := TEnumConverter.StringToEnum<TestEnum>('Ten');
    end,
    ERangeError
   );
end;

procedure TTestEnumConverter.TestEnumToInt;
begin
  for var i := Low(ExpectedResults) to High(ExpectedResults) do
  begin
    Assert.AreEqual<Integer>(i, TEnumConverter.EnumToInt<TestEnum>(EnumList[i]));
  end;
end;

procedure TTestEnumConverter.TestIncrementEnum;
begin
  for var i := Low(ExpectedResults) to High(ExpectedResults)-1 do
  begin
    Assert.AreEqual(EnumList[i+1], TEnumConverter.Inc<TestEnum>(EnumList[i]));
    Assert.AreEqual(EnumList[i+1], TEnumConverter.Succ<TestEnum>(EnumList[i]));
  end;
end;

procedure TTestEnumConverter.TestDecrementEnum;
begin
  for var i := Low(ExpectedResults)+1 to High(ExpectedResults) do
  begin
    Assert.AreEqual(EnumList[i-1], TEnumConverter.Dec<TestEnum>(EnumList[i]));
    Assert.AreEqual(EnumList[i-1], TEnumConverter.Pred<TestEnum>(EnumList[i]));
  end;
end;

procedure TTestEnumConverter.TestGetValueList;
var LList: ListType;
begin
  LList := TEnumConverter.GetValueList<TestEnum>;
  try
    var TestCount := High(ExpectedResults) - Low(ExpectedResults) + 1;
    Assert.AreEqual(TestCount, LList.Count);

    for var i := Low(ExpectedResults) to High(ExpectedResults) do
    begin
      Assert.AreEqual(ExpectedResults[i], LList[i]);
    end;
  finally
  {$IFNDEF USE_SPRING4D}
    FreeAndNil(LList);
  {$ENDIF}
  end;
end;

procedure TTestEnumConverter.TestRange;
var LRange: IEnumValueRange;
begin
  LRange := TEnumConverter.Range<TestEnum>;
  Assert.AreEqual(Low(ExpectedResults), LRange.GetMinValue);
  Assert.AreEqual(High(ExpectedResults), LRange.GetMaxValue);

  for var i := Low(ExpectedResults)-1 to High(ExpectedResults)+1 do
  begin
    if(i < Low(ExpectedResults)) or (i > High(ExpectedResults)) then
      Assert.IsFalse(LRange.InBounds(i))
    else
      Assert.IsTrue(LRange.InBounds(i));
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestEnumConverter);

end.
