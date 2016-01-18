
'unit tests for resource manager

Type TResourceManagerTest Extends TTest

	Field rm:TResourceManager
	Field testImage:TImage = LoadImage("media\ship.png")
	Field testSound:TSound = LoadSound("media\bullet.wav")


	Method Before() {before}
		rm = TResourceManager.GetInstance()
		rm.AddGroup("test")
	End Method

	Method After() {after}
		rm.Destroy
	End Method


	Method Constructor() {test}
		assertNotNull(rm.resources, "no resources map")
	End Method


	Method AddAndGetGroup() {test}
		rm.AddGroup("test")
		assertNotNull(rm.GetGroup("test"))
	End Method


	Method AddAndGetSound() {test}
		rm.AddSound(testSound, "testsound", "test")
		assertSame(testSound, rm.GetSound("testsound", "test"), "should work")
	End Method


	Method AddAndGetImage() {test}
		rm.AddImage(testImage, "ship", "test")
		assertSame(testImage, rm.GetImage("ship", "test"), "should work")
	End Method


	Method AddAndGetObject() {test}
		Local testObject:TDummyObject = New TDummyObject
		rm.AddObject(testObject, "object", "test")
		assertNotNull(rm.GetObject("object", "test"), "should work")
	End Method


	Method AddAndGetString() {test}
		Local testString:String = "hoi"
		rm.AddString(testString, "script", "test")
		assertSame(testString, rm.GetString("script", "test"), "should work")
	End Method


End Type


Type TDummyObject
End Type

