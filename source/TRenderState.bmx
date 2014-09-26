

rem
bbdoc: Render state push to and pop from a stack.
endrem
Type TRenderState

	Global _stack:TList = New TList

	Field _rotation:Float
	Field _scaleX:Float
	Field _scaleY:Float
	Field _originX:Float
	Field _originY:Float
	Field _color:TColor
	Field _blend:Int


	Method New()
		_color = New TColor
	End Method


	rem
	bbdoc: Pushes current renderstate to the stack.
	returns: TRenderState
	endrem
	Function Push:TRenderState()
		Local s:TRenderState = New TRenderState

		s._rotation = GetRotation()
		GetScale( s._scaleX, s._scaleY)
		GetOrigin(s._originX, s._originY)

		Local r:Int, g:Int, b:Int
		GetColor(r,g,b)
		s._color.Set( r,g,b,GetAlpha())

		s._blend = GetBlend()

		_stack.AddLast(s)
		Return s
	End Function


	rem
	bbdoc: Removes renderstate from top of stack and applies it.
	endrem
	Function Pop()
		Local r:TRenderState = TRenderState(_stack.RemoveLast())
		If Not r Return

		SetRotation(r._rotation)
		SetScale(r._scaleX, r._scaleY)
		SetOrigin(r._originX, r._originY)
		r._color.Use()
		SetBlend(r._blend)
	End Function


	rem
	bbdoc: Clears the render state stack.
	endrem
	Function ClearStack()
		_stack.Clear()
	End Function


	rem
	bbdoc: Resets current render state.
	endrem
	Function Reset()
		SetRotation(0)
		SetScale(1, 1)
		SetOrigin(0, 0)
		SetBlend(ALPHABLEND)
		SetColor(255,255,255)
		SetAlpha(1.0)
	End Function

End Type
