
rem
bbdoc: A fade-in effect.
endrem
Type TTransitionFadeIn Extends TTransition
	
	
	Rem
	bbdoc:User hook to initialize effect.
	End Rem
	Method Initialize()
		_color._a = 1.0
	End Method	
	
	
	Rem
	bbdoc: Perform transition action.
	End Rem
	Method Update(delta:Double)
		_color._a:- delta * (1.0 / _transitionLength)
		If _color._a < 0.0 Then _color._a = 0.0
	End Method
	
	
	Rem
	bbdoc: Render transition effect.
	End Rem
	Method Render()
		TRenderState.Push()
		TRenderState.Reset()

		local ox:float, oy:float
		Getorigin( ox, oy)
		SetOrigin(TVirtualGfx.VG.vxoff, TVirtualGfx.VG.vyoff)


		_color.Use()
		SetBlend(ALPHABLEND)
		DrawRect(0, 0, GameWidth(), GameHeight())

		SetOrigin(ox,oy)
		
		TRenderState.Pop()
	End Method
	
		
	Rem
	bbdoc: Returns true if the transition is complete.
	End Rem
	Method IsComplete:Int()
		Return _color._a <= 0.0
	End Method
	
End Type
