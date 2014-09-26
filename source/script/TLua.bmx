
rem
bbdoc: Game2d interface for Lua scripts.
about: The methods in this type are exposed to Lua as global functions.
end rem
Type TLua {expose static noclass hidefields}

	'these globals are set when the game is created
	'in Game.SetupLua()
	Global _luaState:Byte ptr
	Global _game:TGame
	

	'#region input
	'--------------------------------------------	

	rem
	bbdoc: Returns keycode of currently held key.
	endrem	
	Method lKeyDown:Int(k:Int) {rename = "KeyDown" bool}
		Return KeyDown(k)
	End Method
	
	
	rem
	bbdoc: Exposed as KeyHit.
	about: Does not return a bool, so check in lua if returned value > 0
	endrem
	Method lKeyHit:Int(k:Int) {rename = "KeyHit"}
		Return KeyHit(k)
	End Method
	
	'#endregion input
	

	'#region entity
	'----------------------------------------------
     
	Method CreateEntity:TEntity(newId:String, scriptFileName:String, renderLayer:Int)
		Return _game.CreateEntity(newId, scriptFileName, renderLayer)
	End Method
	
	
	Method RemoveEntity(e:TEntity)
		_game.RemoveEntity(e)
	End Method

	'#endregion


	'#region graphics
	'-------------------------------------------------
    
    
    rem
    bbdoc: Render text in the current game font and color.
    endrem
    Method RenderText(text:String, xpos:Float, ypos:Float, centered:Int, shadow:Int, shadowDistance:Float)
        _game.RenderText(text, xpos, ypos, centered, shadow, shadowDistance)
    End Method

    
	rem
	bbdoc: Returns image from resource manager.
	endrem
	Method GetResourceImage:TImage(imageName:String, groupName:String = "default")
		Return TResources.GetImage(imageName, groupName)
	End Method
	
	
	Method DrawImage(img:TImage, xpos:Float, ypos:Float, imageFrame:Int)
		?Debug
		Assert img, "DrawImage: No Image"
		?
		brl.max2d.DrawImage(img, xpos, ypos, imageFrame)
	End Method


	Method ImagesCollide:Int(img1:TImage, x1:Float, y1:Float, frame1:Int,  ..
					 		 img2:TImage, x2:Float, y2:Float, frame2:Int) {bool}
		?Debug
		Assert img1, "ImagesColllide: No Image 1"
		Assert img2, "ImagesColllide: No Image 2"
		?
		Return brl.max2d.ImagesCollide(img1, x1, y1, frame1, img2, x2, y2, frame2)
	End Method

		
	Method ImagesCollide2:Int(img1:TImage, x1:Float, y1:Float, frame1:Int, rot1:Float, scaleX1:Float, scaleY1:Float,  ..
					 		 img2:TImage, x2:Float, y2:Float, frame2:Int, rot2:Float, scaleX2:Float, scaleY2:Float) {bool}
		?Debug
		Assert img1, "ImagesColllide: No Image 1"
		Assert img2, "ImagesColllide: No Image 2"
		?
		Return brl.max2d.ImagesCollide2(img1, x1, y1, frame1, rot1, scaleX1, scaleY1,  ..
										img2, x2, y2, frame2, rot2, scaleX2, scaleY2)
	End Method
	
	
	Method SetRotation(rot:Float)
		brl.max2d.SetRotation(rot)
	End Method
	
	
	Method SetAlpha(alpha:Float)
		brl.max2d.SetAlpha(alpha)
	End Method
	
	
	Method GetAlpha:Float()
		brl.max2d.GetAlpha()
	End Method
	
	
	Method SetColor(r:Float, g:Float, b:Float)
		brl.max2d.SetColor(r, g, b)
	End Method
	
	
	Method SetScale(sx:Float, sy:Float)
		brl.max2d.SetScale(sx, sy)
	End Method
	
	
	Method SetBlend(blend:Int)
		brl.max2d.SetBlend(blend)
	End Method
	
	
	'#endregion

	
	'#region audio
	'---------------------------------------------
	
	rem
	bbdoc: Returns sound from resource manager.
	endrem
	Method GetResourceSound:TSound(soundName:String, groupName:String = "default")
		Return TResources.GetSound(soundName, groupName)
	End Method
	
	
	rem
	bbdoc: Plays sound from the resource manager.
	returns: Used audio channel.
	endrem
	Method PlaySound:TChannel(soundName:String, groupName:String = "",  ..
							volume:Float, channel:TChannel)
								
		Local s:TSound = TResources.GetSound(soundName, groupName)
		?Debug
		Assert s, "Lua PlaySound: sound '" + soundName + "' in group '" + groupName + "' not found!"
		?
		Return _game.PlaySound(s, channel, volume)
	End Method
	
	
	rem
	bbdoc: Stops passed audio channel.
	endrem
	Method StopAudioChannel(c:TChannel)
		c.Stop()
	End Method
	
	'#endregion

End Type

