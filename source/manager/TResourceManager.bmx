

Rem
	bbdoc: Game2d Resource manager
	about: This type is a singleton, meaning only one instance can be created.
	Important: Groups must be created before adding resources to the manager.
endrem
Type TResourceManager

	'The singleton instance of the class
	Global singletonInstance:TResourceManager

	'resources are added to this tmap
	'grouped by string, which is the resource group name
	Field resources:TMap


	Rem
		bbdoc:   Constructor.
		about:   You should not call this manually, instead you should use GetInstance()
		returns:
	EndRem
	Method New()
		if singletonInstance <> Null then Throw("Cannot create multiple instances of Singleton Type")
		singletonInstance = Self
		Self.resources = New TMap
	EndMethod


	Rem
		bbdoc:   Returns the instance of this singleton.
		about:   Creates a new instance when no instance is present.
		returns: TResourceManager
	EndRem
	Function GetInstance:TResourceManager()
		If Not singletonInstance Return New TResourceManager
		Return singletonInstance
	EndFunction


	Rem
		bbdoc:   Destroys this singleton.
		about:
		returns:
	EndRem
	Method Destroy()
		Self.Clear()
		resources = Null
		singletonInstance = Null
	EndMethod


	Rem
		bbdoc:   Removes all resources from the manager.
		about:   Does not destroy the manager.
		returns:
	EndRem
	Method Clear()
		resources.Clear()
	End Method


	rem
		bbdoc: Adds a new group to the manager.
		returns: TMap
	endrem
	Method AddGroup:TMap(groupName:String)
		Local m:TMap = New TMap
		resources.Insert(groupName, m)
		Return m
	End Method


	rem
		bbdoc: Retrieves a group from the manager.
		returns: TMap
	endrem
	Method GetGroup:TMap(groupName:String)
		Local group:TMap = TMap(resources.ValueForKey(groupName))
		if not group Throw( "Group '" + groupName + "' cannot be found" )
		Return group
	End Method


	rem
		bbdoc: Adds passed object in the manager, in specified group.
		about:
	endrem
	Method AddObject(o:Object, objectName:String, groupName:String)
		if not o Throw( "Passed object is null!" )
		GetGroup(groupName).Insert(objectName, o)
	End Method


	rem
		bbdoc: Adds image in the manager, in specified group.
		about:
	endrem
	Method AddImage(image:TImage, imageName:String, groupName:String)
		If Not image Throw( "Passed image '" + imageName + "' is null!" )
		GetGroup(groupName).Insert(imageName, image)
	End Method


	rem
		bbdoc: Adds sound in the manager, in specified group.
		about:
	endrem
	Method AddSound(sound:TSound, soundName:String, groupName:String)
		If not sound Throw( "Passed sound ' " + soundName + "' is null!" )
		GetGroup(groupName).Insert(soundName, sound)
	End Method


	rem
		bbdoc: Adds string in the manager, in specified group.
		about:
	endrem
	Method AddString(str:String, stringName:String, groupName:String)
		GetGroup(groupName).Insert(stringName, str)
	EndMethod


	rem
		bbdoc: Gets object from the manager, from specified group.
		about:
		returns: Object
	endrem
	Method GetObject:Object(objectName:String, groupName:String)
		local obj:Object = GetGroup(groupName).ValueForKey(objectName)
		if not obj Throw( "Object '" + objectName + "' cannot be found in group '" + groupName + "'" )
		Return obj
	End Method


	rem
		bbdoc: Gets image from the manager, from specified group.
		about:
		returns: TImage
	endrem
	Method GetImage:TImage(imageName:String, groupName:String)
		local img:TImage = TImage(GetGroup(groupName).ValueForKey(imageName))
		if not img Throw( "Image '" + imageName + "' cannot be found in group '" + groupName + "'" )
		Return img
	End Method


	rem
		bbdoc: Gets sound from the manager, from specified group.
		about:
		returns: TSound
	endrem
	Method GetSound:TSound(soundName:String, groupName:String)
		Local snd:TSound = TSound(GetGroup(groupName).ValueForKey(soundName))
		if not snd Throw( "Sound '" + soundName + "' cannot be found in group '" + groupName + "'" )
		Return snd
	End Method


	rem
		bbdoc: Gets string from the manager, from specified group.
		about:
		returns: TString
	endrem
	Method GetString:String(stringName:String, groupName:String )
		Local str:String = String(GetGroup(groupName).ValueForKey(stringName))
		if not str Throw( "String '" + stringName + "' cannot be found in group '" + groupName + "'" )
		return str
	End Method

End Type


' ---------------------------

Function ClearResources()
	TResourceManager.GetInstance().Clear()
EndFunction


Function AddResourceGroup(groupName:String)
	TResourceManager.GetInstance().AddGroup( groupName )
EndFunction

Function GetResourceGroup:TMap( groupName:String )
	Return TResourceManager.GetInstance().GetGroup( groupName )
EndFunction


Function AddResourceImage( image:TImage, imageName:String, groupName:String )
	TResourceManager.GetInstance().AddImage( image, imageName, groupName )
EndFunction

Function GetResourceImage:TImage( imageName:string, groupName:String)
	Return TResourceManager.GetInstance().GetImage( imageName, groupName )
EndFunction


Function AddResourceSound( sound:TSound, soundName:String, groupName:String )
	TResourceManager.GetInstance().AddSound( sound, soundName, groupName )
EndFunction

Function GetResourceSound:TSound( soundName:string, groupName:String)
	Return TResourceManager.GetInstance().GetSound( soundName, groupName )
EndFunction


Function AddResourceObject( obj:Object, objectName:String, groupName:String )
	TResourceManager.GetInstance().AddObject( obj, objectName, groupName )
EndFunction

Function GetResourceObject:Object( objectName:string, groupName:String)
	Return TResourceManager.GetInstance().GetObject( objectName, groupName )
EndFunction


Function AddResourceString( str:String, stringName:String, groupName:String )
	TResourceManager.GetInstance().AddString( str, stringName, groupName )
EndFunction

Function GetResourceString:String( stringName:string, groupName:String)
	Return TResourceManager.GetInstance().GetString( stringName, groupName )
EndFunction