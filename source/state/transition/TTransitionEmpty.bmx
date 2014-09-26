
rem
bbdoc: An empty gamestate transition.
end rem
Type TTransitionEmpty Extends TTransition


	Method Initialize()
	End Method

	
	Method Render()
	End Method
	
	
	Method Update(delta:Double)
	End Method

	
	Method IsComplete:Int()
		Return True
	End Method

End Type
