import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import 'board'

-- shorthand alias
local gfx <const> = playdate.graphics

local playerSprite = nil
local playerSpeed = 4
local gameBoard = Board( 8, 6 ) -- width / height passed

local function initialize()
	local backgroundImage = gfx.image.new("images/background")
	assert( backgroundImage )
	
	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			gfx.setClipRect( x, y, width, height )
			backgroundImage:draw( 0, 0 )
			gfx.clearClipRect()
		end
	)
end

initialize()

function playdate.update() -- update loop
	if playdate.buttonJustPressed(playdate.kButtonA) then
		gameBoard:clear()
		gameBoard:draw()
	end

	gfx.sprite.update() -- updates everything in draw stack every loop
	playdate.timer.updateTimers()
end