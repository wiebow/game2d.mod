

Type TEntityManagerTest Extends TTest

	Field em:TEntityManager
	Field e:TEntity


	Method TestSetup() {before}
		em = TEntityManager.GetInstance()
		em.AddGroup("test")
	End Method

	Method TestTeardown() {after}
		em.Destroy()
	EndMethod


	Method Constructor() {test}
		AssertNotNull(em._renderLayers, "render layers are not present.")
		AssertNotNull(em.GetEntities(), "entities list is not present.")
	End Method


	Method TestAddEntity() {test}
		e = New TEntity
		AddEntity( e, 2, "test" )

		AssertTrue(em.GetEntities().Contains(e), "entity not in main list.")
		AssertEqualsI(2, e.GetRenderLayer(), "entity layer not set to 2.")

		AssertNotNull(em._renderLayers.Get(2), "layer 2 not created.")
		AssertTrue(TList(em._renderLayers.Get(2)).Contains(e), "entity not in layer 2.")
	End Method


	Method TestRemoveEntity() {test}
		e = New TEntity
		AddEntity(e, 2, "test")

		em.RemoveEntity(e)

		AssertFalse(em._entityList.Contains(e), "entity not removed from main list.")
		AssertFalse(TList(em._renderLayers.Get(2)).Contains(e), "entity not removed from layer 2.")
	End Method


	Method TestAddAndGetGroup() {test}
		Local b:TBag = em.AddGroup("test_group")
		AssertNotNull(b, "No group bag returned.")
		AssertEquals(b, TBag(em.GetGroup("test_group")), "could not get test group.")
	End Method


	Method TestAddAndRemoveEntityFromGroup() {test}
		e = new TEntity
		AddEntity(e, 2, "test")

		local g:TBag = em.GetGroup("test")
		AssertTrue(g.Contains(e), "entity not added to group." )

		em.RemoveEntityFromGroup(e)
		AssertFalse(g.Contains(e), "entity not removed from group.")
		AssertEquals("", e.GetGroupName(), "group not set to null string.")
	End Method


	Method TestClearGroup() {test}
		e = new TEntity
		AddEntity(e, 2, "test")

		ClearEntityGroup("test")
		local g:TBag = em.GetGroup("test")
		AssertFalse(g.Contains(e), "entity not removed from group.")
		AssertEquals("", e.GetGroupName(), "entity group lin not set to null.")
	End Method


'	Method testClearAllGroups() {test}
'		e = new TEntity
'		em.AddEntity(e, 2, "test")
'
'		local g:TBag = em.GetGroup("test")
'		AssertTrue(g.Contains(e), "entity not added to group" )
'
'		em.ClearAllGroups()
'		AssertFalse(g.Contains(e), "entity not removed from group")
'	End Method

End Type


