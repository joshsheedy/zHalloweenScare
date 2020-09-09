global filePath as string
global deviceType as String
global updateScore as integer
global text$

// create score type score,player
type scrType
	scoreList as integer
	name as string
endtype

function setFilePath()
	// Get Environment
	deviceType = GetDeviceBaseName()
		if deviceType = "linux"
			filePath = "raw:/home/josh/.HalloweenScare/hiscore.txt"
		else
			filePath = (GetWritePath()+"hiscore.txt")
		endif
	
	//files$ = "raw:/home/josh/Documents/myfirstgame/hiscore.txt"
	
endfunction 


//create score array
global scrArray as scrType[9]

function readScores()
fileID as integer = 1
setFilePath()

if GetFileExists(filePath)=1
	OpenToRead(fileID, filePath)
	for i = 0 to 9
		scrArray[i].scoreList = ReadInteger(fileID)
		scrArray[i].name = ReadString(fileID)
	next i
	CloseFile(fileID)
else 
	createScores(fileID)
endif
	
endfunction

function writeScores()
fileID as integer = 1
setFilePath()

if GetFileExists(filePath)=1
	OpenToWrite(fileID, filePath)
	for i = 0 to 9
		WriteInteger(fileID, (scrArray[i].scoreList))
		WriteString(fileID, (scrArray[i].name))
	next i
	CloseFile(fileID)
else 
	createScores(fileID)
endif
	
endfunction

function createScores(fileID)
	if GetFileExists(filePath) = 0
		createScoreAry(fileID)
	endif
	
endfunction

//first time scores

function createScoreAry(fileID)
	
	scrArray[0].scoreList = 100 : scrArray[0].name = "Ghost"
	scrArray[1].scoreList = 200 : scrArray[1].name = "Pumpkin"
	scrArray[2].scoreList = 1000 : scrArray[2].name = "Witch"
	scrArray[3].scoreList = 4000 : scrArray[3].name = "Frankie"
	scrArray[4].scoreList = 150 : scrArray[4].name = "Dracula"
	scrArray[5].scoreList = 260 : scrArray[5].name = "Wolfie"
	scrArray[6].scoreList = 1700 : scrArray[6].name = "Bats"
	scrArray[7].scoreList = 4100 : scrArray[7].name = "Mummy"
	scrArray[8].scoreList = 10000 : scrArray[8].name = "Z"
	scrArray[9].scoreList = 2010 : scrArray[9].name = "Morgana"
	scrArray.sort()
	OpenToWrite(fileID, filePath)
		for i = 0 to 9
		WriteInteger(fileID, (scrArray[i].scoreList))
		WriteString(fileID, (scrArray[i].name))
	next i
	CloseFile(fileID)
endfunction 

function checkNewHighScore(score)
	newIndex as integer = 0
	updateScore as integer = 0
	
	for i = 0 to 9
		if score > scrArray[i].scoreList
			newIndex = i
			updateScore = 1
		endif
	next i
		
	if updateScore = 1
		enteredName$ = enterName()
		scrArray[newIndex].scoreList = score : scrArray[newIndex].name = enteredName$
		newIndex = 0
		updateScore = 0
	endif
	
endfunction

//if High score enter name
function enterName()

StartTextInput ("Enter Name" )

// set text string to blank
text$ = ""
do
	
    SetCursorBlinkTime(0.5)
    SetTextInputMaxChars(20)

	sync()
   // once input has finished store the text
    if GetTextInputCompleted() = 1
	sleep(100)
        if GetTextInputCancelled() = 1
			text$ = "No Name"
			sync()
			exit
		else
			 text$ = GetTextInput()
			 sync()
			 exit
		endif      
    endif
	//if val(text$) > 0 then StopTextInput()
loop
	sync()
endfunction text$ 
