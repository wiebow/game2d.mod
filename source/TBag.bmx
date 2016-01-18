
Rem
bbdoc: An unsorted collection type, using array for speed.
about: Contains objects which can be retrieved by index	.
end rem
Type TBag

	'content goes here
	Field array:Object[16]

	'we have this many active elements in the array.
	'also, this points to the next empty slot
	'as array starts at 0
	Field currentSlot:Int


	Method New()
		currentSlot = 0
	End Method



	Rem
	bbdoc: Removes the element at the specified position.
	returns: The removed object.
	endrem
	Method RemoveByIndex:Object(index:Int)

		'save the element to remove
		Local o:Object = array[index]

		'put the last element in its place
		array[index] = array[currentSlot - 1]

		'empty the last slot
		array[currentSlot - 1] = Null

		'move slot count back by 1
		currentSlot:- 1

		'return removed element
		Return o
	End Method


	Rem
	bbdoc: Removes and returns the last item in the bag.
	returns: Removed object or null.
	endrem
	Method RemoveLast:Object()
		If currentSlot > 0
			currentSlot:- 1
			Local o:Object = array[currentSlot]
			array[currentSlot] = Null
			Return o
		End If
		Return Null
	End Method


	Rem
	bbdoc: Removes the first occurance of the specified element.
	returns: True if remove succeeded.
	endrem
	Method Remove:Int(o:Object)
		For Local i:Int = 0 Until currentSlot
			If array[i] = o
				RemoveByIndex(i)
				Return True
			End If
		Next
		Return False
	End Method



	Rem
	bbdoc: Returns the number of element slots in the bag.
	endrem
	Method GetCapacity:Int()
		Return array.Length
	End Method



	Rem
	bbdoc: Returns the number of elements in the bag.
	endrem
	Method GetSize:Int()
		Return currentSlot
	End Method



	Rem
	bbdoc: Returns true if the bag contains no elements.
	endrem
	Method IsEmpty:Int()
		If currentSlot = 0 Then Return True
		Return False
	End Method



	Rem
	bbdoc: Grows bag array capacity.
	about: Each grow step is bigger than the previous as more growth calls = more need for more space.
	endrem
	Method Grow(newSize:Int = 0 )

		'find a new size.
		If newSize = 0 Then newSize = (array.Length *3) / 2 + 1

		array = array[..newSize]
	End Method



	Rem
	bbdoc: Adds specified element to end of this bag.
	about: If needed also increases the capacity of the bag.
	endrem
	Method Add(o:Object)
		'could be out of bounds
		If currentSlot = array.Length Then Grow()

		array[currentSlot] = o
		currentSlot:+ 1
	End Method



	Rem
	bbdoc: Set element at specified index in the bag.
	about: Sizes bag if needed.
	endrem
	Method Set(index:Int, o:Object)
		If index >= array.Length
			Grow(index *2)
			currentSlot = index + 1
		ElseIf index >= currentSlot
			currentSlot = index+1
		End If
		array[index] = o
	End Method


	Rem
	bbdoc: Returns true if specified element is in the bag.
	about: Only finds the first occurance.
	endrem
	Method Contains:Int(o:Object)
		For Local i:Int = 0 Until currentSlot
			If array[i] = o Then Return True
		Next
		Return False
	End Method



	Rem
	bbdoc: Returns the element at the specified index.
	endrem
	Method Get:Object(index:Int)
		Return array[index]
	End Method



	Rem
	bbdoc: Removes from this bag all of its elements that are contained in the specified bag.
	returns: True if contents of this bag are changed.
	endrem
	Method RemoveAllFrom:Int(b2:TBag)
		Local modified:Int = False
		For Local index2:Int = 0 Until b2.GetSize()
			For Local index:Int = 0 Until GetSize()
				If b2.array[index2] = array[index]
					RemoveByIndex(index)
					modified = True
					index:-1
					Continue
				EndIf
			Next
		Next
		Return modified
	End Method



	Rem
	bbdoc: Removes all elements from this bag.
	endrem
	Method Clear()
		For Local i:Int = 0 Until array.Length
			array[i] = Null
		Next
		currentSlot = 0
	End Method



	Rem
	bbdoc: Adds all items from specified bag into this bag.
	endrem
	Method AddAllFrom(b2:TBag)
		For Local i:Int = 0 Until b2.GetSize()
			Add(b2.Get(i))
		Next
	End Method
End Type

