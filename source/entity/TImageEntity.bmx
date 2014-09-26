
Rem
bbdoc: Entity using image for rendering.
about: Also can be checked for collision with other image entities.
EndRem
Type TImageEntity Extends TEntity

	Field _scaleX:Float
	Field _scaleY:Float
	Field _image:TImage
	Field _frame:Int
	Field _rotation:Float
	Field _color:TColor	
	Field _blend:Int
	field _visible:Int

	'bool. entity is not participating in collision checks
	'when this is set to false. default is yes.
	field _collision:int


	Method New()
		_color = TColor.Create( 255, 255, 255, 1.0 )
		_scaleX = 1.0
		_scaleY = 1.0
		_blend = ALPHABLEND
		_visible = True
		_collision = True
	End Method


	Rem
		bbdoc:   Sets collision check for this entity.
		about:   
		returns: 
	EndRem
	Method SetCollision(bool:Int)
		_collision = bool
	EndMethod


	Method GetCollision:Int()
		return _collision
	EndMethod


	Method SetVisible(bool:Int)
		_visible = bool
	EndMethod


	Method GetVisible:Int ()
		return _visible
	EndMethod



	Method GetImage:TImage()
		Return _image
	End Method


	Method SetImage(i:TImage, imgFrame:Int = 0)
		_image = i
		_frame = imgFrame
	End Method


	Method GetFrame:Int()
		Return _frame
	End Method


	Method SetFrame(f:Int)
		_frame = f
	End Method


	Method GetScaleX:Float()
		Return _scaleX
	End Method


	Method SetScaleX(sx:Float)
		_scaleX = sx
	End Method


	Method GetScaleY:Float()
		Return _scaleY
	End Method


	Method SetScaleY(sy:Float)
		_scaleY = sy
	End Method


	Method SetScale(x:float, y:float)
		_scaleX = x
		_scaleY = y		
	EndMethod
	


	Method GetAlpha:Float()
		Return _color.GetAlpha()
	End Method


	Method SetAlpha(a:Float)
		_color.SetAlpha(a)
	End Method


	Method GetRotation:Float()
		Return _rotation
	End Method


	Method SetRotation(r:Float)
		_rotation = r
	End Method


	Method AddRotation(r:float)
		_rotation:+r
	End Method


	Method GetColor:TColor()
		Return _color
	End Method


    Method SetColor(r:Float, g:Float, b:Float)
        _color.Set(r,g,b, _color.GetAlpha())
    End Method


	Method GetBlend:Int()
		Return _blend
	End Method


	Method SetBlend(b:Int)
		_blend = b
	End Method


	Rem
		bbdoc: Returns true if images of entities collide.
	endrem
	Method CollideWith:Int(e:TImageEntity)
		if not _collision then return false
		Return ImagesCollide2(_image, _position.GetX(), _position.GetY(), _frame, _rotation, _scaleX, _scaleY,  ..
			e.GetImage(), e.GetPosition().GetX(), e.GetPosition().GetY(), e.GetFrame(), e.GetRotation(), e.GetScaleX(), e.GetScaleY())
	End Method


	Rem
		bbdoc:   Checks if this image entity collides with another imageentity in the entity manager
		returns: TImageEntity collided with, or null
	EndRem
	Method Collide2:TImageEntity()
		if not _collision then return null
		For Local ie:TImageEntity = EachIn TEntityManager.GetInstance().GetEntities()
			If ie <> Self and ie.GetCollision() = true
				If Self.CollideWith(ie) Then Return ie
			EndIf
		Next
		return Null
	EndMethod


	Rem
		bbdoc:   Checks if this TImageEntity collides with a TImageEntity in passed group.
		about:   
		returns: TImageEntity collided with, or Null.
	EndRem
	Method CollideWithGroup:TImageEntity(groupName:String)
		Local group:TBag = Self._manager.GetGroup(groupName)
		For Local index:Int = 0 Until group.GetSize()
			local e:TImageEntity = TImageEntity(group.Get(index))
			if e = self then continue
			if not e.GetCollision() then continue
			if Self.CollideWith(e) then return e
		Next
		return null		
	EndMethod
	


	'renders this entity.
	'called from TEntity.Render()
	Method RenderEntity()
        If Not _image Then Return
        If Not _visible Then Return
		brl.max2d.SetScale(_scaleX, _scaleY)
		brl.max2d.SetRotation(_rotation)
		brl.max2d.SetBlend(_blend)
		_color.Use()
        DrawImage(_image, _position.GetRenderX(), _position.GetRenderY(), _frame)
    End Method
EndType


' -------------------------------------


Rem
	bbdoc:   Returns true if passed imageentity collides with an imageentity in passed group.
	about:   
	returns: Int
EndRem
Function EntityGroupCollide:TImageEntity( e:TImageEntity, groupName:String )
	return e.CollideWithGroup( groupName )
EndFunction


Rem
	bbdoc:   Sets entity collision flag.
	about:   
	returns: 
EndRem
Function SetEntityCollision( e:TImageEntity, bool:Int )
	e.SetCollision( bool )	
EndFunction

