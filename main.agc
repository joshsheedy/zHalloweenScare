
// Project: Zaria's Halloween Scare 
// Created: 2019-08-23

//load include
#include "Media.agc"
#include "greeting.agc"
#include "screenvalues.agc"
#include "settings.agc"
#include "files.agc"
#include "fame.agc"

//constants
#constant maxPumpkins = 4
#constant maxWitches = 5
#constant maxCats = 5
#constant maxBats = 6
#constant maxClouds = 3
#constant numCheckBoxes = 3

//global vars
global score as integer = 0
global hiScore as integer = 0
global level as integer 
global speedup as integer = 1
global squishedPumpkin as integer = 0
global squishedWitch as integer = 0
global squishedCat as integer = 0
global gameover as integer = 1
global pumpsGroup as integer = 1 //temp for debugging
global levelScore as integer
global witchScore as integer = 20
global batScore as integer = 30
global catScore as integer = 40
global frankScore as integer = 250 
global lives as integer = 3 // number of lives
global iFontId as integer
global hitsprite as integer
global inLevel = 0
global pass as integer
global upspeed as integer = 0
global soundEffect as integer
global gameOverButtonsCreated as integer = 0
global mainButton as integer = 4
global yesButton as integer = 5
global noButton as integer = 6
global playing as integer
global set as integer = 0
global spriteSize as integer = 0
global ghostActive as integer = 0
global ghostTimer as float
global minusAlpha as integer = 200


//setup screen from screenvalues 
setScreen()
if set = 0 then setPlayFlags()

//load high scores from file
readScores()
//loadMedia()
playTitleSong()
runGreeting()

mainSection:
loadMedia()
setSpriteDifficulty()

iFontId = LoadFont("GREENFUZ.ttf") 
hiScore = setHiScore()

do
	startGame()
	checkForCloudActive()
	runLevel(level)
	//print("the sound effect number is:"+str(soundEffect))
	
	if GetPointerPressed()=1 and inLevel > 0
		hitsprite=GetSpriteHit(GetPointerX(),GetPointerY())
		log("Id of sprite: "+str(hitsprite))
		//Print("ID of Sprite is "+Str(hitsprite)+"pointer x"+str(GetpointerX()))
	endif
		
	if level = 1
		checkForPumkinHit()
	elseif level = 2
		checkForWitchHit()
	elseif level = 3
		checkForCatHit()
	elseif level = 4
		checkForBatHit()		
	endif	
	
	//hit host
	checkForGhostHit()
	
	if (inLevel > 0 and ghostActive = 1) or random(1,750) = 10
		setGhost()
	endif
	
	SetPrintSize(26)
	print("Score: "+str(score)+"    HighScore: "+str(HiScore)+"    Lives: "+str(lives))	
	//print("in Level Value?"+str(inLevel))	
	if score > hiScore
		hiScore = score
	endif

	//Have I hit a range to up the level?
	if pass > 0 then checkLevelScore(levelScore)

    Sync()

loop

return
end 
Function gameOverModal()
	textOffset as float = 40
	selection as integer = 0
	gameOverText = Createtext("Game Over")
	playAgain = Createtext("Play again, Yes, No, Main Menu")
	settextfont(gameovertext, iFontId)
	SetTextSize(gameovertext, 32)
	SetTextAlignment(gameovertext, 1)
	SetTextPosition(gameovertext, 320, 100)
	settextfont(playAgain, iFontId)
	SetTextSize(playAgain, 32)
	SetTextAlignment(playAgain, 1)
	SetTextPosition(playAgain, 320, 100+textOffset)
	setGameOverButtons()
	
					//DrawLine(320,0,320,480,0,0,255)  	
	//sync()
	
	// write new scores
	writeScores()
	
	repeat 
		if GetVirtualButtonPressed(yesButton)
			selection = 1
		elseif GetVirtualButtonPressed(noButton)
			selection = 2
		elseif GetVirtualButtonPressed(mainButton)
			selection = 3
		else
			selection = 0
		endif
		
		select selection
			case 1
				SetTextVisible(gameovertext,0):setTextvisible(playagain,0)
				moveGameOverButtons()
				level = 1
				lives = 3
				levelScore = 0
				reset_clouds()
			endcase
			case 2 
				 end
			endcase
			case 3
				moveGameOverButtons()
				deactivateAllSprites()
				//reset_pumpkins()
				SetSpriteVisible(1,0)
				SetTextVisible(gameovertext,0):setTextvisible(playagain,0)
				levelScore = 0
				runGreeting()
			endcase
			
		endselect		
		sync()

	until selection > 0 
