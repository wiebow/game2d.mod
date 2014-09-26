
Rem
bbdoc: Entity position type.
about: 
endrem
Type TPosition

	Field _renderPosition:TVector2D
	Field _position:TVector2D
	Field _previousPosition:TVector2D


	Method New()
		_position = New TVector2D
		_renderPosition = New TVector2D
		_previousPosition = New TVector2D
	End Method



	'Sets the render position according to specified tween value.
	'TGame.Render() calls this before rendering entities.
	Method Interpolate(tween:Double) {hidden}
		_renderPosition.SetX( Double(_position.GetX()) * tween + ..
			Double(_previousPosition.GetX()) * (1.0:Double - tween) )
		_renderPosition.SetY( Double(_position.GetY()) * tween + ..
			Double(_previousPosition.GetY()) * (1.0:Double - tween) )
	End Method


	'called by TGame.Update()
	Method Update() {hidden}
		_previousPosition.Set( _position.GetX(), _position.GetY())
	End Method


	Rem
	bbdoc: Returns true if this position has changed since last update.
	endrem
	Method Changed:Int()
		Return Not _position.IsSame(_previousPosition)
	End Method


	Rem
	bbdoc: Resets this position to passed coordinates.
	about: Also resets previous and render position.
	endrem
	Method Reset(x:Float, y:Float)
		_renderPosition.Set(x, y)
		_position.Set(x,y)
		_previousPosition.Set(x, y)
	End Method


	Rem
	bbdoc: Sets position to passed coordinates.
	about: Does not reset previous and render position.
	endrem
	Method Set(x:Float, y:Float)
		_position.Set(x,y)
	End Method


	Rem
	bbdoc: Returns X component of this position.
	endrem
	Method GetX:Float()
		Return _position.GetX()
	End Method


	Rem
	bbdoc: Returns Y component of this position.
	endrem
	Method GetY:Float()
		Return _position.GetY()
	End Method


	Rem
	bbdoc: Sets X component of this position.
	endrem
	Method SetX(x:Float)
		_position.SetX(x)
	End Method


	Rem
	bbdoc: Sets Y component of this position.
	endrem
	Method SetY(y:Float)
		_position.SetY(y)
	End Method


	Rem
	bbdoc: Returns position as a vector.
	returns: TVector2D
	endrem
	Method Get:TVector2D()
		Return _position
	End Method


	Rem
		bbdoc:   Returns previous position.
		about:   
		returns: TVector2D
	EndRem
	Method GetPrevious:TVector2D ()
		Return _previousPosition
	EndMethod
	


	Rem
	bbdoc: Adds passed values to this position.
	endrem
	Method Add(x:Float, y:Float)
		_position.Add(x,y)
	End Method


	Rem
	bbdoc: Adds passed value to X component of this position.
	endrem
	Method AddX(x:Float)
		_position.AddX(x)
	End Method


	Rem
	bbdoc: Adds passed value to Y component of this position.
	endrem
	Method AddY(y:Float)
		_position.AddY(y)
	End Method


	Rem
	bbdoc: Adds passed vector to this position.
	endrem
	Method AddV(v:TVector2D)
		_position.AddV(v)
	End Method


	Rem
	bbdoc: Returns X component of render position.
	about: Use this value to render, and after calling Interpolate()
	Interpolate is called automatically by TGame.Render()
	endrem
	Method GetRenderX:Float()
		Return _renderPosition.GetX()
	End Method


	Rem
	bbdoc: Returns Y component of render position.
	about: Use this value to render, and after calling Interpolate()
	Interpolate is called automatically by TGame.Render()
	endrem
	Method GetRenderY:Float()
		Return _renderPosition.GetY()
	End Method


	Rem
	bbdoc: Returns length of vector from this position to passed position.
	endrem
	Method GetDistanceTo:Float(p:TPosition)
		Return _position.Distance(p.Get())
	End Method

End Type

