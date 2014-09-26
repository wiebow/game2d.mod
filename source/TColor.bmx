
rem
bbdoc: Convenience type for color and alpha.
end rem
Type TColor

	Field _r:Float = 255
	Field _g:Float = 255
	Field _b:Float = 255
	Field _a:Float


	rem
	bbdoc: Constructor.
	endrem
	Function Create:TColor(r:Float = 255, g:Float = 255, b:Float = 255, a:Float = 1.0)
		Local c:TColor = New TColor
		c._r = r
		c._g = g
		c._b = b
		c._a = a
		Return c
	End Function


	rem
	bbdoc: Sets color and alpha values.
	endrem
	Method Set(r:Int, g:Int, b:Int, a:Float)
		_r = r
		_g = g
		_b = b
		_a = a
	End Method


	rem
	bbdoc: Uses color and alpha on current graphics instance.
	endrem
	Method Use()
		brl.max2d.SetColor(_r, _g, _b)
		brl.max2d.SetAlpha(_a)
	End Method


	Method GetRed:Float()
		Return _r
	End Method

	Method GetGreen:Float()
		Return _g
	End Method

	Method GetBlue:Float()
		Return _b
	End Method


	rem
	bbdoc: Returns alpha value.
	endrem
	Method GetAlpha:Float()
		Return _a
	End Method


	rem
	bbdoc: Sets alpha value.
	endrem
	Method SetAlpha(a:Float)
		_a = a
	End Method

End Type
