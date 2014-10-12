
'various helper functions for game 2d

Rem
	bbdoc: Renders text in the current game font.
	about: text coordinates are screen coordinates (not game world)
endrem
Function RenderText(text:String, xpos:int, ypos:int, centered:Int = False, ..
					  shadow:Int = False, caps:Int = false)

	TRenderState.Push()

	'save color
	local r:int, g:int, b:int
	GetColor(r,g,b)

	TRenderState.Reset()
	'take care of viewport offset
	SetOrigin(TVirtualGfx.VG.vxoff, TVirtualGfx.VG.vyoff)

	'restore color
	SetColor(r,g,b)

	Local scale:Float = G_CURRENTGAME.GetFontScale()
	SetScale( scale, scale )
	If caps Then text = text.ToUpper()

	If centered Then xpos = GameWidth() / 2 - ((TextWidth(text) * scale) / 2)
	If shadow
'		Local r:Int, g:Int, b:Int
		GetColor(r, g, b)
		SetColor 0, 0, 0
		DrawText(text, xpos + 1.0 * scale, ypos + 1.0 * scale)
		DrawText(text, xpos + 1.0 * scale, ypos )
		SetColor (r, g, b)
	End If
	DrawText(text, xpos, ypos)

	TRenderState.Pop()
End Function



'todo: does not work on linux.
Function TakeScreenShot()
	Local gfxGrab:TPixmap
	gfxGrab = GrabPixmap(0,0,GraphicsWidth(), GraphicsHeight())
	local time:String = CurrentTime()
	local date:String = CurrentDate()
	local filename:String = date + " " + time + " screenshot.png"
	filename = filename.Replace(":","-")
	filename = filename.Replace(" ","_")
	SavePixmapPNG(gfxGrab, Appdir + "/" + filename, 9)
'	debuglog Appdir + "/" + filename
End Function



Rem
	bbdoc:   Returns proper string for the passed key code.
	returns: String
EndRem
Function GetKeyCodeString:String(keyCode:Int)
	select keyCode
		Case 8   Return "Backspace"
		Case 9   Return "Tab"
		Case 12  Return "Clear"
		Case 13  Return "Return"
		Case 19  Return "Pause"
		Case 20  Return "Caps Lock"
		Case 27  Return "Escape"
		Case 32  Return "Space"
		Case 33  Return "Page Up"
		Case 34  Return "Page Down"
		Case 35  Return "End"
		Case 36  Return "Home"
		Case 37  Return "Arrow Left"
		Case 38  Return "Arrow Up"
		Case 39  Return "Arrow Right"
		Case 40  Return "Arrow Down"
		Case 41  Return "Select"
		Case 42  Return "'print"
		Case 43  Return "Execute"
		Case 44  Return "Screen"
		Case 45  Return "Insert"
		Case 46  Return "Delete"
		Case 47  Return "Help"
		Case 48  Return "0"
		Case 49  Return "1"
		Case 50  Return "2"
		Case 51  Return "3"
		Case 52  Return "4"
		Case 53  Return "5"
		Case 54  Return "6"
		Case 55  Return "7"
		Case 56  Return "8"
		Case 57  Return "9"
		Case 65  Return "A"
		Case 66  Return "B"
		Case 67  Return "C"
		Case 68  Return "D"
		Case 69  Return "E"
		Case 70  Return "F"
		Case 71  Return "G"
		Case 72  Return "H"
		Case 73  Return "I"
		Case 74  Return "J"
		Case 75  Return "K"
		Case 76  Return "L"
		Case 77  Return "M"
		Case 78  Return "N"
		Case 79  Return "O"
		Case 80  Return "P"
		Case 81  Return "Q"
		Case 82  Return "R"
		Case 83  Return "S"
		Case 84  Return "T"
		Case 85  Return "U"
		Case 86  Return "V"
		Case 87  Return "W"
		Case 88  Return "X"
		Case 89  Return "Y"
		Case 90  Return "Z"
		Case 96  Return "Numpad 0"
		Case 97  Return "Numpad 1"
		Case 98  Return "Numpad 2"
		Case 99  Return "Numpad 3"
		Case 100  Return "Numpad 4"
		Case 101  Return "Numpad 5"
		Case 102  Return "Numpad 6"
		Case 103  Return "Numpad 7"
		Case 104  Return "Numpad 8"
		Case 105  Return "Numpad 9"
		Case 106  Return "Numpad *"
		Case 107  Return "Numpad +"
		Case 109  Return "Numpad -"
		Case 110  Return "Numpad ."
		Case 111  Return "Numpad /"
		Case 112  Return "F1"
		Case 113  Return "F2"
		Case 114  Return "F3"
		Case 115  Return "F4"
		Case 116  Return "F5"
		Case 117  Return "F6"
		Case 118  Return "F7"
		Case 119  Return "F8"
		Case 120  Return "F9"
		Case 121  Return "F10"
		Case 122  Return "F11"
		Case 123  Return "F12"
		Case 144  Return "Num Lock"
		Case 145  Return "Scroll Lock"
		Case 160  Return "Left Shift"
		Case 161  Return "Right Shift"
		Case 162  Return "Left Control"
		Case 163  Return "Right Control"
		Case 164  Return "Left Alt"
		Case 165  Return "Right Alt"
		Case 192  Return "~~"
		Case 107  Return "-"
		Case 109  Return "="
		Case 219  Return "["
		Case 221  Return "]"
		Case 226  Return "\"
		Case 186  Return ":"
		Case 222  Return "~q"
		Case 188  Return ","
		Case 190  Return "."
		Case 191  Return "/"
		Default   Return "None"
	end select
