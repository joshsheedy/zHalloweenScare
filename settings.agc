type checkBox
	spriteID as integer
	state as integer
endtype

function gameSettings()
DeleteAllText()	

//some vars
LMB as integer  // left mouse button
MB as integer   // left mouse
offsetTextY as integer = 0

setspriteposition(checkBoxes[1].spriteID,150,75)
setspriteposition(checkBoxes[2].spriteID,150,125)
SetSpritePosition(checkBoxes[3].spriteID,150,175)
SetSpriteVisible(checkBoxes[1].spriteID,1)
SetSpriteVisible(checkBoxes[2].spriteID,1)
SetSpriteVisible(checkBoxes[3].spriteID,1)
setBackGroundColor()

//Load Font to use
iFontId = LoadFont("GREENFUZ.ttf") 

//Text Strings
settingText as string[4] = ["Settings", "Music ON", "Sound ON", "Harder?", "Go Back"]

createtext(10,settingText[0])
SetTextColor(10,0,0,0,255)
setTextSize(10,50)
SetTextPosition(10,10,10)
SetTextFont(10, iFontId)
SetTextVisible(10, 1)



for i = 11 to 14
	CreateText(i, settingText[i-10])
	SetTextColor(i,0,0,0,255)
	SetTextSize(i,30)
	SetTextPosition(i,10,75+offsetTextY)
	SetTextFont(i, iFontId)
	SetTextVisible(i, 1)
	inc offsetTextY, 50
next i

repeat
//do
LMB=MB
MB=getpointerstate()


for i = 1 to numCheckBoxes
	if LMB=0 and MB=1
		hit = GetSpriteHit(GetPointerX(), GetPointerY())
		if hit = checkBoxes[i].spriteID
			checkBoxes[i].state=1-checkBoxes[i].state
			setspriteframe(checkBoxes[i].spriteID,1+checkBoxes[i].state)
			checkSongStatus()
			//setSpriteDifficulty()
		Endif		
	Endif
next i
//print("spriteSize ="+str(spriteSize))
sync()
until GetPointerPressed() = 1 and GetTextHitTest (14, GetPointerX ( ), GetPointerY ( ) )    
//loop
endfunction

function checkSongStatus()

if checkBoxes[1].state = 1 and playing = 0
	playTitleSong()
	playing = 1
elseif checkBoxes[1].state = 0
	stopTitleSong()
	playing = 0
endif
log("I am here-2nd after.. state is:"+str(checkBoxes[0].state)+" playing is:"+str(playing)) 
endfunction

function setSpriteDifficulty()

if checkBoxes[3].state = 1 
	spriteSize = 0
	adjustSpriteSize()
elseif checkBoxes[3].state = 0
	spriteSize = 1
	adjustSpriteSize()
endif

endfunction

function setPlayFlags()
	global checkBoxes as checkBox[numCheckBoxes]
	for i = 1 to numCheckBoxes
		checkBoxes[i].spriteID=createsprite(0)
		for j = 1 to 2
			iTmp = LoadImage("checkbox"+str(j)+".png")
			AddSpriteAnimationFrame(checkBoxes[i].spriteID,iTmp )
		next j

		SetSpriteSize(checkBoxes[i].spriteID, 32, 32)
		setspriteframe(checkBoxes[i].spriteID,2)
		checkBoxes[i].state=1
		SetSpriteVisible(checkBoxes[i].spriteID,0)
		log("this is sprite id"+str(checkBoxes[i].spriteID))
	next i
	set = 1

endfunction

function hideSettingsSprites()
	for i = 1 to numCheckBoxes
		SetSpriteVisible(checkBoxes[i].spriteID,0)
		SetSpritePosition(checkBoxes[i].spriteID, -500, -500)
	next i
endfunction


