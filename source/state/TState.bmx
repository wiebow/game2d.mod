

Rem
bbdoc: A game2d state.
about: A state is like a 'screen' or a 'mode'. Examples are a 'titlestate' or a 'play'state'.
endrem
Type TState Abstract

	'game this state belongs to. Set by Game.AddState() method
	Field _game:TGame

	'id of this state
	Field _id:Int


	rem
		bbdoc: User hook for state update logic.
	endrem
	Method Update(delta:Double)
	End Method


	rem
		bbdoc: User hook for state render code.
	endrem
	Method Render(tween:Double)
	End Method


	Method SetId(id:Int)
		_id = id
	End Method


	Rem
		bbdoc: Returns the ID of this state.
		returns: Int
	endrem
	Method GetId:Int()
		Return _id
	End Method


	'sets the game owning this state.
	Method SetGame(g:TGame)
		_game = g
	End Method


	rem
	bbdoc: Returns the game owning this state.
	endrem
	Method GetGame:TGame()
		Return _game
	End Method


	Rem
	bbdoc: User hook for code when entering this state.
	endrem
	Method Enter()
	End Method


	Rem
	bbdoc: User hook for code when leaving this state.
	endrem
	Method Leave()
	End Method


	Rem
		bbdoc:   User hook for code when the game needs to restart.
		about:   Called from TGame.OnRestartGame()
		returns: 
	EndRem
	Method OnRestartGame()
	EndMethod
	


	rem
	bbdoc: User hook for update code after state updating.
	endrem
	Method PostUpdate(delta:Double)
	End Method


	rem
	bbdoc: User hook for update code before state updating.
	endrem
	Method PreUpdate(delta:Double)
	End Method


	rem
	bbdoc: User hook for rendering after state rendering.
	endrem
	Method PostRender(tween:Double)
	End Method


	rem
	bbdoc: User hook for rendering before state rendering.
	endrem
	Method PreRender(tween:Double)
	End Method

End Type
