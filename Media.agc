//create pumpkin type
type tEnemy
	enemyX as integer
	enemyY as integer
	enemySpriteNum as integer
	enemyIsActive as integer
	enemySpeed as integer
	animateState as integer // 1 = alive 2 = dead
	hideSprite as integer
	intPass as integer
endtype

type tCloud
		cloudX as integer
		cloudY as integer
		cloudSpriteNum as integer
		cloudIsActive as integer
		cloudSpeed as integer	
endType

global backgroundMusic as integer
global ghostSprite as integer
function loadMedia()
//enable background
loadimage(1,"background2.png")

CreateSprite(1,1)
ghostSprite = createsprite(loadimage("ghost.png"))
SetSpriteSize(ghostSprite, 50,50)
SetSpritePosition(ghostSprite, -100, -100)
SetSpriteVisible(ghostSprite, 0)


//setup enemy Arrays
global pumpkin as tEnemy[maxPumpkins]
global witch as tEnemy[maxWitches]
global cat as tEnemy[maxCats]
global bat as tEnemy[maxBats]
global cloud as tCloud[maxClouds]

//load type values into arrays
	for i = 1 to maxPumpkins
		pumpkin[i].enemyX=-10
		pumpkin[i].enemyY=random(200,264)
		pumpkin[i].enemySpeed=random(1,3)
		pumpkin[i].enemyIsActive=0
		pumpkin[i].animateState=1
		pumpkin[i].hideSprite=0
		pumpkin[i].intPass=0
	next i

	for i = 1 to maxWitches
		witch[i].enemyX=-10
		witch[i].enemyY=random(200,264)
		witch[i].enemySpeed=random(1,3)
		witch[i].enemyIsActive=0
		witch[i].animateState=1
		witch[i].hideSprite=0
		witch[i].intPass=0
	next i
	
	for i = 1 to maxCats
		cat[i].enemyX=random(20,600)
		cat[i].enemyY=-20
		cat[i].enemySpeed=random(1,3)
		cat[i].enemyIsActive=0
		cat[i].animateState=1
		cat[i].hideSprite=0
		cat[i].intPass=0
	next i

	for i = 1 to maxBats
		bat[i].enemyX=-100
		bat[i].enemyY=random(200,264)
		bat[i].enemySpeed=random(1,3)
		bat[i].enemyIsActive=0
		bat[i].animateState=1
		bat[i].hideSprite=0
		bat[i].intPass=0
	next i
	
	for i = 1 to maxClouds
		cloud[i].cloudX=700
		cloud[i].cloudY=random(10,264)
		cloud[i].cloudSpeed=random(1,2)
		cloud[i].cloudIsActive=0
	next i	
//enable pumpkin spice

	
	//Load pumpkin Images
	for i = 0 to maxPumpkins	
		//SetSpriteGroup(i,pumpsGroup)
		pumpkin[i].enemySpriteNum = CreateSprite(0)
		SetSpriteSize(pumpkin[i].enemySpriteNum,40,40)
		SetSpritePosition(pumpkin[i].enemySpriteNum,-100,-100)
		for j = 1 to 8
			iTmp = LoadImage("pumpkin0"+str(j)+".png")
			AddSpriteAnimationFrame(pumpkin[i].enemySpriteNum,iTmp )
		next j
	next i
	//Load witches Images
	for i = 0 to maxWitches	
		witch[i].enemySpriteNum = CreateSprite(0)
		SetSpriteSize(witch[i].enemySpriteNum,80,80)
		SetSpritePosition(witch[i].enemySpriteNum,-100,-100)
		for j = 1 to 8
			iTmp = LoadImage("witch0"+str(j)+".png")
			AddSpriteAnimationFrame(witch[i].enemySpriteNum,iTmp )
		next j
	next i
	
		//Load cats Images
	for i = 0 to maxCats	
		cat[i].enemySpriteNum = CreateSprite(0)
		SetSpriteSize(cat[i].enemySpriteNum,40,40)
		SetSpritePosition(cat[i].enemySpriteNum,-100,-100)
		for j = 1 to 8
			iTmp = LoadImage("cats0"+str(j)+".png")
			AddSpriteAnimationFrame(cat[i].enemySpriteNum,iTmp )
		next j
	next i
	
		//Load bats Images
	for i = 0 to maxBats	
		bat[i].enemySpriteNum = CreateSprite(0)
		SetSpriteSize(bat[i].enemySpriteNum,60,60)
		SetSpritePosition(bat[i].enemySpriteNum,-100,-100)
		for j = 1 to 8
			iTmp = LoadImage("bats0"+str(j)+".png")
			AddSpriteAnimationFrame(bat[i].enemySpriteNum,iTmp )
		next j
	next i
	
	//Load Clouds
	for i = 1 to maxClouds
		iTmp = LoadImage("Cloud0"+str(i)+".png")
		cloud[i].cloudSpriteNum = CreateSprite(iTmp)
		SetSpriteColorAlpha(cloud[i].cloudSpriteNum, random(40,200))
		SetSpritePosition(cloud[i].cloudSpriteNum,700,random(10,170))
	next i
endfunction

