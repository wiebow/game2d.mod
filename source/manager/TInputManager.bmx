
Rem
	bbdoc: Reconfigurable Input device.
	about: For now, only support for keyboard input.
EndRem
Type TInputManager

	Global instance:TInputManager


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


	Function GetInstance:TInputManager()
		If instance = Null Then Return New TInputManager
		Return instance
	End Function

	

	Method New()
		If instance Then Throw "Unable to create instance of singleton class"

		instance = Self

		controls = New TBag
		configuring = false
		deviceMode = MODE_KEYBOARD
	End Method


	Method Delete()
	End Method


	Method Destroy()
		instance = Null
	End Method



	Method StartConfiguring()
		if configuring = true then return
		configuring = true
		configureStep = STEP_ASKDEVICE
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


	Method GetKeyFor:String( controlName:String)
		For Local index:Int = 0 Until controls.GetSize()
			Local c:TKeyControl = TKeyControl(controls.Get(index))
			if c.GetName() = controlName then return c.GetMappedKey()
		Next
		RuntimeError( "Cannot find control with name: " + controlName )
	EndMethod
	


	'reconfigure key mapped to control
	Method SetControlKey(controlName:String, key:Int)
		Self.GetKeyControl(controlName).SetKey(key)
	End Method
	

	Method Update()
		if configuring
			'color flash delay for attention text
			colorFlashCounter:+1

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
'						FlushKeys()
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
	Method RenderAskDevice()
		Local ypos:Int = 20
		SetGameColor( BLUE )
		If deviceMode = MODE_KEYBOARD
			RenderText("Keyboard", 0, ypos, true, true)
			ypos:+15
			SetGameColor( WHITE )
			For Local index:Int = 0 Until controls.GetSize()
				RenderText( TKeyControl(controls.Get(index)).ToString(), 0, ypos, true, true)
				ypos:+9
			Next
		Elseif deviceMode = MODE_JOYPAD
			RenderText("Gamepad", 0, ypos, true, true)
			ypos:+15
			'......
		EndIf

		SetGameColor( WHITE )
		RenderText("[ESCAPE] back  [F12] Configure", 0, GameHeight()-20, true, true)
	EndMethod


	Method RenderKeyConfigure()	
		local ypos:Int = 20
		SetGameColor( BLUE )
		RenderText("Keyboard", 0, ypos, true, true)
		ypos:+15
		SetGameColor( WHITE )
		For Local index:Int = 0 Until controls.GetSize()
			SetGameColor( WHITE )
			if index = controlIndex then SetGameColor( GREEN )
			RenderText( TKeyControl(controls.Get(index)).ToString(), 0, ypos, true, true)
			ypos:+9
		Next

		if colorFlashCounter Mod 20 = 0 then colorHighLight = not colorHighLight
		if not colorHighLight
			SetGameColor( RED )
		Else
			SetGameColor( WHITE )
		endif
		RenderText("Select new key for '"+ TKeyControl(controls.Get(controlIndex)).GetName()+"'", 0, GameHeight()-30, true, true )

		SetGameColor( WHITE )
		RenderText("[ESCAPE] cancel", 0, GameHeight()-20, true, true )		
	EndMethod
	

	Method RenderPadConfigure()
		local ypos:Int = 30
		SetGameColor( BLUE )
		RenderText("Gamepad", 0, ypos, true, true)
		ypos:+15
		SetGameColor( WHITE )
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

			SetOrigin(TVirtualGfx.VG.vxoff, TVirtualGfx.VG.vyoff)

			'render menu border
			local r:Int, g:int, b:Int
			G_CURRENTGAME.GetMenuBackdropColor(r,g,b)
			SetColor(r, g, b)

			'determine needed height
'			local height:Int = controls.GetSize()
'			height:+4  '(top and bottom text +spacing)
'			height:* 10

			SetAlpha(0.9)
			DrawRect(5, 5, GameWidth()-10, GameHeight()-10)
'			DrawRect(5, GameHeight() - 10 - height , GameWidth() - 10, height )
			SetAlpha(1.0)

			SetGameColor( CYAN )
			RenderText("Configure Controls", 0, 10, true, true)

			'where are we in the config process
			Select configureStep
				Case STEP_ASKDEVICE 	RenderAskDevice()
				Case STEP_KEYCONTROLS	RenderKeyConfigure()
				Case STEP_PADCONTROLS	RenderPadConfigure()
			EndSelect

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


' ----------------------------------------


	Rem
		bbdoc:   Adds a key control to the game
		about:   Uses value in ini file if it exists
		returns: 
	EndRem
	Function AddKeyControl(c:TKeyControl)
		G_CURRENTGAME.AddKeyControl( c )
	EndFunction


	Rem
		bbdoc:   Returns a control by name.
		about:
		returns: TControl
	EndRem
	Function GetKeyControl:TControl(name:String)
		Return TInputManager.GetInstance().GetKeyControl(name)
	end Function


	Rem
		bbdoc:   Returns control key status.
		returns: Int
	EndRem
	Function KeyControlDown:Int(controlName:String)
		Return TInputManager.GetInstance().GetKeyDown(controlName)
	EndFunction


	Rem
		bbdoc:   Returns control key hits since last update.
		returns: Int
	EndRem
	Function KeyControlHit:Int(controlName:String)
		Return TInputManager.GetInstance().GetKeyHit(controlName)
	EndFunction


	Rem
		bbdoc:   Starts the input configuration process
	EndRem
	Function StartConfigureControls()
		TInputManager.GetInstance().StartConfiguring()
	EndFunction