endfunction

function showText()
	gameOverText = Createtext("Game Over")
	playAgain = Createtext("Play again, Y - Yes, N - No, M - Main Menu")

	SetTextVisible(gameovertext,1):setTextvisible(playagain,1)
endfunction

function sethiscore()
		hiScore = scrArray[9].scoreList
	
endfunction hiScore

function showNextLevel()
	inLevel = 0
	textOffset as float = 60
	continueNextLevel = 0
	
	levelCompletedText = Createtext("Level Complete")
	nextLevelText = Createtext("Prepare for level "+str(level))
	clickForNextLevel = Createtext("Tap for Next Level")
	setTextFont(levelCompletedText, iFontId)
	setTextFont(nextLevelText, iFontId)
	setTextFont(clickForNextLevel, iFontId)
	SetTextSize(levelCompletedText,40)
	SetTextSize(nextLevelText,40)
	SetTextSize(clickForNextLevel,40)
	SetTextColor(levelCompletedText,0,0,0,255)
	SetTextColor(nextLevelText,0,0,0,255)
	SetTextColor(clickForNextLevel,0,0,0,255)
	SetTextAlignment(levelCompletedText, 1)
	SetTextPosition(levelCompletedText, 320, 200)
	SetTextAlignment(nextLevelText, 1)
	SetTextPosition(nextLevelText, 320, 200+textOffset)
	SetTextAlignment(clickForNextLevel, 1)
	SetTextPosition(clickForNextLevel, 320, 200+textOffset/2)
	sleep(500)
	SetTextVisible(levelCompletedText,1):setTextvisible(nextLevelText,1):setTextvisible(clickForNextLevel,1)
	deactivateAllSprites()
	Repeat
		print("")
		if GetPointerPressed() = 1 then print("pointer pressed")
		Sync()
	Until GetPointerPressed() = 1
		sleep(200)
		if GetPointerPressed() = 1
			DeleteText(levelCompletedText):DeleteText(nextLevelText):DeleteText(clickForNextLevel)
			//SetTextVisible(levelCompletedText,0):setTextvisible(nextLevelText,0):setTextvisible(clickForNextLevel,0)
			sync()
			exitfunction
		endif

endfunction

function activatePumpkins()

		//put pumpkin on screen
	for i=1 to maxPumpkins
		SetSpriteVisible(pumpkin[i].enemySpriteNum,1)
		if pumpkin[i].enemyIsActive=0
			if random (1,50) = 10
				pumpkin[i].enemyIsActive=1
				pumpkin[i].animateState=1
				//spriteNum = pumpkin[i].enemySpriteNum
				//play_sprites(pumpkin, i)
				play_pumpkins(i)
			endif
		endif
	next i
endfunction

function activateWitches()
		//put witch
	for i=1 to maxWitches
		SetSpriteVisible(witch[i].enemySpriteNum,1)
		if witch[i].enemyIsActive=0
			if random (1,50) = 10
				witch[i].enemyIsActive=1
				witch[i].animateState=1
				play_witches(i)
			endif
		endif
	next i
endfunction

function activateCats()
		//put witch
	for i=1 to maxCats
		SetSpriteVisible(cat[i].enemySpriteNum,1)
		if cat[i].enemyIsActive=0
			if random (1,50) = 10
				cat[i].enemyIsActive=1
				cat[i].animateState=1
				play_cats(i)
			endif
		endif
	next i
endfunction

