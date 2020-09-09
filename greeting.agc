global startButton = 1
global settingsButton = 2
global hofButton = 3
global buttonsCreated = 0
global bksprite


function runGreeting()

#constant S_Width = 640
#constant S_Height = 480
heightOffset as float = 35
centerText as float

bkSprite = CreateSprite(LoadImage("GreetingBack3.png"))
SetSpritePosition(bkSprite, S_Width/2-210, 30)

// Greeting page

//Load Font to use
iFontId = LoadFont("GREENFUZ.ttf") 

setBackGroundColor()

//title as set of strings
title1 as string = "Z's Halloween Scare"
title2 as string = "by Josh Sheedy"
title3 as string = "Music Too Crazy by David Fesliyan"
title4 as string = "Font by Typodermic Fonts"

//write some title information, may restructure 

	CreateText(1,title1)
    createtext(2,title2)
    CreateText(3,title3)
    createtext(4,title4)

//set some text values like font, size, and color
For i=1 to 4
	setTextFont(i, iFontId)
	SetTextSize(i,32)
	SetTextColor(i,0,0,0,255)
	SetTextVisible(i,0)
Next i

repeat
	SetTextAngle(1,4)
	SetTextAngle(2,-4)
	SetTextAngle(3,4)
	SetTextAngle(4,-4)	
	 
	for i = 1 to 4
		SetTextVisible(i,1)
		SetTextPosition(i,700,heightOffset)
		centerText = ((S_Width/2)-(GetTextTotalWidth(i)/2))
		if i = 1 or i = 3
			for j = 500 to centerText step -20
				settextx(i,j)
				sync()
				//sleep(100)
			next j
			settextx(i,centerText)
			SetTextAngle(i,0)
		else
			for j = -100 to centerText step 20
				settextx(i,j)
				sync()
			next j
			settextx(i,centerText)
			SetTextAngle(i,0)
		endif
	heightOffset = heightOffset + 40	
	next i	
until i > 4

// make a virtual button (start, settings, Hall of Fame)
if buttonsCreated = 0
	AddVirtualButton(startButton,70,70,80)
	SetVirtualButtonColor(startButton, 205, 93, 25)
	SetVirtualButtonText(startButton, "Start")
	SetVirtualButtonPosition(startButton, 220,400)
 
	AddVirtualButton(settingsButton,70,70,80)
	SetVirtualButtonColor(settingsButton, 205, 93, 25)
	SetVirtualButtonText(settingsButton, "Settings")
	SetVirtualButtonPosition(settingsButton, 320,400)
 
	AddVirtualButton(hofButton,70,70,80)
	SetVirtualButtonColor(hofButton, 205, 93, 25)
	SetVirtualButtonText(hofButton, "HOF")
	SetVirtualButtonPosition(hofButton, 420,400)
	
	buttonsCreated = 1
else
	SetVirtualButtonVisible(startButton,1)
	SetVirtualButtonVisible(settingsButton,1)
	SetVirtualButtonVisible(hofButton,1)
	SetVirtualButtonPosition(startButton, 220,400)
	SetVirtualButtonPosition(settingsButton, 320,400)
	SetVirtualButtonPosition(hofButton, 420,400)
endif 
	
		
do
//print(GetTextTotalWidth(3))
//print(GetTextTotalHeight(3))
//DrawLine(320,0,320,480,0,0,255)  	
sync()

	if GetVirtualButtonPressed(startButton)
		deleteGreeting()
		level = 1
		lives = 3
		SetSpriteVisible(1,1)
		gosub mainSection
	endif
	
	if GetVirtualButtonPressed(settingsButton)
		deleteGreeting()
		sync()
		sleep(100)
		gameSettings()
		DeleteAllText()
		hideSettingsSprites()
		runGreeting()
	endif
	
	if GetVirtualButtonPressed(hofButton)
		deleteGreeting()
		hallOfFame()
	endif

loop
endfunction


function deleteGreeting()
	DeleteAllText()
	SetVirtualButtonVisible(startButton,0)
	SetVirtualButtonVisible(settingsButton,0)
	SetVirtualButtonVisible(hofButton,0)
	SetVirtualButtonPosition(startButton, -500, -500)
	SetVirtualButtonPosition(settingsButton, -500, -500)
	SetVirtualButtonPosition(hofButton, -500, -500)
	SetClearColor (0, 0, 0 )
	SetSpritePosition(bksprite, -500,-500)
	SetSpriteVisible(bksprite, 0)

EndFunction

