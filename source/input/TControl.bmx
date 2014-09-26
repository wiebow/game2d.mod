
Rem
	bbdoc:   Input control
	about:  
EndRem
Type TControl Abstract

	Field name:String
	

	Method GetName:String() Final
		return name
	EndMethod

	Method SetName(newName:String) Final
		name = newName
	EndMethod
	

	Method ToString:String() Abstract

	Method Update() Abstract

EndType