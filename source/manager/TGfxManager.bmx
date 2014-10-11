
Rem
	bbdoc: Graphics manager for Game2d
	about: Uses James Boyd's great virtualgfx thingy.
EndRem
Type TGfxManager

	Global instance:TGfxManager

	'the game resolution. not physical resolution.
	Field _gameWidth:Int
	field _gameHeight:Int

	'virtual graphics by james boyd
	Field windowed:Int = true	
	Field monitorAdjust:Int = false
	Field windowWidth:Int = 800
	Field windowHeight:Int = 600
	Field fullscreenWidth:Int
	Field fullscreenHeight:Int
	Field fullscreenDepth:Int

	Field openGL:Int = False


	Function GetInstance:TGfxManager()
		If instance = Null Then Return New TGfxManager
		Return instance
	End Function


	Method New()
		If instance Then Throw "Unable to create instance of singleton class."
		instance = Self
	End Method


	Method Destroy()

		'add proper cleanup here
		Endgraphics()

		instance = Null
	End Method



	Rem
		bbdoc:   User method to simply initialize graphics.
		about:   Also creates graphics
		returns: 
	EndRem
	Method Initialize( wWidth:Int, wHeight:Int, gWidth:Int, gHeight:Int )
		Self.SetWindowResolution( wWidth, wHeight )
		Self.SetVirtualResolution( gWidth, gHeight )
		Self.CreateGraphics()		
	EndMethod
	


	Rem
		bbdoc:   Sets the size of the game when windowed.
		about:   
		returns: 
	EndRem
	Method SetWindowResolution( width:Int, height:Int )
		windowWidth = width
		windowHeight = height
