

Rem
	bbdoc:   Control mapped to keyboard key
	about:
EndRem
Type TKeyControl Extends TControl

	Field keyCode:Int
	field previousDown:Int
	field down:Int
	field hit:Int
	

	Function Create:TKeyControl(name:String, key:Int)
		Local c:TKeyControl = new TKeyControl
		c.name = name
		c.keyCode = key
		return c
	EndFunction


	Method GetDown:Int()
		return down
	EndMethod


	Method GetHit:Int()
		return hit
	EndMethod


	Method SetKey(newCode:Int)
		keyCode = newCode
	EndMethod


	Method GetKey:Int()
		return keyCode
	End Method
	

	'uses the global function GetKeyCodeString(key), defined in functions.bmx
	Method ToString:String()
		return name + ": " + GetKeyCodeString(keyCode)
	EndMethod


	Method GetMappedKey:String ()
		Return GetKeyCodeString(keyCode)
	EndMethod
	


	Method Update()
		previousDown = down
		down = KeyDown(keyCode)
		hit = KeyHit(keyCode)
	EndMethod

EndType