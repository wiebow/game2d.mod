'unit test for game service

Type TServiceTest Extends TTest

	Field s:TServiceMock
	Field e:TEngine


	Method Before() {before}
		s = New TServiceMock
	End Method


	Method After() {after}
		s = Null
	End Method


	Method Constructor() {test}
		assertNotNull(s)
	End Method


	Method SetEnabled() {test}
		s.SetEnabled(True)
		assertTrue(s._enabled)
	End Method

End Type