function activatebats()
		//put witch
	for i=1 to maxbats
		SetSpriteVisible(bat[i].enemySpriteNum,1)
		if bat[i].enemyIsActive=0
			if random (1,50) = 10
				bat[i].enemyIsActive=1
				bat[i].animateState=1
				play_bats(i)
			endif
		endif
	next i
endfunction

function deactivatePumpkins()
		//put pumpkin on screen
	for i=1 to maxPumpkins
		pumpkin[i].enemyIsActive=0
		SetSpriteVisible(pumpkin[i].enemySpriteNum,0)
	next i
endfunction

function deactivateWitches()
		//Shut down witches
	for i=1 to maxWitches
		witch[i].enemyIsActive=0
		SetSpriteVisible(witch[i].enemySpriteNum,0)
	next i
endfunction

function deactivateCats()
		//Shut down witches
	for i=1 to maxCats
		cat[i].enemyIsActive=0
		SetSpriteVisible(cat[i].enemySpriteNum,0)
	next i
endfunction

function deactivatebats()
		//Shut down witches
	for i=1 to maxbats
		bat[i].enemyIsActive=0
		SetSpriteVisible(bat[i].enemySpriteNum,0)
	next i
endfunction

function checkForPumpkinActive()
	//check to see if pumpkin is there
	for i = 1 to maxPumpkins
		if pumpkin[i].enemyIsActive
			pumpkin[i].enemyX=pumpkin[i].enemyX+pumpkin[i].enemySpeed
			//off right of screen?
			if pumpkin[i].enemyX>650 and lives < 2
				gameover=1  //missed pumpkin reset game
				squishedPumpkin=0 : speedup=1 : inLevel = 0
				deactivateAllSprites()
				checkNewHighScore(score)
				gameOverModal()
			elseif pumpkin[i].enemyX>650 and lives > 0
				reset_pumpkins()
				dec lives
			endif
			SetSpritePosition (pumpkin[i].enemySpriteNum,pumpkin[i].enemyX,pumpkin[i].enemyY)
		endif
	next i	
endfunction

function checkForWitchActive()
	//check to see if pumpkin is there
	for i = 1 to MaxWitches
		if witch[i].enemyIsActive
			witch[i].enemyX=witch[i].enemyX+witch[i].enemySpeed
			if witch[i].enemyY < 264
				witch[i].enemyY=witch[i].enemyY+1
			else
				witch[i].enemyY=witch[i].enemyY-1
			endif
			//off right of screen?
			if witch[i].enemyX>650 and lives < 2
				gameover=1  //missed witch reset game
				squishedWitch=0 : speedup=1 :inLevel = 0
				inLevel = 0
				deactivateAllSprites()
				checkNewHighScore(score)
				gameOverModal()
			elseif witch[i].enemyX>650 and lives > 0
				reset_witches()
				dec lives
			endif
			SetSpritePosition (witch[i].enemySpriteNum,witch[i].enemyX,witch[i].enemyY)
		endif
	next i	
endfunction

function checkForCatActive()
	//check to see if cat is there
	for i = 1 to MaxCats
		if cat[i].enemyIsActive
			cat[i].enemyY=cat[i].enemyY+cat[i].enemySpeed
			//off right of screen?
			if cat[i].enemyY>500 and lives < 2
				gameover=1  //missed witch reset game
				squishedCat=0 : speedup=1 :inLevel = 0
				inLevel = 0
				deactivateAllSprites()
				checkNewHighScore(score)
				gameOverModal()
			elseif cat[i].enemyY>500 and lives > 0
				reset_cats()
				dec lives
			endif
			SetSpritePosition (cat[i].enemySpriteNum,cat[i].enemyX,cat[i].enemyY)
		endif
	next i	
endfunction

