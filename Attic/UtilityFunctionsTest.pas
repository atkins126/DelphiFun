unit IfThenTest;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestUtilityFunctions = class
  private
    FCalculatedYes: Boolean;
    FCalculatedNo: Boolean;
    function LazyGetYes: string;
    function LazyGetNo: string;
  public

    [Test]
    procedure TestIfThenBothConstants;
    [Test]
    procedure TestIfThenBothLazy;
    [Test]
    procedure TestIfThenLeftLazy;
    [Test]
    procedure TestIfThenRightLazy;

 end;

implementation
uses
  UtilityFunctions;

{ TUtilityFunctionTest }

function TTestUtilityFunctions.LazyGetYes: string;
begin
  FCalculatedYes := True;
  Result := 'Yes';
end;

function TTestUtilityFunctions.LazyGetNo: string;
begin
  FCalculatedNo := True;
  Result := 'No';
end;

procedure TTestUtilityFunctions.TestIfThenBothConstants;
begin
  Assert.AreEqual('Yes', IfThen<string>.Get(True, 'Yes', 'No'));
  Assert.IsTrue(IfThen<Boolean>.Get(True, True, False));
end;

procedure TTestUtilityFunctions.TestIfThenBothLazy;
begin
  FCalculatedYes := False;
  FCalculatedNo := False;
  Assert.AreEqual('Yes', IfThen<string>.Get(True,
    function: string
    begin
      Result := LazyGetYes;
    end,
    function: string
    begin
      Result := LazyGetNo;
    end));
  Assert.IsTrue(FCalculatedYes, 'Yes was not calculated');
  Assert.IsFalse(FCalculatedNo, 'No was needlessly calculated');
end;

procedure TTestUtilityFunctions.TestIfThenLeftLazy;
begin
    // Lazy right constant
  FCalculatedYes := False;
  FCalculatedNo := False;
  Assert.AreEqual('No', IfThen<string>.Get(False,
    'Yes',
    function: string
    begin
      Result := LazyGetNo;
    end));
  Assert.IsTrue(FCalculatedNo, 'No was not calculated');
end;

procedure TTestUtilityFunctions.TestIfThenRightLazy;
begin
  FCalculatedYes := False;
  FCalculatedNo := False;
  Assert.AreEqual('Yes', IfThen<string>.Get(True,
    function: string
    begin
      Result := LazyGetYes;
    end,
    'No'));
  Assert.IsTrue(FCalculatedYes, 'Yes was not calculated');
end;

initialization
  TDUnitX.RegisterTestFixture(TTestUtilityFunctions);

end.
