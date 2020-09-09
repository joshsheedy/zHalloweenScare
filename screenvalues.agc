function setScreen()

// show all errors
SetErrorMode(1)

// set window properties
SetWindowTitle( "Z's Halloween Scare" )
SetWindowSize( 640, 480, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the 
SetSyncRate(30,0)

// set display properties
SetVirtualResolution( 640, 480 ) // doesn't have to match the window
SetOrientationAllowed( 0, 0, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
//SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

endfunction

function setBackGroundColor()	
	
// Set a background color
SetClearColor (255, 200, 100 )
	
endfunction
