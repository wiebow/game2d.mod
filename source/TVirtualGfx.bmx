
Type TVirtualGfx

	Global VG:TVirtualGfx
	
	Global DTInitComplete:Int = False
	Global DTW:Int
	Global DTH:Int

	Field vwidth:Int
	Field vheight:Int

	Field vxoff:Float
	Field vyoff:Float

	Field vscale:Float
	
	Function CreateVG:TVirtualGfx (width:Int, height:Int)
		VG = New TVirtualGfx
		VG.vwidth = width
		VG.vheight = height
	End Function

	
	
	Function SetVirtualGraphics (vwidth:Int, vheight:Int, monitor_stretch:Int = False)

		' InitVirtualGraphics has been called...
		
		If TVirtualGfx.DTInitComplete
		
			' Graphics has been called...
			
			If GraphicsWidth () = 0 Or GraphicsHeight () = 0
				Notify "Programmer error! Must call Graphics before SetVirtualGraphics", True; End
			EndIf
			
		Else
			EndGraphics; Notify "Programmer error! Call InitVirtualGraphics before Graphics!", True; End
		EndIf

		' Reset of display needed when re-calculating virtual graphics stuff/clearing borders...
			
		SetVirtualResolution GraphicsWidth(), GraphicsHeight()
		SetViewport 0, 0, GraphicsWidth(), GraphicsHeight()
		SetOrigin 0, 0

		' Store current Cls colours...
		
		Local clsr:Int, clsg:Int, clsb:Int
		GetClsColor clsr, clsg, clsb
		
		' Set to black...
		
		SetClsColor 0, 0, 0
		
		' Got to clear both front AND back buffers or it flickers if new display area is smaller...
		
		Cls
		Flip

		Cls
		Flip
		
		Cls
		Flip
		
		' EDIT, 10 Nov 2011: I had a 3rd Cls/Flip here in case triple-buffering was enabled, but have finally
		' tested this and it wasn't needed. (Tested on NVIDIA GTX 260, Windows 7, with driver
		' version 275.33.)

		' EDIT 2, 30 Dec 2011: Reinstated 3rd Cls/Flip for triple-buffering; see first thread comment!

		' Put back Cls colours...

		SetClsColor clsr, clsg, clsb
		
		' Create new (global) virtual display object...
		
		TVirtualGfx.CreateVG (vwidth, vheight)
		
		' Real Graphics width/height...
		
		Local gwidth:Int
		Local gheight:Int
		
		' If monitor is correcting aspect ratio IN FULL-SCREEN MODE, use desktop size, otherwise use
		' specified Graphics size. NB. This assumes user's desktop is using native monitor resolution,
		' as most laptops would be by default...
		
		If monitor_stretch And GraphicsDepth()

			' Pretend real Graphics mode is desktop width/height...

			gwidth = DTW
			gheight = DTH

		Else

			' Use real Graphics width/height...

			gwidth = GraphicsWidth ()
			gheight = GraphicsHeight ()

		EndIf
		
		' Width/height ratios...
		
		Local graphicsratio:Float = Float (gwidth) / Float (gheight)
		Local virtualratio:Float = Float (TVirtualGfx.VG.vwidth) / Float (TVirtualGfx.VG.vheight)
		
		' Ratio-to-ratio. Don't even know what you'd call this, but hours of trial and error
		' provided the right numbers in the end...
		
		Local gtovratio:Float = graphicsratio / virtualratio
		Local vtogratio:Float = virtualratio / graphicsratio
		
		' Compare ratios...

		If graphicsratio => virtualratio
			
			' Graphics ratio wider than (or same as) virtual graphics ratio...

			TVirtualGfx.VG.vscale = Float (gheight) / Float (TVirtualGfx.VG.vheight)
			
			' Now go crazy with trial-and-error... ooh, it works! This tiny bit of code took FOREVER.
			
			Local pixels:Float = Float (TVirtualGfx.VG.vwidth) / (1.0 / TVirtualGfx.VG.vscale) ' Width after scaling
			Local half_scale:Float = (1.0 / TVirtualGfx.VG.vscale) / 2.0

			SetVirtualResolution TVirtualGfx.VG.vwidth * gtovratio, TVirtualGfx.VG.vheight

			' Offset into 'real' display area...
			
			TVirtualGfx.VG.vxoff = (gwidth - pixels) * half_scale
			TVirtualGfx.VG.vyoff = 0
		
			' Set up virtual graphics area...
			
			SetViewport TVirtualGfx.VG.vxoff, TVirtualGfx.VG.vyoff, TVirtualGfx.VG.vwidth, TVirtualGfx.VG.vheight
			SetOrigin TVirtualGfx.VG.vxoff, TVirtualGfx.VG.vyoff
			
		Else
			
			' Graphics ratio narrower...
		
			TVirtualGfx.VG.vscale = Float (gwidth) / Float (TVirtualGfx.VG.vwidth)
			
			Local pixels:Float = Float (TVirtualGfx.VG.vheight) / (1.0 / TVirtualGfx.VG.vscale) ' Height after scaling
			Local half_scale:Float = (1.0 / TVirtualGfx.VG.vscale) / 2.0
			
			SetVirtualResolution TVirtualGfx.VG.vwidth, TVirtualGfx.VG.vheight * vtogratio
		
			TVirtualGfx.VG.vxoff = 0
			TVirtualGfx.VG.vyoff = (gheight - pixels) * half_scale
		
			SetViewport TVirtualGfx.VG.vxoff, TVirtualGfx.VG.vyoff, TVirtualGfx.VG.vwidth, TVirtualGfx.VG.vheight
			SetOrigin TVirtualGfx.VG.vxoff, TVirtualGfx.VG.vyoff
			
		EndIf
	
	End Function

	Method VMouseX:Float ()
		Local mx:Float = VirtualMouseX () - vxoff
		If mx < 0 Then mx = 0 Else If mx > vwidth - 1 Then mx = vwidth - 1
		Return mx
	End Method
	
	Method VMouseY:Float ()
		Local my:Float = VirtualMouseY () - vyoff
		If my < 0 Then my = 0 Else If my > vheight - 1 Then my = vheight - 1
		Return my
	End Method
	
	Method VirtualWidth:Int ()
		Return vwidth
	End Method

	Method VirtualHeight:Int ()
		Return vheight
	End Method
	
End Type

' -----------------------------------------------------------------------------
' ... and these helper functions (required)...
' -----------------------------------------------------------------------------

Function InitVirtualGraphics ()

	' There must be a smarter way to check if Graphics has been called...
	
	If GraphicsWidth () > 0 Or GraphicsHeight () > 0 Then EndGraphics; Notify "Programmer error! Call InitVirtualGraphics BEFORE Graphics!", True; End

	TVirtualGfx.DTW = DesktopWidth ()
	TVirtualGfx.DTH = DesktopHeight ()

	' This only checks once... best to call InitVirtualGraphics again before any further Graphics calls (if you call EndGraphics at all)...
	
	TVirtualGfx.DTInitComplete = True

End Function

Function SetVirtualGraphics (vwidth:Int, vheight:Int, monitor_stretch:Int = False)
	TVirtualGfx.SetVirtualGraphics (vwidth, vheight, monitor_stretch)
End Function

Function VMouseX:Float ()
	Return TVirtualGfx.VG.VMouseX ()
End Function

Function VMouseY:Float ()
	Return TVirtualGfx.VG.VMouseY ()
End Function

' Don't need VirtualMouseXSpeed/YSpeed replacements!

Function VirtualWidth:Int ()
	Return TVirtualGfx.VG.VirtualWidth ()
End Function

Function VirtualHeight:Int ()
	Return TVirtualGfx.VG.VirtualHeight ()
End Function