End Function







Const RED:Int = 0
Const RED_LIGHT:Int = 1
Const RED_DARK:Int = 2
Const GREEN:Int = 3
Const GREEN_LIGHT:Int = 4
Const GREEN_DARK:Int = 5
Const BLUE:Int = 6
Const BLUE_LIGHT:Int = 7
Const BLUE_DARK:Int = 8
Const YELLOW:Int = 9
Const YELLOW_LIGHT:Int = 10
Const YELLOW_DARK:Int = 11

Const ORANGE:Int = 12
const ORANGE_LIGHT:Int = 13
Const ORANGE_DARK:Int = 14

Const BROWN:Int = 15
Const BROWN_LIGHT:Int = 16  
Const BROWN_DARK:Int = 17

Const WHITE:Int = 18 
Const GREY:Int = 19
Const GREY_LIGHT:Int = 20
Const GREY_DARK:Int = 21  
Const BLACK:Int = 22
Const BLACK_LIGHT:Int = 23 
Const CYAN:Int = 24


Rem
	bbdoc:   Provides consistant color palette.
	about:   
	returns: 
EndRem
Type TPalette
	'				     0    1    2    3    4    5    6    7    8    9    10   11   12 13 14 15 16 17 18   19   20   21  22 23  24
	Global red:Int[] = [ 255, 255, 100, 50,  100, 20,  50,  100, 20,  255, 255, 100, 0, 0, 0, 0, 0, 0, 255, 128, 200, 64, 0, 20, 100 ]
	Global grn:Int[] = [ 50,  100,  20, 255, 255, 100, 50,  100, 20,  255, 255, 100, 0, 0, 0, 0, 0, 0, 255, 128, 200, 64, 0, 20, 255 ]
	Global blu:int[] = [ 50,  100,  20, 50,  100, 20,  255, 255, 100, 50,  100, 20,  0, 0, 0, 0, 0, 0, 255, 128, 200, 64, 0, 20, 255 ]


	Function SetEntityColor( e:TImageEntity, clr:Int )
		e.SetColor( TPalette.red[clr], TPalette.grn[clr], TPalette.blu[clr] )
	End Function
	

	Function SetColor( clr:Int )
		brl.max2d.SetColor( TPalette.red[clr], TPalette.grn[clr], TPalette.blu[clr] )
	End Function	
EndType


'some helper functions for palette


Rem
	bbdoc:   Sets render color with passed color constant.
	about:   
	returns: 
EndRem
Function SetGameColor( clr:Int )
	TPalette.SetColor( clr )
EndFunction


Rem
	bbdoc:   Sets entity render color with passed color constant.
	about:   
	returns: 
EndRem
Function SetEntityColor( e:TImageEntity, clr:Int )
	TPalette.SetEntityColor( e, clr )	
EndFunction
