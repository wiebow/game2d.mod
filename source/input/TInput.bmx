
Rem
	bbdoc: Reconfigurable Input device.
	about: For now, only support for keyboard input.
EndRem
Type TInput

	'all controls
	Field controls:TBag

	'input device is in this mode
	Field deviceMode:Int
	Const MODE_KEYBOARD:Int = 0
	Const MODE_JOYPAD:Int=1

	'detected gamepad id
	Field joypadID:Int 

	'true when input device is being configured
	Field configuring:Int
	'current index of control when reconfiguring
	Field controlIndex:Int
	'where are we in the configure proces
	Field configureStep:Int
	Const STEP_ASKDEVICE:Int = 0
	Const STEP_KEYCONTROLS:Int = 1
	Const STEP_PADCONTROLS:Int = 2

	'used to determine color cycle speed
	Field colorFlashCounter:Int
	'white or color
	field colorHighLight:Int



	Method New()
		controls = New TBag
		configuring = false
		deviceMode = MODE_KEYBOARD
	EndMethod


	Method StartConfiguring()
		if configuring = true then return
		configuring = true
		configureStep = STEP_ASKDEVICE
'		FlushKeys()
	EndMethod


	Method IsConfiguring:Int ()
		return configuring
	EndMethod


	Method GetKeyDown:Int(controlName:String)
		return Self.GetKeyControl(controlName).GetDown()
	EndMethod


	Method GetKeyHit:Int (controlName:String)
		return Self.GetKeyControl(controlName).GetHit()
	EndMethod


	Method AddKeyControl(c:TKeyControl)
		controls.Add(c)
	EndMethod


	'returns a control by name
	Method GetKeyControl:TKeyControl (controlName:String)
		For Local index:Int = 0 Until controls.GetSize()
			Local c:TKeyControl = TKeyControl(controls.Get(index))
			if c.GetName() = controlName then return c
		Next
		RuntimeError( "Cannot find control with name: " + controlName )
	EndMethod


	'reconfigure key mapped to control
	Method SetControlKey(controlName:String, key:Int)
		Self.GetKeyControl(controlName).SetKey(key)
	End Method
	

	Method Update()

		'color flash delay for attention text
		colorFlashCounter:+1

		if configuring

			'escape keys walks back through screens
			If keyhit(KEY_ESCAPE)
				if configureStep = STEP_ASKDEVICE
					configuring = false
					return
				endif

				if configureStep = STEP_KEYCONTROLS or configureStep = STEP_PADCONTROLS then configureStep = STEP_ASKDEVICE
				return
			Endif

			'askdevice step keys
			if configureStep = STEP_ASKDEVICE
				if KeyHit( KEY_1 )
					deviceMode = MODE_KEYBOARD
					return
				elseif KeyHit( KEY_2 )
					deviceMode = MODE_JOYPAD
					return
				elseif KeyHit(KEY_F12)
					if deviceMode = MODE_KEYBOARD
						configureStep = STEP_KEYCONTROLS
						controlIndex = 0
						FlushKeys()
						return
					endif
					if deviceMode = MODE_JOYPAD
						configureStep = STEP_PADCONTROLS
						return
					endif					
				endif
				
			endif

			'what to do in which mode and step?
			if configureStep = STEP_KEYCONTROLS then ScanKeys()
