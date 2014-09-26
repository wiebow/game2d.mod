

rem
	bbdoc: Fixed time step and render tweening
	about: Default frequency is 60 updates per second
end rem
Type TFixedTime

	Field _accumulator:Double
	Field _deltaTime:Double
	Field _time:Double


	Method New()
		SetUpdateFrequency(60)
	End Method


	Rem
		bbdoc: Sets the update rate for this timer.
		about: The update rate is converted to millisecs.
	endrem
	Method SetUpdateFrequency(f:Int)
		_deltaTime = 1000.0:Double / f
	End Method


	Rem
		bbdoc: Calculates and returns the render tweening value
		returns: Double
	endrem
	Method GetTweening:Double()
		Return _accumulator / _deltaTime
	End Method


	Rem
		bbdoc: Returns update delta time (in millisecs)
		returns: Double
	endrem
	Method GetDeltaTime:Double()
		Return _deltaTime
	End Method


	Rem
		bbdoc: Resets the timer
		about: Sets the time to current millisecs value and resets the accumulator
	endrem
	Method Reset()
		_time = MilliSecs()
		_accumulator = 0
	End Method


	Rem
		bbdoc: Adds time passed since last update to the accumulator
		about: This method is called from the TGame.Run() method
	endrem
	Method Update()
		Local thistime:Double = MilliSecs()
		Local passedtime:Double = thistime - _time
		_time = thistime
		_accumulator:+ passedtime
	End Method


	Rem
		bbdoc: Returns true when an update is needed
		about: This method is called from the TGame.Run() method
	endrem
	Method TimeStepNeeded:Int()
		If _accumulator >= _deltaTime
			_accumulator:- _deltaTime
			Return True
		End If
		Return False
	End Method

End Type