'		windowDepth = 0
	EndMethod


	Rem
		bbdoc:   Sets the resolution of the full screen.
		about:   This idealy is the desktop resolution.
		returns: 
	EndRem
	Method SetFullScreenResolution( width:Int, height:Int, depth:Int )
		fullscreenWidth = width
		fullscreenHeight = height
		fullscreenDepth = depth
	EndMethod
	

	Rem
		bbdoc: Sets game resolution.
		about: This is a virtual resolution, independant from physical resolution.
	endrem
	Method SetVirtualResolution( w:Int, h:Int )
		_gameWidth = w
		_gameHeight = h
	End Method


	Rem
		bbdoc: Returns game width
		about: Calls the function in TVirtualGfx
	endrem
	Method GetGameWidth:Int()
		Return _gameWidth
	End Method


	Rem
		bbdoc: Returns game height.
		about: Calls the function in TVirtualGfx
	endrem
	Method GetGameHeight:Int()
		Return _gameHeight
	End Method


	Rem
		bbdoc: Creates game graphics and virtual resolution.
		about: The correct settings must already be set. See SetDefaultValues()
	endrem
	Method CreateGraphics()

		'choose graphics driver according to platform and preference:
		'linux: opengl
		'windows: dx9, opengl
		local openGL:Int = false
		?Linux
			SetGraphicsDriver(GLMax2DDriver())
			openGL = true
		?Win32
			'try dx9, and GL again if dx9 does not work
			If Not GetGraphicsDriver()
				SetGraphicsDriver(D3D9Max2DDriver())
				If Not GetGraphicsDriver()
					SetGraphicsDriver(GLMax2DDriver())
					openGL = true
				End If
			End If
		?

		'error when no driver found!!
		If Not GetGraphicsDriver()
			RuntimeError("Could not select a graphics driver!")
		End If

		'continue

		'call in tvirtualgfx.bmx
		InitVirtualGraphics()

		'open fullscreen or windows according to setting
		if self.windowed = true
			ToWindowed()
		Else
			if GraphicsModeExists( fullscreenWidth, fullscreenHeight, fullscreenDepth )
				Graphics( fullscreenWidth, fullscreenHeight, fullscreenDepth )
			Else
				Self.ToWindowed()
			endif
		endif

		'call in tvirtualgfx.bmx
		SetVirtualGraphics( _gameWidth, _gameHeight, Self.monitorAdjust )
	End Method


	'revert to a default windows graphics mode
	Method ToWindowed()
		if GraphicsModeExists( windowWidth, windowHeight, 0 )
			Graphics( windowWidth, windowHeight, 0 )
		elseif GraphicsModeExists( 800, 600, 0 )
			windowWidth = 800
			windowHeight = 600
			Graphics( windowWidth, windowHeight, 0 )
		else
			RuntimeError("Could not create a window!")
		endif
	EndMethod
	

	Method ToggleWindowed()
		windowed = not windowed

		local r:Int, g:int, b:Int
		GetClsColor( r, g, b )

		EndGraphics()
		'call in tvirtualgfx.bmx
		InitVirtualGraphics()

		if self.windowed = true
			Graphics(windowWidth, windowHeight, 0)
			'call in tvirtualgfx.bmx
			SetVirtualGraphics( _gameWidth, _gameHeight)
		Else
			Graphics( fullscreenWidth, fullscreenHeight, fullscreenDepth )
			'call in tvirtualgfx.bmx
			SetVirtualGraphics( _gameWidth, _gameHeight, Self.monitorAdjust )
		endif

		'restore colour
		SetClsColor(r,g,b)

		'reload the font
		SetGameFont( GetGameFont() )', GetGameFontSize() )

		'update entity manager once to force camera update etc
		TEntityManager.GetInstance().Update()
	EndMethod


	Rem
		bbdoc:   Sets the default graphics settings.
		about:   It will use the ini file, or passed default settings
		returns: 
	EndRem
	Method SetDefaultValues( i:TINIFile )
		Self.windowed = i.GetBoolValue( "Graphics", "Windowed", "true" )
		Self.monitorAdjust = i.GetBoolValue( "Graphics", "MonitorAdjust", "true" )
		Self.openGL = i.GetBoolValue( "Graphics", "OpenGL", "false" )
		Self.windowWidth = i.GetIntValue( "Graphics", "WindowWidth", 800 )
		Self.windowHeight = i.GetIntValue( "Graphics", "WindowHeight", 600 )
		Self.fullscreenWidth = i.GetIntValue( "Graphics", "FullScreenWidth", DesktopWidth() )
		Self.fullscreenHeight = i.GetIntValue( "Graphics", "FullScreenHeight", DesktopHeight() )
		Self.fullscreenDepth = i.GetIntValue( "Graphics", "FullScreenDepth", DesktopDepth() )
	EndMethod
	

	Rem
		bbdoc:   Passes type settings to ini file so these can be saved.
		about:   
		returns: 
	EndRem
	Method ToIniFile ( i:TINIFile )
		i.SetIntValue("Graphics", "WindowWidth", windowWidth)
		i.SetIntValue("Graphics", "WindowHeight", windowHeight)
		i.SetIntValue( "Graphics", "FullScreenWidth", fullscreenWidth)
		i.SetIntValue( "Graphics", "FullScreenHeight", fullscreenHeight)
		i.SetIntValue( "Graphics", "FullScreenDepth", fullscreenDepth)

		if openGL = true
			i.SetBoolValue("Graphics", "OpenGL", "true")
		Else
			i.SetBoolValue("Graphics", "OpenGL", "false")
		endif

		if windowed = true
			i.SetBoolValue("Graphics", "Windowed", "true")
		Else
			i.SetBoolValue("Graphics", "Windowed", "false")
		endif

		if monitorAdjust = true
			i.SetBoolValue("Graphics", "MonitorAdjust", "true")
		Else
			i.SetBoolValue("Graphics", "MonitorAdjust", "false")
		endif
	EndMethod	

rem

'	Method IsConfiguring:Int ()
'		return configuring
'	EndMethod


