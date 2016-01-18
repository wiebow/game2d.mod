
'unit tests for Trect

Type TRectTest Extends TTest

	Field r:TRect

	Method Before() {before}
		r = TRect.Create(0, 0, 100, 100, False)
	End Method

	Method After() {after}
		r = Null
	End Method


	Method Create1() {test}
		'origin at 0,0
		assertEqualsI(0, r.GetX(), "origin x is not correct." )
		assertEqualsI(0, r.GetY(), "origin y is not correct" )
		assertEqualsI(100, r.GetWidth(), "width is not correct.")
		assertEqualsI(100, r.GetHeight(), "height is not correct.")
	End Method


	Method Create2() {test}
		'centered around 0,0
		r = TRect.Create(0, 0, 100, 100, True)
		assertEqualsI(-50, r.GetX(), "centered origin x is not correct.")
		assertEqualsI(-50, r.GetY(), "centered origin y is not correct.")
	End Method


	Method PointInside() {test}
		Local v:TVector2D = TVector2D.Create(10, 10)
		assertTrue(r.PointInSide(v), "point must be inside.")

		v.Set(-100, -100)
		assertFalse(r.PointInside(v), "point must be outside.")
	End Method


	Method Inside() {test}

		Local r2:TRect = TRect.Create(10, 10, 10, 10)
		assertTrue(r.Inside(r2), "rect2 is not inside rect1." )

		r2.SetPosition(-50, -50)
		r2.SetDimension(10, 10)
		assertFalse(r.Inside(r2), "outside")

		r2.SetPosition(-20, -20)
		r2.SetDimension(50, 50)
		assertFalse(r.Inside(r2), "not inside, but overlapping")

	End Method


	Method OverLap() {test}

		Local r2:TRect = TRect.Create(-20, -20, 20, 20)
		assertFalse(r.OverLappedBy(r2), "rects do not overlap")

		r2.SetPosition(-10, -10)
		assertTrue(r.OverLappedBy(r2), "rect 2 does not overlap (1).")
		r2.SetPosition(90, 90)
		assertTrue(r.OverLappedBy(r2), "rect 2 does not overlap (2).")

		r2.SetPosition(50, 50)
		assertTrue(r.OverLappedBy(r2), "inside is not seen as overlapping.")

		r2.SetPosition(-10, -10)
		r2.SetDimension(200, 200)
		assertTrue(r.OverLappedBy(r2), "rect 2 is bigger but not overlapping.")

		r2.SetPosition(-300, -300)
		assertFalse(r.OverLappedBy(r2), "rect 2 should not overlap.")
	End Method

End Type