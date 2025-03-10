unit IfThenTest;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestIfThen = class
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

function TTestIfThen.LazyGetYes: string;
begin
  FCalculatedYes := True;
  Result := 'Yes';
end;

function TTestIfThen.LazyGetNo: string;
begin
  FCalculatedNo := True;
  Result := 'No';
end;

procedure TTestIfThen.TestIfThenBothConstants;
begin
  Assert.AreEqual('Yes', IfThen<string>.Get(True, 'Yes', 'No'));
  Assert.IsTrue(IfThen<Boolean>.Get(True, True, False));
end;

procedure TTestIfThen.TestIfThenBothLazy;
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

procedure TTestIfThen.TestIfThenLeftLazy;
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

procedure TTestIfThen.TestIfThenRightLazy;
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
  TDUnitX.RegisterTestFixture(TTestIfThen);

end.
