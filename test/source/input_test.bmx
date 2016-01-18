
' tests for the input manager.
' and the TKeyControl type

Type TInputManagerTest Extends TTest

	Field i:TInputManager

	Method _setup() {before}
		i = TInputManager.GetInstance()
	End Method

	Method _teardown() {after}
		TInputManager.GetInstance().Destroy()
		i = null
	End Method

' -----------------------------

	Method TestConstructor() {test}
		AssertNotNull(i, "cannot create input manager.")
		AssertNotNull(i.controls, "controls bag not created.")
	End Method


	Method TestConfiguring() {test}
		StartConfigureControls()
		AssertTrue( ConfiguringControls(), "configure mode not set.")
		AssertEqualsI(TInputManager.STEP_SHOWDEVICE, i.configureStep, "show device not set.")
	End Method


	Method TestStartAudioConfig() {test}
		i.StartAudioConfig()

		AssertTrue( ConfiguringControls(), "configure mode not set")
		AssertEqualsI(TInputManager.STEP_SHOWAUDIO, i.configureStep, "showaudio step not set.")
	End Method


	Method testAddKeyControl() {test}
		Local c:TKeyControl = TKeyControl.Create("UP", KEY_A)
		i.AddKeyControl(c)
		AssertSame(c, GetKeyControl("UP"), "cannot get UP control.")
	End Method


	Method TestGetKeyFor() {test}
		Local c:TKeyControl = TKeyControl.Create("UP", KEY_A)
		i.AddKeyControl(c)

		AssertEquals("A", i.GetKeyFor("UP"), "keycontrol not set to A.")
	End Method


	Method TestSetControlKey() {test}
		Local c:TKeyControl = TKeyControl.Create("UP", KEY_A)
		i.AddKeyControl(c)

		i.SetControlKey("UP", KEY_B)
		AssertEquals("B", i.GetKeyFor("UP"), "keycontrol not changed to B.")
	End Method

End Type