function checkForbatActive()
	//check to see if bat is there
	for i = 1 to Maxbats
		if bat[i].enemyIsActive
			bat[i].enemyX=bat[i].enemyX+bat[i].enemySpeed
			//off right of screen?
			if bat[i].enemyX>650 and lives < 2
				gameover=1  //missed witch reset game
				squishedbat=0 : speedup=1 :inLevel = 0
				inLevel = 0
				deactivateAllSprites()
				checkNewHighScore(score)
				gameOverModal()
			elseif bat[i].enemyX>650 and lives > 0
				reset_bats()
				dec lives
			endif
			SetSpritePosition (bat[i].enemySpriteNum,bat[i].enemyX,bat[i].enemyY)
		endif
	next i	
endfunction

function checkForPumkinHit()
	
	//Did player hit the pumpkin?
	for i=1 to maxPumpkins
		if pumpkin[i].enemySpriteNum=hitsprite and pumpkin[i].animateState = 1
			pumpkin[i].animateState = 2
			hitsprite = 0
		endif
			
		if pumpkin[i].animateState = 2 and pumpkin[i].intPass = 0
			//play_sprites(pumpkin, i)
			play_pumpkins(i)
			playSquishSound()
			inc score, 10
			inc levelScore
			inc squishedPumpkin
		endif

		if GetSpriteCurrentFrame(pumpkin[i].enemySpriteNum) = 8 
			pumpkin[i].hideSprite = 1
		endif
		
		if levelScore = 20 then pass = 1
			
		//speed up pumpkins?
		if squishedPumpkin = 5
			inc speedup
			squishedPumpkin=0
		endif
		
		if GetSpriteCurrentFrame(pumpkin[i].enemySpriteNum) > 4 and pumpkin[i].animateState = 2
			log("pumpkin "+str(i)+" current frame:" + str(GetSpriteCurrentFrame(pumpkin[i].enemySpriteNum)))
			log("pumpkin intPass:"+str(pumpkin[i].intPass))
		endif
		
		if  pumpkin[i].hideSprite = 1							
			pumpkin[i].enemyIsActive=0
			pumpkin[i].enemyX=-100
			pumpkin[i].enemyY=Random(100,364)
			pumpkin[i].enemySpeed=Random(1+speedup,5+speedup)
			SetSpriteVisible(pumpkin[i].enemySpriteNum,0)
			SetSpritePosition(pumpkin[i].enemySpriteNum,pumpkin[i].enemyX,pumpkin[i].enemyY)
			pumpkin[i].hideSprite=0
			pumpkin[i].intPass = 0
			pumpkin[i].animateState=1
		endif
	
	next i		
endfunction

function checkForWitchHit()
	//Did player hit the pumpkin?
	for i=1 to maxWitches
		if witch[i].enemySpriteNum=hitsprite and witch[i].animateState = 1
			witch[i].animateState = 2
			hitsprite = 0
		endif
			
		if witch[i].animateState = 2 and witch[i].intPass = 0
			//play_sprites(witch, i)
			play_witches(i)
			playSquishSound()
			inc score, 20
			inc levelScore
			inc squishedwitch
		endif

		if GetSpriteCurrentFrame(witch[i].enemySpriteNum) = 8 
			witch[i].hideSprite = 1
		endif
		
		if levelScore = 40 then pass = 1
			
		//speed up witchs?
		if squishedwitch = 5
			inc speedup
			squishedwitch=0
		endif
		
		if GetSpriteCurrentFrame(witch[i].enemySpriteNum) > 4 and witch[i].animateState = 2
			log("witch "+str(i)+" current frame:" + str(GetSpriteCurrentFrame(witch[i].enemySpriteNum)))
			log("witch intPass:"+str(witch[i].intPass))
		endif
		
		if  witch[i].hideSprite = 1							
			witch[i].enemyIsActive=0
			witch[i].enemyX=-100
			witch[i].enemyY=Random(100,364)
			witch[i].enemySpeed=Random(1+speedup,5+speedup)
			SetSpriteVisible(witch[i].enemySpriteNum,0)
			SetSpritePosition(witch[i].enemySpriteNum,witch[i].enemyX,witch[i].enemyY)
			witch[i].hideSprite=0
			witch[i].intPass = 0
			witch[i].animateState=1
		endif
	next i	
	
