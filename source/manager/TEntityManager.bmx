
Rem
	bbdoc: Game2D entity manager.
	about: Holds, updates and renders entities.
	Entities are added to renderlayers. Entities can also be added to groups
	so checks can be performed against groups. (example: bullet group against player entity)
endrem
Type TEntityManager

	'instance
	Global _singletonInstance:TEntityManager

	'main list of all entities in the manager
	Field _entityList:TList

	'entities, per render layer
	'each index in the layer TBag holds a TList of entities for that layer
	Field _renderLayers:TBag

	'entities, per group name
	'each string key in the map holds a TBag with entities for that group
	Field _entityGroups:TMap


	'do not use this method, but GetInstance() instead.
	Method New()
		if _singletonInstance <> Null then Throw("You can only create one instance of this singleton!")
		_singletonInstance = Self
		_entityList = new TList
		_renderLayers = new TBag
		_entityGroups = new TMap
	EndMethod


	Rem
		bbdoc:   Returns the instance of this singleton.
		about:   Creates a new instance when no instance is present.
		returns: TEntityManager
	EndRem
	Function GetInstance:TEntityManager()
		If Not _singletonInstance
			Return New TEntityManager
		Else
			Return _singletonInstance
		EndIf
	EndFunction


	Rem
		bbdoc:   Destroys this singleton.
		about:
		returns:
	EndRem
	Method Destroy()
		Self.Clear()
		ClearMap( _entityGroups )
		_entityGroups = Null
		_singletonInstance = Null
	End Method


	Rem
		bbdoc:   Removes all entities from the manager.
		about:   Groups and renderlayers are emptied.
		returns:
	EndRem
	Method Clear()
		_entityList.Clear()
		
		For Local b:TBag = EachIn _entityGroups.Values()
			b.Clear()
		Next

		_renderLayers.Clear()		
	End Method



	Rem
		bbdoc:   Returns a list with all the entities in this manager.
		about:   
		returns: TList
	EndRem
	Method GetEntities:TList()
		return _entityList		
	End Method



	Rem
		bbdoc:   Adds a new group to this manager.
		about:   Group with same name is returned if already present.
		returns: TBag
	EndRem
	Method AddGroup:TBag( groupName:String )
		if MapContains( _entityGroups, groupName ) Then Return TBag(Self.GetGroup(groupName))
		local b:TBag = new TBag
		MapInsert( _entityGroups, groupName, b )
		return b
	End Method


	Rem
		bbdoc:   Returns group with passed name.
		about:   
		returns: TBag, or throws error.
	EndRem
	Method GetGroup:TBag( groupName:String )
		local g:TBag = TBag(MapValueForKey( _entityGroups, groupName ))
		if g = null then throw("Cannot find entity group with name: " + groupName)
		return g
	EndMethod
	

	Rem
		bbdoc:   Removes group (and entities in group) from the manager.
		about:   
		returns: 
	EndRem
	Method RemoveGroup( groupName:String )
		Self.ClearGroup( groupName )
		MapRemove( _entityGroups, groupName )
	EndMethod


	Rem
		bbdoc:   Removes all entities from passed group.
		about:   
		returns: 
	EndRem
	Method ClearGroup( groupName:string )
		Local l:TList = New TList
		Local b:TBag = Self.GetGroup( groupName )
		'fill list
		For Local i:Int = 0 Until b.GetSize()
			l.AddLast( b.Get(i) )
		Next
		'get rid of entities
		For local e:TEntity = eachin l
			Self.RemoveEntity(e)
		next
	EndMethod
	

	Rem
		bbdoc:   Adds specified entity to layer with passed id.
		about:   The render layer is created when passed id is not found.
		returns:
	EndRem
	Method AddEntity( e:TEntity, layer:Int, groupName:String )
		_entityList.AddLast(e)
		Local l:TList = TList(_renderLayers.Get(layer))
		If Not l
			l = New TList
			_renderLayers.Set(layer, l)
		End If
		l.AddLast(e)
		e.SetRenderLayer(layer)
		Self.AddEntityToGroup( e, groupName )
		e.SetManager(Self)
	End Method


	Rem
		bbdoc:   Removes specified entity from the manager.
		about:   
		returns:
	EndRem
	Method RemoveEntity( e:TEntity )

		'remove from global list
		_entityList.Remove(e)

		'render layer
		Local l:TList = TList(_renderLayers.Get(e.GetRenderLayer()))
		l.Remove(e)

		'from group
		Self.RemoveEntityFromGroup(e)

		'remove association
		e.SetManager(Null)
	End Method



	Rem
		bbdoc:   Adds passed entity to group with spedicied name.
		about:   Entity can only be added once to a group.
		returns: 
	EndRem
	Method AddEntityToGroup( e:TEntity, groupName:String )
		Local b:TBag = Self.GetGroup( groupName )
		if b.Contains(e) Then Return
		b.Add(e)
		e.SetGroupName( groupName )
	EndMethod


	Rem
		bbdoc:   Removes entity from its group.
		about:   Does not remove entity from manager.
		returns: 
	EndRem
	Method RemoveEntityFromGroup( e:TEntity )
		if e.GetGroupName() = "" then return
		Self.GetGroup(e.GetGroupName()).Remove(e)
		e.SetGroupName( "" )
	EndMethod


	Method Update()
		For local e:TEntity = eachin _entityList
			e.Update()
		Next
	End Method


	Method Render( tween:Double )
        Local amount:Int=0
		For Local index:Int = 0 Until _renderLayers.GetSize()
			Local l:TList = TList(_renderLayers.Get(index))
			If l
				For Local e:TEntity = EachIn l
					e.Render(tween)
	                amount:+1
				Next
			Endif
		Next
	End Method


	'for debug
	Method RenderStats(ypos:Int)
		SetGameColor( GREEN_LIGHT )
		RenderText( "Entities " + _entityList.Count(), 0, ypos, False, False )
		ypos:+10
		local text:String
		For Local s:string = EachIn _entityGroups.Keys()
			text = "" + s + " " + Self.GetGroup(s).GetSize()
			RenderText( text, 5, ypos, False, False )
			ypos:+10
		Next
	EndMethod	

End Type


' ----------------------------------------------

Function AddEntityGroup( groupName:String )
	TEntityManager.GetInstance().AddGroup( groupName )
EndFunction

Function GetEntityGroup:TBag( groupName:String )
	Return TEntityManager.GetInstance().GetGroup( groupName )
EndFunction


'Function RemoveEntityGroup( groupName:String )
'	TEntityManager.GetInstance().RemoveGroup( groupName )
'EndFunction

Function ClearEntityGroup( groupName:String )
	TEntityManager.GetInstance().ClearGroup( groupName )
EndFunction

Function ClearEntities()
	TEntityManager.GetInstance().Clear()	
EndFunction

Function AddEntity( entity:TEntity, renderLayer:Int, entityGroup:String )
	TEntityManager.GetInstance().AddEntity( entity, renderLayer, entityGroup )
EndFunction

Function RemoveEntity( entity:TEntity )
	TEntityManager.GetInstance().RemoveEntity( entity )
EndFunction

