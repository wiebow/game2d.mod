
Rem
bbdoc: Game2D entity.
about: Uses the TEntityManger to add and remove entites from the game.
endrem
Type TEntity

	Field _position:TPosition
	Field _renderLayer:Int
	field _groupName:String
	Field _manager:TEntityManager


	Method New()
		_position = New TPosition
	End Method


	'sets the entity manager for this entity.
	Method SetManager(m:TEntityManager)
		_manager = m
	EndMethod


	'sets the entity group name.
	Method SetGroupName( name:String )
		_groupName = name
	EndMethod


	'returns the name of the entity group name.
	Method GetGroupName:String()
		Return _groupName
	EndMethod


	'sets the render layer index holding this entity.
	Method SetRenderLayer(index:Int)
		_renderLayer = index
	End Method


	'returns the render layer index holding this entity.
	Method GetRenderLayer:Int()
		Return _renderLayer
	End Method


	'Returns the position type for this entity.
	Method GetPosition:TPosition()
		Return _position
	End Method


	'updates position of this entity and calls user hook method.
	Method Update() final
		_position.Update()
		Self.UpdateEntity()
	End Method


	'renders entity and calls user hook method.
	Method Render(tween:Double) final
		_position.Interpolate(tween)
		Self.RenderEntity()
	End Method


	Rem
		bbdoc:   Returns X position of this entity.
		about:
		returns:
	EndRem
	Method GetPositionX:Float()
		return _position.GetX()
	EndMethod


	Rem
		bbdoc:   Returns Y position of this entity.
		about:
		returns:
	EndRem
	Method GetPositionY:Float()
		Return _position.GetY()
	EndMethod


	Rem
		bbdoc:   Moves Entity by passed amount
		about:
		returns:
	EndRem
	Method Move( xAmount:Float, yAmount:Float )
		_position.Add( xAmount, yAmount )
	EndMethod


	Rem
		bbdoc:   Moves entity with passed vector.
		about:
		returns:
	EndRem
	Method MoveV( v:TVector2D )
		_position.AddV( v )
	EndMethod


	Rem
		bbdoc:   Resets entity position to passed location.
		about:
		returns:
	EndRem
	Method SetPosition( xPos:Float, yPos:Float )
		_position.Reset( xPos, yPos )
	EndMethod



	Rem
		bbdoc:   User hook for update code.
		about:   Is called each update.
		returns:
	EndRem
	Method UpdateEntity()
	End Method

	Rem
		bbdoc:   User hook for render code.
		about:   Render code must use the renderposition in the position type to avoid erratic movement.
		returns:
	endrem
	Method RenderEntity()
	End Method

End Type


'---------------------------------------------------------
' helper functions

Rem
	bbdoc:   Returns entity X position.
	about:   Actual position, not render position.
	returns: Float
EndRem
Function EntityX:Float(e:TEntity)
	Return e.GetPosition().GetX()
End Function



Rem
	bbdoc:   Returns entity Y position.
	about:   Actual position, not render position
	returns: Float
EndRem
Function EntityY:float (e:TEntity)
	Return e.GetPosition().GetY()
EndFunction


Rem
	bbdoc:   Returns entity render X position.
	about:   Actual position, not render position.
	returns: Float
EndRem
Function EntityRenderX:Float(e:TEntity)
	Return e.GetPosition().GetRenderX()
End Function



Rem
	bbdoc:   Returns entity Y position.
	about:   Actual position, not render position
	returns: Float
EndRem
Function EntityRenderY:float (e:TEntity)
	Return e.GetPosition().GetRenderY()
EndFunction



Rem
	bbdoc:   Sets entity X position.
	about:   Actual position, not render position.
	returns:
EndRem
Function SetEntityX( e:TEntity, x:Float )
	e.GetPosition().SetX( x )
End Function



Rem
	bbdoc:   Sets entity Y position.
	about:   Actual position, not render position.
	returns:
EndRem
Function SetEntityY( e:TEntity, y:Float )
	e.GetPosition().SetY( y )
EndFunction


Rem
	bbdoc:   Returns distance between passsed entities.
	about:
	returns: Float
EndRem
Function EntityDistance:Float (e1:TEntity, e2:TEntity)
	Local v1:TVector2D = e1.GetPosition().Get()
	Local v2:TVector2D = e2.GetPosition().Get()
	Return v1.Distance(v2)
EndFunction



Rem
	bbdoc:   Returns vector between passed entities.
	about:
	returns: TVector2D
EndRem
Function EntityVector:TVector2D( e1:TEntity, e2:TEntity )
	Local v:TVector2D = e1.GetPosition().Get().Clone()
	v.SubstractV( e2.GetPosition().Get() )
	Return v
EndFunction


Rem
	bbdoc:   Returns vector containing distance traveled since last update.
	about:
	returns: TVector2D
EndRem
Function EntityTraveled:TVector2D( e:TEntity )
	Local v:TVector2D = e.GetPosition().Get().Clone()
	v.SubstractV(e.GetPosition().GetPrevious())
	return v
EndFunction



Rem
	bbdoc:   Moves entity with passed amount.
	about:
	returns:
EndRem
Function MoveEntity( e:TEntity, xAmount:Float, yAmount:Float )
	e.Move( xAmount, yAmount )
EndFunction


Rem
	bbdoc:   Moves entity with passed vector.
	about:
	returns:
EndRem
Function MoveEntityVector( e:TEntity, v:TVector2D )
	e.MoveV( v )
EndFunction



Rem
	bbdoc:   Sets entity position.
	about:
	returns:
EndRem
Function SetEntityPosition( e:TEntity, xPos:Float, yPos:Float )
	e.SetPosition( xPos, yPos)
EndFunction

