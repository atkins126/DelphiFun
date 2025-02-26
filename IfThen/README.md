# A look at IfThen

At some point in time every Delphi programmer writes some generic IfThen class like this:

```
type
  IfThen<T> = class
  public
    class function Get(Condition: Boolean; WhenTrue: T; WhenFalse: T): T;
  end;
```

This works well with constants but has a major drawback when using IfThen for time consuming operations, like selecting
rows from a database based on the condition.
The Delphi compiler executes the code to evaluate both expressions WhenTrue and WhenFalse, passes these values to the IfThen<T>
function and let's it select the appropriate result.
**Both WhenTrue and WhenFalse are calculated** no matter the boolean expression.

So, the IfThen class from UtilityFunctions.pas is my suggestion to solve the problem. See the Test for examples.