function activateClouds()
		// shut off cloudy day
	for i=1 to maxClouds
		SetSpriteVisible(cloud[i].cloudSpriteNum,1)
		if cloud[i].cloudIsActive=0
			if random (1,50) = 10
				cloud[i].cloudIsActive=1
			endif
		endif
	next i
endfunction

function checkForCloudActive()
	//cfork it
	for i = 1 to maxClouds
		if cloud[i].cloudIsActive = 1
			cloud[i].cloudX=cloud[i].cloudX-cloud[i].cloudSpeed
			//off right of screen?
			if cloud[i].cloudX<-128 
				cloud[i].cloudX = 700
				cloud[i].cloudY = random(10,170)
			endif
			SetSpritePosition (cloud[i].cloudSpriteNum,cloud[i].cloudX,cloud[i].cloudY)
		endif
	next i	
endfunction

function deactivateClouds()
		//Shut it down
	for i=1 to maxClouds
		cloud[i].cloudIsActive=0
		SetSpriteVisible(cloud[i].cloudSpriteNum,0)
	next i
endfunction

function deactivateGhost()
		//Shut it down
		SetSpriteVisible(ghostSprite,0)
endfunction

// ****************************************************
// sprite animations sections,  so redundant 
function play_pumpkins(spriteNumber)
	// PlaySprite( iSpriteIndex, fFps, iLoop, iFromFrame, iToFrame )
	if pumpkin[spriteNumber].animateState = 1
		if GetSpritePlaying(pumpkin[spriteNumber].enemySpriteNum) =1 and  GetSpriteCurrentFrame(pumpkin[spriteNumber].enemySpriteNum) < 1
			stopSprite(pumpkin[spriteNumber].enemySpriteNum) 
			SetSpriteFrame(pumpkin[spriteNumber].enemySpriteNum, 1)
			PlaySprite(pumpkin[spriteNumber].enemySpriteNum,6,1,1,4)
		else
			SetSpriteFrame(pumpkin[spriteNumber].enemySpriteNum, 1)
			PlaySprite(pumpkin[spriteNumber].enemySpriteNum,6,1,1,4)
		endif
	elseif pumpkin[spriteNumber].animateState = 2
		if GetSpriteCurrentFrame(pumpkin[spriteNumber].enemySpriteNum) < 5 
			SetSpriteFrame(pumpkin[spriteNumber].enemySpriteNum, 5)
			PlaySprite(pumpkin[spriteNumber].enemySpriteNum,16,0,5,8)
			pumpkin[spriteNumber].intPass=1
			//log("I am at the playSprite section 3rd if")	
		endif
	endif

endfunction

function play_witches(spriteNumber)
	// PlaySprite( iSpriteIndex, fFps, iLoop, iFromFrame, iToFrame )
	if witch[spriteNumber].animateState = 1
		if GetSpritePlaying(witch[spriteNumber].enemySpriteNum) =1 and  GetSpriteCurrentFrame(witch[spriteNumber].enemySpriteNum) < 1
			stopSprite(witch[spriteNumber].enemySpriteNum) 
			SetSpriteFrame(witch[spriteNumber].enemySpriteNum, 1)
			PlaySprite(witch[spriteNumber].enemySpriteNum,6,1,1,4)
			//sync()
			log("I am at the playSprite section first if")
		else
			SetSpriteFrame(witch[spriteNumber].enemySpriteNum, 1)
			PlaySprite(witch[spriteNumber].enemySpriteNum,6,1,1,4)		
			//log("I am at the playSprite section second if")
		endif
	elseif witch[spriteNumber].animateState = 2
		if GetSpriteCurrentFrame(witch[spriteNumber].enemySpriteNum) < 5 
			SetSpriteFrame(witch[spriteNumber].enemySpriteNum, 5)
			PlaySprite(witch[spriteNumber].enemySpriteNum,16,0,5,8)
			witch[spriteNumber].intPass=1
//			log("I am at the playSprite section 3rd if")	
		endif
	endif
endfunction

function play_cats(spriteNumber)
	// PlaySprite( iSpriteIndex, fFps, iLoop, iFromFrame, iToFrame )
	if cat[spriteNumber].animateState = 1
		if GetSpritePlaying(cat[spriteNumber].enemySpriteNum) =1 and  GetSpriteCurrentFrame(cat[spriteNumber].enemySpriteNum) < 1
			stopSprite(cat[spriteNumber].enemySpriteNum) 
			SetSpriteFrame(cat[spriteNumber].enemySpriteNum, 1)
			PlaySprite(cat[spriteNumber].enemySpriteNum,6,1,1,4)
			//sync()
		else
			SetSpriteFrame(cat[spriteNumber].enemySpriteNum, 1)
			PlaySprite(cat[spriteNumber].enemySpriteNum,6,1,1,4)
		endif
	elseif cat[spriteNumber].animateState = 2
		if GetSpriteCurrentFrame(cat[spriteNumber].enemySpriteNum) < 5 
			SetSpriteFrame(cat[spriteNumber].enemySpriteNum, 5)
			PlaySprite(cat[spriteNumber].enemySpriteNum,16,0,5,8)
			cat[spriteNumber].intPass=1
			//log("I am at the playSprite section 3rd if")	
		endif
	endif

