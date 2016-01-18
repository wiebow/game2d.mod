
Type TBagTest Extends TTest

	Field b:TBag

	Method Before() {before}
		b = New TBag
	End Method

	Method After() {after}
		b = Null
	End Method


	Method Constructor() {test}
		assertNotNull(b, "no bag created.")
		assertEqualsI(16, b.GetCapacity(), "default capcity is not 16.")
	End Method


	Method IsEmpty() {test}
		assertTrue(b.IsEmpty(), "new bag is not empty.")
	End Method


	Method Add() {test}
		Local o1:String = "o1"
		assertFalse(b.Contains(o1), "object already in bag.")
		b.Add(o1)
		assertTrue(b.Contains(o1), "object not added to bag.")
	End Method


	Method GetSize() {test}
		assertEqualsI(0, b.GetSize(), "new bag size should be 0.")

		Local o1:String = "o1"
		b.Add(o1)
		assertEqualsI(1, b.GetSize(), "bag size should be 1.")
	End Method


	Method GetByLocation() {test}
		Local o1:String = "o1"
		Local o2:String = "o2"

		b.Add(o1)  	'index 0
		b.Add(o2)	'index 1
		assertSame(o1, b.Get(0), "string 0 is not at location 0.")
		assertSame(o2, b.Get(1), "string 1 is not at location 1.")
	End Method


	Method RemoveLast() {test}
		Local o1:String = "o1"
		Local o2:String = "o2"

		b.Add(o1)  	'index 0
		b.Add(o2)	'index 1
		assertEqualsI(2, b.GetSize())

		Local result:String = String(b.RemoveLast())
		assertSame(o2, result)
		assertEqualsI(1, b.GetSize())
	End Method


	Method RemoveByIndex() {test}
		Local o1:String = "o1"
		Local o2:String = "o2"

		b.Add(o1)  	'index 0
		b.Add(o2)	'index 1
		Local result:String = String(b.RemoveByIndex(0))
		assertSame(o1, result)

		'size should be down by 1
		assertEqualsI(1, b.GetSize())

		'o2 should be moved to index 0
		assertSame(o2, b.Get(0))
	End Method


	Method Remove() {test}
		Local o1:String = "o1"
		Local o2:String = "o2"
		Local o3:String = "o3"
		Local o4:String = "o4"

		'add 4 elements
		b.Add(o1)  	'index 0
		b.Add(o2)  	'index 1
		b.Add(o1)  	'index 2
		b.Add(o3)	'index 3
		assertSame(o1, b.Get(0))
		assertSame(o2, b.Get(1))
		assertSame(o1, b.Get(2))
		assertSame(o3, b.Get(3))

		'did not add this one
		assertFalse( b.Contains(o4))
		assertFalse( b.Remove(o4))

		assertTrue(b.Remove(o1))
		assertEqualsI(3, b.GetSize())

		'assert moves.
		'last elemens has moved to first o1 slot.
		'rest has remained in its slot
		assertSame(o3, b.Get(0), "not o3.")
		assertSame(o2, b.Get(1), "not o2.")
		assertSame(o1, b.Get(2), "not o1.")
	End Method


	Method RemoveAll() {test}
		Local o1:String = "o1"
		Local o2:String = "o2"
		Local o3:String = "o3"
		Local o4:String = "o4"

		b.Add(o1)
		b.Add(o2)
		b.Add(o3)
		b.Add(o4)
		b.Add(o2)
		b.Add(o1)
		b.Add(o3)
		b.Add(o4)

		Local b2:TBag = New TBag
		b2.Add(o1)
		b2.Add(o2)

		b.RemoveAllFrom(b2)

		'should be 4 gone
		assertEqualsI(4, b.GetSize())

		'o1 and o2 should be gone now
		assertFalse(b.Contains(o1))
		assertFalse(b.Contains(o2))

		assertSame(o4, b.Get(0), "not o4.")
		assertSame(o3, b.Get(1), "not o2.")
	End Method


	Method Set() {test}

		Local o1:String = "o1"
		Local o2:String = "o2"
		b.Add(o1)
		b.Add(o1)
		b.Add(o1)
		b.Add(o1)
		b.Add(o1)
		b.Add(o1)
		b.Add(o1)
		b.Add(o1)'8

		b.Set(1, o2)
		assertSame(o2, b.Get(1))

		'out of bounds. bag should grow
		b.Set(10,o2)
		assertSame(o2, b.Get(10))

	End Method


	Method AddAllFrom() {test}

		'fill up a new bag
		Local b2:TBag = New TBag
		Local o1:String = "o1"
		Local o2:String = "o2"
		b2.Add(o1)
		b2.Add(o2)

		b.AddAllFrom(b2)
		assertTrue( b.Contains(o1))
		assertTrue( b.Contains(o2))
	End Method


	Method Clear() {test}
		Local o1:String = "o1"
		b.Add(o1)
		b.Add(o1)
		b.Add(o1)
		b.Clear()
		assertEqualsI(0, b.GetSize(), "clear should remove all items.")
	End Method


	Method TestGrow() {test}
		b.Grow()
		AssertEqualsI(25, b.GetCapacity(), "first grow should be 25")
	End Method


End Type