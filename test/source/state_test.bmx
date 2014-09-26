
'unit tests for TState

Type TStateTest Extends TTest

	Field g:TStateMock

	Method Before() {before}
		g = New TStateMock
	End Method

	Method After() {after}
		g = Null
	End Method


	Method Constructor() {test}
		g = New TStateMock
		assertNotNull(g, "could not create gamestate")
	End Method


	Method SetGame() {test}
		Local game:TGame = New TGame
		g.SetGame(game)
		assertSame(game, g.GetGame())
		game = Null
	End Method


	Method SetId() {test}
		g.SetId(10)
		assertEqualsI(10, g.GetId())
	End Method

End Type