endfunction

function play_bats(spriteNumber)
	// PlaySprite( iSpriteIndex, fFps, iLoop, iFromFrame, iToFrame )
	if bat[spriteNumber].animateState = 1
		if GetSpritePlaying(bat[spriteNumber].enemySpriteNum) =1 and  GetSpriteCurrentFrame(bat[spriteNumber].enemySpriteNum) < 1
			stopSprite(bat[spriteNumber].enemySpriteNum) 
			SetSpriteFrame(bat[spriteNumber].enemySpriteNum, 1)
			PlaySprite(bat[spriteNumber].enemySpriteNum,6,1,1,4)
		else
			SetSpriteFrame(bat[spriteNumber].enemySpriteNum, 1)
			PlaySprite(bat[spriteNumber].enemySpriteNum,6,1,1,4)
		endif
	elseif bat[spriteNumber].animateState = 2
		if GetSpriteCurrentFrame(bat[spriteNumber].enemySpriteNum) < 5 
			SetSpriteFrame(bat[spriteNumber].enemySpriteNum, 5)
			PlaySprite(bat[spriteNumber].enemySpriteNum,16,0,5,8)
			bat[spriteNumber].intPass=1
			//log("I am at the playSprite section 3rd if")	
		endif
	endif

endfunction

function reset_pumpkins()

	for i = 0 to maxPumpkins
		pumpkin[i].enemyX=-100
		pumpkin[i].enemyY=random(100,364)
		pumpkin[i].enemySpeed=random(1,3)
		pumpkin[i].enemyIsActive=0
		SetSpritePosition(pumpkin[i].enemySpriteNum,pumpkin[i].enemyX,pumpkin[i].enemyY)
	next i
endfunction

function reset_witches()

	for i = 0 to maxWitches
		witch[i].enemyX=-100
		witch[i].enemyY=random(100,364)
		witch[i].enemySpeed=random(3,5)
		witch[i].enemyIsActive=0
		SetSpritePosition(witch[i].enemySpriteNum,witch[i].enemyX,witch[i].enemyY)
	next i
endfunction

function reset_cats()

	for i = 0 to maxCats
		cat[i].enemyX=random(20,600)
		cat[i].enemyY=-100
		cat[i].enemySpeed=random(1,3)
		cat[i].enemyIsActive=0
		SetSpritePosition(cat[i].enemySpriteNum,cat[i].enemyX,cat[i].enemyY)
	next i
endfunction

function reset_bats()

	for i = 0 to maxBats
		bat[i].enemyX=-100
		bat[i].enemyY=random(100,364)
		bat[i].enemySpeed=random(1,3)
		bat[i].enemyIsActive=0
		SetSpritePosition(bat[i].enemySpriteNum,bat[i].enemyX,bat[i].enemyY)
	next i
endfunction

function reset_clouds()

	for i = 0 to maxClouds
		cloud[i].cloudX=700
		cloud[i].cloudY=random(100,170)
		cloud[i].cloudSpeed=random(1,3)
		cloud[i].cloudIsActive=0
		SetSpritePosition(bat[i].enemySpriteNum,bat[i].enemyX,bat[i].enemyY)
	next i
endfunction

function playTitleSong()
	
//load music
	backgroundMusic = LoadMusicOGG("backgroundmusic.ogg")
	playMusicOGG(backgroundMusic)
	playing = 1
endfunction

function stopTitleSong()
	StopMusicOGG(backgroundMusic)
	playing = 0
endfunction

function playSquishSound()
	if GetSoundExists(soundEffect) = 0 then soundEffect = LoadSound("pumpkinsquish.wav")
		if 	checkBoxes[2].state = 1
			Playsound(soundEffect)
		endif
endfunction

function playPlopSound()
	if GetSoundExists(soundEffect2) = 0 then soundEffect2 = LoadSound("plop.wav")
		if 	checkBoxes[2].state = 1
			Playsound(soundEffect2)
		endif
endfunction

function adjustSpriteSize()

if spriteSize = 0
	for i = 0 to maxPumpkins	
		SetSpriteSize(pumpkin[i].enemySpriteNum,40,40)
	next i
		for i = 0 to maxWitches	
		SetSpriteSize(witch[i].enemySpriteNum,80,80)
	next i
		for i = 0 to maxCats	
		SetSpriteSize(cat[i].enemySpriteNum,40,40)
	next i
		for i = 0 to maxBats	
		SetSpriteSize(bat[i].enemySpriteNum,60,60)
	next i
else
	for i = 0 to maxPumpkins	
		SetSpriteSize(pumpkin[i].enemySpriteNum,60,60)
	next i
		for i = 0 to maxWitches	
		SetSpriteSize(witch[i].enemySpriteNum,100,100)
	next i
		for i = 0 to maxCats	
		SetSpriteSize(cat[i].enemySpriteNum,60,60)
	next i
		for i = 0 to maxBats	
		SetSpriteSize(bat[i].enemySpriteNum,80,80)
	next i
endif	
log("I got here")	
endfunction	
