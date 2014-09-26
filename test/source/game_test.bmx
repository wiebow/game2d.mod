
'unit tests for TGame

Type TGameTest Extends TTest

	Field g:TGame

	Method Before() {before}
		g = New TGame
	End Method

	Method After() {after}
		g = Null
	End Method


	Method Constructor() {test}
		assertNotNull(g, "could not create game.")
		assertNotNull(g._timer, "timer not created")
		assertNotNull(g._gameStates, "game state bag not created")
	End Method

	'lua tests

'	Method testLuaSetup() {test}
'		g.SetUpLua()
'		AssertNotNull(g._luaState, "lua state not created")
'	End Method



	'sound tests


	'actor tests


	'gamestate tests


	'runtime tests

	Method SetTitle() {test}
		g.SetTitle("test")
		?debug
		assertEquals("test - debug build", g.GetTitle())
		?
	End Method


	Method SetPaused() {test}
		g.SetPaused(False)
		assertFalse(g.IsPaused())
	End Method


	Method RequestStop(){test}
		g.RequestStop()
		assertFalse(g._running)
	End Method

	'gfx and render tests

	Method SetVSync() {test}
		g.SetVSync(False)
		assertFalse(g.GetVSync())
	End Method

	'user hooks test
	'nvt

End Type
