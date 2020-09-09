function hallOfFame()

setBackGroundColor()

playerScore as integer
playerName as integer
textScoreOffset = 55


hiScoreText = Createtext ("Hall of Fame")
backText = Createtext ("Click/Tap Screen")


setTextFont(hiScoreText, iFontId)
SetTextSize(hiScoreText,45)
SetTextColor(hiScoreText,0,0,0,255)
SetTextVisible(hiScoreText,1)
SetTextPosition(hiScoreText, S_Width/2, 10)
SetTextAlignment(hiScoreText, 1)

	
for i = 9 to 0 step -1 
		playerScore = CreateText(str(scrArray[i].scoreList))
		playerName = CreateText(scrArray[i].name)
		//print(playerscore)
		//print(playerName)
		
		setTextFont(playerScore, iFontId)
		SetTextSize(playerScore,35)
		SetTextColor(playerScore,0,0,0,255)
		SetTextVisible(playerScore,1)
		setTextFont(playerName, iFontId)
		SetTextSize(playerName,35)
		SetTextColor(playerName,0,0,0,255)
		SetTextVisible(playerName,1)
		SetTextPosition(playerName, 350, textScoreOffset)
		SetTextPosition(playerScore, 75, textScoreOffset)
		
		textScoreOffset = textScoreOffset + 30
next i

setTextFont(backText, iFontId)
SetTextSize(backText,45)
SetTextColor(backText,0,0,0,255)
SetTextVisible(backText,1)
SetTextPosition(backText, S_Width/2, 400)
SetTextAlignment(backText, 1)

repeat
	sync()
until GetPointerPressed() = 1
DeleteAllText()
runGreeting()
endfunction
