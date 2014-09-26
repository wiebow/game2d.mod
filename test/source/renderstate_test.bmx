
'unit tests for TRenderState

Type TRenderStateTest Extends TTest

	Method Before() {before}
		SetGraphicsDriver(GLMax2DDriver())
		Graphics(800, 600)
	End Method

	Method After() {after}
		EndGraphics()
	End Method


	Method Reset() {test}
		Local x:Float, y:Float

		SetRotation(50)
		SetScale(10,5)
		SetOrigin(2,4)
		SetColor(10,20,30)
		SetAlpha(0.5)
		SetBlend(SHADEBLEND)

		TRenderState.Reset()
		assertEqualsF(0.0, GetRotation(), 0, "rotation")
		assertEqualsI(ALPHABLEND, GetBlend(), "blend")

		GetOrigin(x,y)
		assertEqualsF(0.0, x, 0, "origin x")
		assertEqualsF(0.0, y, 0, "origin y")

		GetScale(x,y)
		assertEqualsF(1.0, x, 0, "scale x")
		assertEqualsF(1.0, y, 0, "scale y")

		assertEqualsF(1.0, GetAlpha(), 0, "alpha")

		Local r:Int, g:Int, b:Int
		GetColor(r,g,b)
		assertEqualsI(255, r, "red")
		assertEqualsI(255, g, "green")
		assertEqualsI(255, b, "blue")

	End Method


	Method PushAndPop() {test}
		Local x:Float, y:Float

		SetRotation(50)
		SetScale(10,5)
		SetOrigin(2,4)
		SetColor(10,20,30)
		SetAlpha(0.5)
		SetBlend(SHADEBLEND)

		TRenderState.Push()
		assertEqualsI(1, TRenderState._stack.Count(), "no state on stack.")

		TRenderState.Reset()
		TRenderState.Pop()
		assertEqualsI(0, TRenderState._stack.Count(), "state left on stack.")

		assertEqualsF(0.0, GetRotation(), 50, "rotation")
		assertEqualsI(SHADEBLEND, GetBlend(), "blend")

		GetOrigin(x,y)
		assertEqualsF(2.0, x, 0, "origin x")
		assertEqualsF(4.0, y, 0, "origin y")

		GetScale(x,y)
		assertEqualsF(10.0, x, 0, "scale x")
		assertEqualsF(5.0, y, 0, "scale y")

		Local r:Int,g:Int, b:Int
		GetColor(r,g,b)
		assertEqualsI(10, r, "red")
		assertEqualsI(20, g, "green")
		assertEqualsI(30, b, "blue")

		assertEqualsF(0.5, GetAlpha(), 0,"alpha" )
	End Method

End Type