'	Method StartConfiguring()
'		configuring = true
'		configureStep = STEP_SHOWDEVICE
'		FlushKeys()
'	EndMethod

	Method Update()
		if configuring
			'color flash delay for attention text
			colorFlashCounter:+1

			'escape keys walks back
			If keyhit(KEY_ESCAPE)
				if configureStep = STEP_SHOWDEVICE
					configuring = false
					FlushKeys()
					return
				elseif configureStep = STEP_EDITDEVICE
					configureStep = STEP_SHOWDEVICE
				endif
			elseif KeyHit(KEY_F11)
				configureStep = STEP_EDITDEVICE
			endif
		Endif
	EndMethod


	'shown when resolution is being shown or reconfigured
	Method Render()
		if configuring
			TRenderState.Push()
			TRenderState.Reset()

			'render black border
			SetColor(0, 0, 0)
			SetAlpha(0.9)
			DrawRect(5, 5, GameWidth() - 10, GameHeight() - 10)
			SetAlpha(1.0)

			'title			
			SetColor(100,100,255)
			RenderText("Display", 0, 10, true, true)
			Select configureStep
				Case STEP_SHOWDEVICE		RenderShowDevice()
				Case STEP_EDITDEVICE		RenderEditDevice()
			EndSelect

			'draw footer text
			SetColor(255,255,255)
			RenderText("[ESC] back", 0, GameHeight() - 20, true, true)

			TRenderState.Pop()
		endif
	EndMethod



	Method RenderEditDevice()
		local ypos:Int = 30
		SetColor( 100, 255, 255 )
		RenderText("Select resolution", 0, ypos, true, true)
		ypos:+ 9

		SetColor( 255, 255, 255 )
		local index:Int = 0
		For Local mode:TGraphicsMode = EachIn _modes
			RenderText("[" + index + "] " + mode.width + "," + mode.height + "," + mode.depth + "," + mode.hertz, 0, ypos, true, true )
			index:+1
			ypos:+9
		Next

'		RenderText("[F10] Toggle Fullscreen", 0, GameHeight()-45, true, true)
		RenderText("[0] - [" + (index-1) + "] Select Resolution", 0, GameHeight()-35, true, true)
	EndMethod
	


	Method RenderShowDevice()
		local config:TINIFile = G_CURRENTGAME.GetConfig()

		local ypos:Int = 30
		SetColor(100,255,255)
		RenderText("Fullscreen", 0, ypos, true, true)
		ypos:+9
		local windowed:Int = config.GetBoolValue("Graphics", "Windowed")

		Setcolor(255,255,255)
		if windowed = false
			RenderText("True", 0, ypos, true, true)
		Else
			RenderText("False", 0, ypos, true, true)
		endif
		ypos:+15

		SetColor(100,255,255)
		RenderText("Resolution", 0, ypos, true, true)
		ypos:+9
		Local s:String = ""
		s:+ config.GetIntValue("Graphics", "Width") + ","
		s:+ config.GetIntValue("Graphics", "Height")
		SetColor(255,255,255)
		RenderText(s, 0, ypos, true, true)

		RenderText("[F10] Toggle Fullscreen", 0, GameHeight()-45, true, true)
		RenderText("[F11] Select Resolution", 0, GameHeight()-35, true, true)
	EndMethod	
	
	EndRem

EndType

' --------------------------------

Rem
	bbdoc:   Sets window dimensions and game resolution
	about:   Also creates graphics.
	returns: 
EndRem
Function InitializeGraphics( wWidth:int, wHeight:Int, gWidth:int, gHeight:Int )
	TGfxManager.GetInstance().Initialize( wWidth, wHeight, gWidth, gHeight )	
EndFunction

Rem
	bbdoc:   Returns game screen height.
	about:   
	returns: Int
EndRem
Function GameHeight:Int()
	Return TGfxManager.GetInstance().GetGameHeight()
End Function


Rem
	bbdoc:   Returns game screen width.
	about:   
	returns: Int
EndRem
Function GameWidth:Int()
	Return TGfxManager.GetInstance().GetGameWidth()
End Function