endfunction

function checkForCatHit()
	//Did player hit the pumpkin?
	for i=1 to maxCats
		if cat[i].enemySpriteNum=hitsprite and cat[i].animateState = 1
			cat[i].animateState = 2
			hitsprite = 0
		endif
			
		if cat[i].animateState = 2 and cat[i].intPass = 0
			//play_sprites(cat, i)
			play_cats(i)
			playSquishSound()
			inc score, 50
			inc levelScore
			inc squishedCat
		endif

		if GetSpriteCurrentFrame(cat[i].enemySpriteNum) = 8 
			cat[i].hideSprite = 1
		endif
		
		if levelScore = 60 then pass = 1
			
		//speed up cats?
		if squishedcat = 5
			inc speedup
			squishedcat=0
		endif
		
		if GetSpriteCurrentFrame(cat[i].enemySpriteNum) > 4 and cat[i].animateState = 2
			log("cat "+str(i)+" current frame:" + str(GetSpriteCurrentFrame(cat[i].enemySpriteNum)))
			log("cat intPass:"+str(cat[i].intPass))
		endif
		
		if  cat[i].hideSprite = 1							
			cat[i].enemyIsActive=0
			cat[i].enemyX=Random(10,630)
			cat[i].enemyY=-100
			cat[i].enemySpeed=Random(1+speedup,5+speedup)
			SetSpriteVisible(cat[i].enemySpriteNum,0)
			SetSpritePosition(cat[i].enemySpriteNum,cat[i].enemyX,cat[i].enemyY)
			cat[i].hideSprite=0
			cat[i].intPass = 0
			cat[i].animateState=1
		endif
	next i	
	
endfunction

function checkForBatHit()
	//Did player hit the pumpkin?
	for i=1 to maxBats
		if bat[i].enemySpriteNum=hitsprite and bat[i].animateState = 1
			bat[i].animateState = 2
			hitsprite = 0
		endif
			
		if bat[i].animateState = 2 and bat[i].intPass = 0
			//play_sprites(bat, i)
			play_bats(i)
			playSquishSound()
			inc score, 100
			inc levelScore
			inc squishedbat
		endif

		if GetSpriteCurrentFrame(bat[i].enemySpriteNum) = 8 
			bat[i].hideSprite = 1
		endif
		
		if levelScore = 80 then pass = 1
			
		//speed up bats?
		if squishedbat = 5
			inc speedup
			squishedbat=0
		endif
		
		if GetSpriteCurrentFrame(bat[i].enemySpriteNum) > 4 and bat[i].animateState = 2
			log("bat "+str(i)+" current frame:" + str(GetSpriteCurrentFrame(bat[i].enemySpriteNum)))
			log("bat intPass:"+str(bat[i].intPass))
		endif
		
		if  bat[i].hideSprite = 1							
			bat[i].enemyIsActive=0
			bat[i].enemyX=-100
			bat[i].enemyY=Random(100,364)
			bat[i].enemySpeed=Random(1+speedup,5+speedup)
			SetSpriteVisible(bat[i].enemySpriteNum,0)
			SetSpritePosition(bat[i].enemySpriteNum,bat[i].enemyX,bat[i].enemyY)
			bat[i].hideSprite=0
			bat[i].intPass = 0
			bat[i].animateState=1
		endif
	next i		
	
endfunction

function checkForGhostHit()
	//Did player hit the ghost

		if ghostSprite=hitsprite
			playPlopSound()
			inc score, 250
			SetSpriteVisible(ghostSprite,0)
			SetSpritePosition(ghostSprite, -100, -100)
			hitsprite = 0
		endif	
	
endfunction

function startGame()

	//start game
	if gameover=1 and inLevel = 0
		gameover=0 : score=0

		//check for current level
		if level = 1
			deactivateWitches()
			deactivatebats()
			deactivateCats()
			reset_pumpkins()

		elseif level = 2
			deactivatePumpkins()
			deactivateCats()
			deactivatebats()
			reset_witches()
		
		elseif level = 3
			deactivatePumpkins()
			deactivateWitches()
			deactivatebats()
			reset_cats()
			
		elseif level = 4
			deactivatePumpkins()
			deactivateWitches()
			deactivateCats()
			reset_bats()
		endif
	endif

