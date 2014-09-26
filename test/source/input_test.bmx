

Type TInputType Extends TTest

	Field i:TInputManager

	Method _setup() {before}
		i = TInputManager.GetInstance()
	End Method

	Method _teardown() {after}
		TInputManager.GetInstance().Destroy()
		i = null
	End Method

	Method testConstructor() {test}
		AssertNotNull(i, "cannot create input")
	End Method


	Method testAddKeyControl() {test}
		Local c:TKeyControl = TKeyControl.Create("UP", KEY_A)
		i.AddKeyControl(c)
		AssertSame(c, i.GetKeyControl("UP"), "cannot get UP control")
	End Method

End Type