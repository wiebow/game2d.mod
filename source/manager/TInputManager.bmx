
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
	Const STEP_SHOWDEVICE:Int = 0
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
		If instance Then Throw "TInputManager: Unable to create instance of singleton class"

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
		configureStep = STEP_SHOWDEVICE
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

		'keycontrol has a keycode.
		'if the control is present in the ini file, then use the key code in the ini file
		'and not the key code in the passed keycontrol.
		if G_CURRENTGAME.GetConfig().ParameterExists("Input", c.GetName())
			c.SetKey( G_CURRENTGAME.GetConfig().GetIntValue("Input", c.GetName()) )
		endif		
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
				if configureStep = STEP_SHOWDEVICE
					configuring = false
					return
				endif

				if configureStep = STEP_KEYCONTROLS or configureStep = STEP_PADCONTROLS then configureStep = STEP_SHOWDEVICE
				return
			Endif

			'askdevice step keys
			'switch between keys and pad is not yet supported.
			if configureStep = STEP_SHOWDEVICE
				if KeyHit( KEY_1 )
'					deviceMode = MODE_KEYBOARD
'					return
				elseif KeyHit( KEY_2 )
'					deviceMode = MODE_JOYPAD
'					return
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
					configureStep = STEP_SHOWDEVICE
					Return
				endif

				'reconfigured this control. done.
				exit
			endif
		Next
	EndMethod


	'renders current config
	Method RenderShowDevice( ypos:Int )
		local fontheight:Int = GetGameFontSize()

		SetGameColor( BLUE )
		If deviceMode = MODE_KEYBOARD
			RenderText("Keyboard", 0, ypos, true, true)
			ypos:+fontheight+2
			SetGameColor( WHITE )
			For Local index:Int = 0 Until controls.GetSize()
				RenderText( TKeyControl(controls.Get(index)).ToString(), 0, ypos, true, true)
				ypos:+fontheight
			Next
		Elseif deviceMode = MODE_JOYPAD
			RenderText("Gamepad", 0, ypos, true, true)
			ypos:+fontheight+2
			'......
		EndIf

		ypos:+ fontheight
		SetGameColor( WHITE )
		RenderText("[ESCAPE] back  [F12] Configure", 0, ypos, true, true)
	EndMethod


	Method RenderKeyConfigure( ypos:Int )	
		local fontheight:Int = GetGameFontSize()
		
		SetGameColor( BLUE )
		RenderText("Keyboard", 0, ypos, true, true)
		ypos:+fontheight+2
		For Local index:Int = 0 Until controls.GetSize()
			SetGameColor( WHITE )
			if index = controlIndex then SetGameColor( GREEN )
			RenderText( TKeyControl(controls.Get(index)).ToString(), 0, ypos, true, true)
			ypos:+fontheight
		Next

		if colorFlashCounter Mod 20 = 0 then colorHighLight = not colorHighLight
		if not colorHighLight
			SetGameColor( RED )
		Else
			SetGameColor( WHITE )
		endif
		RenderText("Select new key for '"+ TKeyControl(controls.Get(controlIndex)).GetName()+"'", 0, ypos, true, true )

		ypos:+ fontheight
		SetGameColor( WHITE )
		RenderText("[ESCAPE] cancel", 0, ypos, true, true )		
	EndMethod
	

	Method RenderPadConfigure( ypos:Int )
		local fontheight:Int = GetGameFontSize()

		SetGameColor( BLUE )
		RenderText("Gamepad", 0, ypos, true, true)

		ypos:+fontheight
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
			'take offset in mind when having left/right borders.
			SetOrigin(TVirtualGfx.VG.vxoff, TVirtualGfx.VG.vyoff)

			'render menu border
			local r:Int, g:int, b:Int
			G_CURRENTGAME.GetMenuBackdropColor(r,g,b)
			SetColor(r, g, b)

			'black menu border
			'get y size of border, 4 extra lines, extra padding of 4 pixels
			Local controlcount:Int = controls.GetSize()
			local fontheight:Int = GetGameFontSize()
			local boxheight:Int = 4 + ( 4 * fontheight ) + (controlcount * fontheight )
			'center
			local ypos:Int = GameHeight() / 2 - (boxheight/2)

			SetAlpha(0.90)
			DrawRect(5, ypos, GameWidth()-10, boxheight )
			SetAlpha(1.0)

			ypos:+2
			SetGameColor( CYAN )
			'where are we in the config process
			Select configureStep
				Case STEP_SHOWDEVICE
					RenderText("Current Controls", 0, ypos, true, true)
				 	RenderShowDevice( ypos +fontheight )
				Case STEP_KEYCONTROLS
					RenderText("Configure Controls", 0, ypos, true, true)
					RenderKeyConfigure( ypos +fontheight )
'				Case STEP_PADCONTROLS	RenderPadConfigure()
			EndSelect

	'		TRenderState.Pop()
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
	bbdoc:   Adds a key control to the game with the passed name and code.
	about:   Uses value in ini file if it exists
	returns: 
EndRem
Function AddKeyControl( controlName:String, code:Int ) ' c:TKeyControl)
	TInputManager.GetInstance().AddKeyControl( TKeyControl.Create( controlName, code ) )
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


Function ConfiguringControls:Int ()
	TInputManager.GetInstance().IsConfiguring()
EndFunction
	
