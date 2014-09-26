
Rem
bbdoc: Game state transition.
endrem
Type TTransition Abstract


	rem
	bbdoc: Transition effect color and alpha.
	endrem
	Field _color:TColor = TColor.Create(0,0,0,1.0)

	rem
	bbdoc: Transition effect length.
	about: Default length is one second.
	endrem
	Field _transitionLength:Int = 1000


	rem
	bbdoc: User hook to initialize effect.
	endrem
	Method Initialize() Abstract


	rem
	bbdoc: Perform transition action.
	endrem
	Method Update(delta:Double) Abstract


	rem
	bbdoc: Render transition effect.
	endrem
	Method Render() Abstract


	rem
	bbdoc: Returns true if the transition is complete.
	endrem
	Method IsComplete:Int() Abstract


	rem
	bbdoc: Sets transition effect length.
	endrem
	Method SetLength(seconds:Int)
		'converted to millisecs
		_transitionLength = seconds * 1000
	End Method


	rem
	bbdoc: Sets transition effect color.
	endrem
	Method SetEffectColor(r:Int, g:Int, b:Int)
		_color.Set(r,g,b, _color.GetAlpha())
	End Method

End Type