'			if configureStep = STEP_PADCONTROLS
'			endif

		Else
			'normal update get input for game
			Select deviceMode
				Case MODE_KEYBOARD
					For Local index:Int = 0 until controls.GetSize()
						TControl(controls.Get(index)).Update()
					Next
				case MODE_JOYPAD

			End Select

		Endif
	End Method


	'keyboard configure scan method
	Method ScanKeys()
		For Local keyCode:Int = 0 To 200
			if keyhit(keyCode) = 1

				'skip keys we cannot use
				'back key, show control and configure controls
				if keyCode = KEY_ESCAPE or keyCode = KEY_F11 or keyCode =KEY_F12 then exit

				'set this scanned keycode to current control
				TKeyControl(controls.Get(controlIndex)).SetKey(keyCode)

				'next control
				controlIndex:+ 1

				'show device when last control done
				if controlIndex => controls.GetSize()
					configureStep = STEP_ASKDEVICE
					Return
				endif

				'reconfigured this control. done.
				exit
			endif
		Next
	EndMethod


	'renders current config and question for device selection
	Method RenderAskDevice ()
		Local ypos:Int = 30
		SetColor(100,100,255)		
		If deviceMode = MODE_KEYBOARD
			RenderText("Keyboard", 0, ypos, true, true)
			ypos:+15
			SetColor(255,255,255)
			For Local index:Int = 0 Until controls.GetSize()
				RenderText( TKeyControl(controls.Get(index)).ToString(), 0, ypos, true, true)
				ypos:+9
			Next
		Elseif deviceMode = MODE_JOYPAD
			RenderText("Gamepad", 0, ypos, true, true)
			ypos:+15
			'......
		EndIf

		'then ask which device to select or configure
		'for now, only keyboard!!!
		Setcolor(255,255,255)
'		RenderText("[1] Keyboard, [2] Gamepad", 0, GameHeight()-45, true, true)
		RenderText("[F12] Configure", 0, GameHeight()-35, true, true)
	EndMethod


	Method RenderKeyConfigure()	
		local ypos:Int = 30
		SetColor(100,100,255)
		RenderText("Keyboard", 0, ypos, true, true)
		ypos:+15
		SetColor(255,255,255)
		For Local index:Int = 0 Until controls.GetSize()
			SetColor(255,255,255)
			if index = controlIndex then SetColor(100,255,100)
			RenderText( TKeyControl(controls.Get(index)).ToString(), 0, ypos, true, true)
			ypos:+9
		Next

		if colorFlashCounter Mod 20 = 0 then colorHighLight = not colorHighLight
		if not colorHighLight
			SetColor(255,50,50)
		Else
			SetColor(255,255,255)
		endif
		RenderText("Select new key for '"+ TKeyControl(controls.Get(controlIndex)).GetName()+"'", 0, GameHeight()-35, true, true )
	EndMethod
	

	Method RenderPadConfigure()
		local ypos:Int = 30
		SetColor(100,100,255)
		RenderText("Gamepad", 0, ypos, true, true)
		ypos:+15
		SetColor(255,255,255)
		Local padCount:Int = JoyCount()
		if padCount = 0
			RenderText("No gamepad detected :(", 0, ypos, true, true)
			joypadID = -1  ' no pad present
		Else
			'render first pad detected
			joypadID = 0
			RenderText("Name: " + JoyName(0), 0, ypos, true, true )
		endif
	EndMethod	


	Method Render()
		if configuring
			TRenderState.Push()
			TRenderState.Reset()

			'render black border
			SetColor(0, 0, 0)
			SetAlpha(0.9)
			DrawRect(5, 5, GameWidth()-10, GameHeight()-10)
			SetAlpha(1.0)

			SetColor(100,255,255)
			RenderText("Configure Controls", 0, 10, true, true)

			'where are we in the config process
			Select configureStep
				Case STEP_ASKDEVICE		RenderAskDevice()
				Case STEP_KEYCONTROLS	RenderKeyConfigure()
				Case STEP_PADCONTROLS	RenderPadConfigure()
			EndSelect

			'draw footer text
			SetColor(255,255,255)
			RenderText("[ESC] back", 0, GameHeight()-20, true, true)

			TRenderState.Pop()
		endif
	EndMethod


	'put settings to passed ini file
	Method ToIniFile(i:TINIFile)

		'do all key controls
		For Local index:Int = 0 Until controls.GetSize()
			Local c:TKeyControl = TKeyControl(controls.Get(index))
			i.SetIntValue("Input", c.GetName(), c.keyCode)
		Next
	EndMethod
	
EndType