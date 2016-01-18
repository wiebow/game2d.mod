Rem
bbdoc: unit test for entity type
EndRem
Type TEntityTest Extends TTest

	Field e:TEntity

	Method _setup() {before}
		e = New TEntity
	End Method

	Method _teardown() {after}
		e = Null
	End Method

	Method TestConstructor() {test}
		AssertNotNull(e, "could not create entity")
		AssertNotNull(e.GetPosition(), "position not present")
	End Method

	Method TestRenderLayer() {test}
		e.SetRenderLayer(10)
		AssertEqualsI(10, e.GetRenderLayer(), "render layer not set correctly")
	End Method


	Method TestSetGroup() {test}
		e.SetGroupName("test")
		AssertSame("test", e.GetGroupName(), "group name not set correctly")
	End Method

End Type