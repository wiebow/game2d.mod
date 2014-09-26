
'unit test for TTransition

Type TTransitionTest Extends TTest

	Field t:TTransition

	Method Before() {before}
		t = New TTransitionFadeIn
	End Method

	Method After() {after}
		t = Null
	End Method


	Method Constructor() {test}
		assertNotNull(t._color)
		assertEqualsI(1000, t._transitionLength)
	End Method


	Method SetLength() {test}
		t.SetLength(5)
		assertEqualsI(5000, t._transitionLength, "should be 5000")
	End Method


	Method SetEffectColor() {test}
		t.SetEffectColor(100,10,200)
		assertEqualsI(100, t._color._r)
		assertEqualsI(10, t._color._g)
		assertEqualsI(200, t._color._b)
	End Method


	Method IsComplete() {test}
		t = New TTransitionFadeIn
		assertFalse( t.IsComplete() )

		t._color._a = 0.0
		assertTrue( t.IsComplete())
	End Method

End Type