endfunction

function runLevel(gameLevel)

	select gameLevel
		
		case 1
			inLevel = 1
			activateClouds()
			activatePumpkins()	
			checkForPumpkinActive()
		endcase
		
		case 2
			inLevel = 1
			activateWitches()
			checkForWitchActive()
		endcase
		
		case 3
			inLevel = 1
			activateCats()
			checkForCatActive()
		endcase
		
		case 4 
			inLevel = 1
			activateBats()
			checkForBatActive()
		endcase
		
		case 5
			level=1
			end
		endcase
		
	endselect 

endfunction

function checkLevelScore(llevelScore)
		
		select llevelScore
			case 20
				level = 2
				pass = 0
				deactivatePumpkins()
				inLevel = 0
				showNextLevel()				
			endcase
			case 40
				level = 3
				pass = 0
				deactivateWitches()
				inLevel = 0
				showNextLevel()
			endcase
			case 60
				level = 4
				pass = 0
				deactivateCats()
				inLevel = 0
				showNextLevel()
			endcase
			case 80
				Print("hit screen or button to quit game")
				if GetPointerPressed() = 1 then end
			endcase
		endselect
		
endfunction

function deactivateAllSprites()
	deactivatePumpkins()
	deactivateWitches()
	deactivateCats()
	deactivateBats()
	deactivateClouds()
	deactivateGhost()	
endfunction

function setGameOverButtons()
	if gameOverButtonsCreated = 0
		AddVirtualButton(yesButton,70,70,80)
		SetVirtualButtonColor(yesButton, 205, 93, 25)
		SetVirtualButtonText(yesButton, "Yes")
		SetVirtualButtonPosition(yesButton, 220,400)
 
		AddVirtualButton(noButton,70,70,80)
		SetVirtualButtonColor(noButton, 205, 93, 25)
		SetVirtualButtonText(noButton, "No")
		SetVirtualButtonPosition(noButton, 320,400)
 
		AddVirtualButton(mainButton,70,70,80)
		SetVirtualButtonColor(mainButton, 205, 93, 25)
		SetVirtualButtonText(mainButton, "Main")
		SetVirtualButtonPosition(mainButton, 420,400)
	
		gameOverButtonsCreated = 1
	else
		SetVirtualButtonPosition(yesButton, 220,400)
		SetVirtualButtonPosition(noButton, 320,400)
		SetVirtualButtonPosition(mainButton, 420,400)
		SetVirtualButtonVisible(yesButton,1)
		SetVirtualButtonVisible(noButton,1)
		SetVirtualButtonVisible(mainButton,1)
	endif 

endfunction	

function moveGameOverButtons()
		SetVirtualButtonVisible(yesButton,1)
		SetVirtualButtonVisible(noButton,1)
		SetVirtualButtonVisible(mainButton,1)
		SetVirtualButtonPosition(yesButton, -100,400)
		SetVirtualButtonPosition(noButton, -100,400)
		SetVirtualButtonPosition(mainButton, -100,400)
endfunction	

function setGhost()
	if ghostActive = 0
		ResetTimer()
		ghostTimer = GetSeconds() 
		SetSpriteColorAlpha(ghostSprite, minusAlpha)
		SetSpritePosition(ghostSprite, random(40,600), random(300,400))
		SetSpriteVisible(ghostSprite,1)
		ghostActive = 1
	else 
		if ghostTimer < 4
			dec minusAlpha, 5
			if minusAlpha < 0 then minusAlpha = 0 
			SetSpriteColorAlpha(ghostSprite, minusAlpha)
			ghostTimer = GetSeconds()
		else
			SetSpritePosition(ghostSprite, -100, -100)
			minusAlpha = 200
			ghostActive = 0
		endif
	endif
			
endfunction
