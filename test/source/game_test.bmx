
'unit tests for TGame

Type TGameTest Extends TTest

	Field g:TGame

	Method Before() {before}
		g = New TGame
	End Method

	Method After() {after}
		g.Stop()
		g = Null
	End Method

' ---------------------------------

	'construction and breakdown

	Method Constructor() {test}
		assertNotNull(g, "could not create game.")
		AssertNotNull(g._timer, "Timer not created.")
		AssertNotNull(g._gameStates, "Gamestates TBag not created.")
	End Method


	Method GlobalSet() {test}
		AssertSame(g, G_CURRENTGAME, "game global variable not set.")
	End Method


	Method TestDefaultFontScale() {test}
		AssertEqualsF(1.00000, g._fontScale, 0.01, "Font scale not properly set.")
	End Method


	Method ManagersCreate() {test}
		assertNotNull(TResourceManager.GetInstance(), "resource manager not created." )
		assertNotNull(TInputManager.GetInstance(), "resource manager not created." )
		assertNotNull(TGfxManager.GetInstance(), "graphics manager not created.")
		assertNotNull(TEntityManager.GetInstance(), "entity manager not created.")
	End Method


	Method ManagerDestroy() {test}
		g.Stop()
		assertNull(TResourceManager.singletonInstance, "resource manager not removed." )
		assertNull(TInputManager.singletonInstance, "input manager not removed." )
		assertNull(TGfxManager.singletonInstance, "graphics manager not removed.")
		assertNull(TEntityManager.singletonInstance, "entity manager not removed.")
	End Method


	'configuration

	Method TestConfigCreate() {test}
		AssertNotNull(g.GetConfig(), "Ini File not created.")
	End Method


	'font

	Method TestSetGameFont() {test}

		'create gfx context for this test
		InitializeGraphics( 800, 600, 800, 600 )

		Local f:TImageFont = LoadImageFont("media/arcade.ttf", 24)
		SetGameFont(f)
		AssertSame(f, GetGameFont(), "Image font not set.")
	End Method


	Method TestGameFontSize() {test}
		'create gfx context for this test
		InitializeGraphics( 800, 600, 800, 600 )

		Local f:TImageFont = LoadImageFont("media/arcade.ttf", 24)
		SetGameFont(f)
		AssertEqualsI(31, GetGameFontSize(), "game font size not correct.")
	End Method


	'sound tests


	'gamestate tests

	Method TestGameStateAdd() {test}
		Local state:TStateMock = New TStateMock
		AddGameState( state, 0 )
		AssertNotNull(g.GetGameStateByID(0), "game state not added with id 0.")
	End Method


	'runtime tests

	Method TestMenuBackdrop() {test}
		Local r:Int, gg:Int, b:Int
		g.SetMenuBackdropColor(20,30,40)
		g.GetMenuBackdropColor(r,gg,b)

		AssertEqualsI(20, r, "menu red not set.")
		AssertEqualsI(30, gg, "menu green not set.")
		AssertEqualsI(40, b, "menu blue not set.")
	End Method


	Method SetTitle() {test}
		SetGameTitle("test")
		?debug
		AssertEquals("test - debug build", g.GetTitle(), "debug Title not set correctly.")
		?
		?Not Debug
		AssertEquals("test", g.GetTitle(), "Title not set correctly.")
		?
	End Method


	Method SetPaused() {test}
		g.SetPaused(False)
		assertFalse(g.IsPaused())
	End Method


	Method RequestStop() {test}
		g.RequestStop()
		assertFalse(g._running)
	End Method


	'gfx and render tests

	Method SetVSync() {test}
		g.SetVSync(False)
		assertFalse(g.GetVSync())
	End Method

End Type
