
Rem
	Copyright (c) 2014 Wiebo de Wit

	Permission is hereby granted, free of charge, to any person obtaining a copy of this
	software and associated documentation files (the "Software"), to deal in the
	Software without restriction, including without limitation the rights to use, copy,
	modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
	and to permit persons to whom the Software is furnished to do so, subject to the
	following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
	INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
	PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
endrem

SuperStrict

Rem
bbdoc: Game2D module: cross-platform (win32, linux) 2d game engine.
endrem
Module wdw.game2d

ModuleInfo "Version: 0.1"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2014 Wiebo de Wit"

ModuleInfo "History: 0.1"
ModuleInfo "Alpha."

'3rd party external modules
Import muttley.inifilehandler
Import wdw.vector2D

Import brl.map
Import brl.random
Import brl.freetypefont

'gfx
Import brl.max2d
Import brl.pngloader
Import brl.glmax2d
?Win32
Import brl.d3d9max2d
?

'audio
Import brl.audio
Import brl.wavloader
Import brl.openalaudio
Import pub.openal
Import brl.freeaudioaudio

?Linux
Import pub.freeaudio
?

?Win32
Import brl.directsoundaudio
?

'input
Import pub.freejoy

Include "source/TBag.bmx"
Include "source/TColor.bmx"
Include "source/TRect.bmx"
Include "source/TRenderState.bmx"

Include "source/functions.bmx"
Include "source/TFixedTime.bmx"
Include "source/TGame.bmx"

Include "source/state/TState.bmx"
Include "source/state/transition/TTransition.bmx"
Include "source/state/transition/TTransitionEmpty.bmx"
Include "source/state/transition/TTransitionFadeIn.bmx"
Include "source/state/transition/TTransitionFadeOut.bmx"

Include "source/manager/TEntityManager.bmx"
Include "source/manager/TResourceManager.bmx"
Include "source/manager/TGfxManager.bmx"
Include "source/manager/TInputManager.bmx"

'thanks, James Boyd. http://www.blitzbasic.com/codearcs/codearcs.php?code=2879
Include "source/TVirtualGfx.bmx"

Include "source/entity/TEntity.bmx"
Include "source/entity/TImageEntity.bmx"
Include "source/entity/TPosition.bmx"
Include "source/entity/TCameraEntity.bmx"

Include "source/input/TControl.bmx"
Include "source/input/TKeyControl.bmx"
