

Rem
bbdoc: Game Camera
about: The camera follows an entity, movement can be slowed
EndRem
Type TCameraEntity Extends TEntity

	'entity to target
	Field _target:TEntity

	'vector to the target
	Field _targetVector:TVector2D

	'camera movement softening
	Field _delay:Float


	'world area the camera can see
	Field _viewPort:TRect


	Field _shaking:Int 
	Field _shakeRadius:Float 
	Field _shakeVector:TVector2D
 

	Method New()
		_delay = 0.06
		_viewPort = New TRect
		_targetVector= New TVector2D
		_shakeVector = New TVector2D
	EndMethod



	Method Shake(radius:Float)
		_shaking = True
		_shakeRadius = radius		
	EndMethod
	


	Rem
		bbdoc:   Sets the target entity to follow.
		about:   
		returns: 
	EndRem
	Method SetTarget(t:TEntity)
		_target = t
	EndMethod


	Rem
		bbdoc:   Snaps camera to current target position.
		about:   
		returns: 
	EndRem
	Method SnapToTarget()
		if _target = Null return
		_position.Reset( _target.GetPosition().GetX(), _target.GetPosition().GetY() )
	EndMethod

	Rem
		bbdoc:   Returns current camera viewport.
		about:   
		returns: TRect
	EndRem
	Method GetViewPort:TRect()
		return _viewPort		
	EndMethod


	Rem
		bbdoc:   Returns true if camera can see the passed entity.
		about:   
		returns: True or False
	EndRem
	Method CanSee:Int(e:TEntity)
		Return _viewPort.PointInside(e.GetPosition().Get())
	EndMethod
	


	Rem
		bbdoc:   Sets movement delay amount of camera.
		about:   The lower this value, the more the camera will trail the target. Default is 0.06, max is 1.0
	EndRem
	Method SetDelay(d:Float)
		If d > 1.0 Then d = 1.0
		_delay = d
	EndMethod
	

	'called by the entity manager.
	Method UpdateEntity()

		if _target = Null then return

		'determine vector to target
		_targetVector.Copy(_target.GetPosition().Get())
		_targetVector.SubstractV(_position.Get())

		'add softness to movement
		_targetVector.Multiply(_delay)

		'move
		_position.AddV(_targetVector)

		'shake?
		if _shaking
			Local angle:Float = Rand(360) 
			_shakeVector.Set(Sin(angle), Cos(angle))
			_shakeVector.Multiply(_shakeRadius)

			_shakeRadius:* 0.95
			if _shakeRadius < 0.001 then _shaking = false
		endif

		'set new draw offset
		'add the virtual resolution viewport

		local originX:Float = GameWidth() / 2 - EntityX(Self) + _shakeVector.GetX() + TVirtualGfx.VG.vxoff
		local originY:Float = GameHeight() / 2 - EntityY(Self) + _shakeVector.GetY() + TVirtualGfx.VG.vyoff
		SetOrigin( originX, originY )

		'determine camera viewPort (visible area)
		_viewPort.SetPosition( _position.GetX() - GameWidth() / 2 + _shakeVector.GetX(), ..
		                       _position.GetY() - GameHeight() / 2 + _shakeVector.GetY() )
		_viewPort.SetDimension( GameWidth(), GameHeight() )
	EndMethod

	'not needed
'	Method RenderEntity()

End Type
