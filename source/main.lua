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
	assert( backgroundImage ) -- make sure the image was where we thought
	
	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			gfx.setClipRect( x, y, width, height ) -- let's only draw the part of the screen that's dirty
			backgroundImage:draw( 0, 0 ) -- draw on top left
			--[[
				we can draw only 'dirty' rectangles, bounding boxes of all graphically redrawn sprites.
				
				what are passed as the variables here, are the bounding boxes
			]]--
			gfx.clearClipRect() -- clear so we don't interfere with drawing that comes after this
		end
	)
end

initialize()

function playdate.update() -- update loop
	if playdate.buttonJustPressed(playdate.kButtonA) then
		gameBoard:reDraw()
	end

	gfx.sprite.update() -- updates everything in draw stack every loop
	playdate.timer.updateTimers()
end