
rem
bbdoc: 2D rectangle.
end rem
Type TRect

	Field _position:TVector2D
	Field _dimension:TVector2D


	Method New()
		_position = New TVector2D
		_dimension = New TVector2D
	End Method


	rem
	bbdoc: Creates a new rect with passed origin and dimension.
	about: Centers the rect on passed position when requested.
	endrem
	Function Create:TRect(x:Float, y:Float, w:Float, h:Float, centered:Int = False)
		Local r:TRect = New TRect
		r.SetDimension(w, h)
		If centered
			r.SetPosition(x - w / 2, y - h / 2)
		Else
			r.SetPosition(x, y)
		End If
		Return r
	End Function


	Rem
	bbdoc: Sets the position (topleft) of this rect.
	endrem
	Method SetPosition(x:Float, y:Float)
		_position.Set(x, y)
	End Method


	rem
	bbdoc: Returns position (topleft) of this rect.
	endrem
	Method GetPosition:TVector2D()
		Return _position
	End Method


	Rem
	bbdoc: Sets dimensions (width and height).
	endrem
	Method SetDimension(w:Float, h:Float)
		_dimension.Set(w, h)
	End Method


	rem
	bbdoc: Returns dimension of this rect.
	endrem
	Method GetDimension:TVector2D()
		Return _dimension
	End Method



	rem
	bbdoc: Returns topleft corner X value.
	endrem
	Method GetX:Float()
		Return _position.GetX()
	End Method


	rem
	bbdoc: Returns topleft conrer Y value.
	endrem
	Method GetY:Float()
		Return _position.GetY()
	End Method


	rem
	bbdoc: Returns width of this rect.
	endrem
	Method GetWidth:Float()
		Return _dimension.GetX()
	End Method


	rem
	bbdoc: Returns height of this rect.
	endrem
	Method GetHeight:Float()
		Return _dimension.GetY()
	End Method


	Rem
	bbdoc: Returns true if passed vector point is inside this rect.
	endrem
	Method PointInside:Int(p:TVector2D)

		If Self.GetWidth() = 0 And Self.GetHeight() = 0 Then Return False

		Local x:Float = p.GetX()
		Local y:Float = p.GetY()

		Return x >= Self.GetX() And x <= Self.GetX() + Self.GetWidth() And ..
			y >= Self.GetY() And y <= Self.GetY() + Self.GetHeight()
	End Method


	Rem
	bbdoc: Returns true when specified rect is completely inside this rect.
	endrem
	Method Inside:Int(r:TRect)
		Local p:TVector2D = New TVector2D

		If Self.GetWidth() = 0 And Self.GetHeight() = 0 Then Return False

		'topleft
		p.Set(r.GetX(), r.GetY())
		If Not Self.PointInside(p) Then Return False

		'topright
		p.Set(r.GetX() + r.GetWidth(), r.GetY())
		If Not Self.PointInside(p) Then Return False

		'bottomleft
		p.Set(r.GetX(), r.GetY() + r.GetHeight())
		If Not Self.PointInside(p) Then Return False

		'bottomright
		p.Set(r.GetX() + r.GetWidth(), r.GetY() + r.GetHeight())
		If Not Self.PointInside(p) Then Return False

		Return True
	End Method


	Rem
	bbdoc: Returns true when specified rect overlaps this rect.
	endrem
	Method OverLappedBy:Int(r:TRect)
		If Self.GetWidth() = 0 And Self.GetHeight() = 0 Then Return False

		Return ((Self.GetX() + Self.GetWidth() > r.GetX()) And (Self.GetY() + Self.GetHeight() > r.GetY()) And ..
			(Self.GetX() < r.GetX() + r.GetWidth()) And (Self.GetY() < r.GetY() + r.GetHeight()))
	End Method

End Type
