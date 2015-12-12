-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

-- Start the Physics engine
local physics = require("physics")
physics.start()

-- Calculate half the screen width and height
halfW = display.contentWidth * 0.5
halfH = display.contentHeight * 0.5

-- Set the background
local bkg = display.newImage("game_assets/game_bg.png", halfW, halfH)

-- Score field
score = 0
scoreText = display.newText(score, halfW, 10)

-- Called when the balloon is tapped by the Player
-- Score is increased by 1
local function balloonTouched(event)
	if(event.phase == "began") then
		Runtime:removeEventListener("enterFrame", event.self)
		event.target:removeSelf()
		score = score + 1
		scoreText.text = score
	end
end

-- Called when the bomb is tapped by the player
-- Half the score is deducted as a penalty
local function bombTouched(event)
	if(event.phase == "began") then
		Runtime:removeEventListener("enterFrame", event.self)
		event.target:removeSelf()
		score = math.floor(score * 0.5)
		scoreText.text = score
	end
end

-- Delete objects which has fallen off the bottom of the screen
local function offScreen(self, event)
	if(self.y == nil) then
		return
	end
	if(self.y > display.contentHeight + 50) then
		Runtime:removeEventListener("enterFrame", self)
		self:removeSelf()
	end
end

-- Add a new falling balloon or bomb
local function addNewBalloonOrBomb()
	local startX = math.random(display.contentWidth*0.1, display.contentWidth*0.9)
	if(math.random (1,5) == 1) then
		
		-- BOMB!
		local bomb = display.newImage("game_assets/bomb.png", startX, -300)
		physics.addBody(bomb)
		bomb.enterFrame = offScreen
		Runtime:addEventListener("enterFrame", bomb)
		bomb:addEventListener("touch", bombTouched)
	else

		-- BALLOON!
		local balloon = display.newImage("game_assets/red_balloon.png", startX, -300)
		physics.addBody(balloon)
		balloon.enterFrame = offScreen
		Runtime:addEventListener("enterFrame", balloon)
		balloon:addEventListener("touch", balloonTouched)
	end
end

-- Add a new balloon or bomb now
addNewBalloonOrBomb()

-- Keep adding a new balloon or bomb every 0.5 seconds
timer.performWithDelay(500, addNewBalloonOrBomb, 0)


