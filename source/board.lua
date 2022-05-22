import "CoreLibs/timer"
import 'tile'

local spriteSize = 32
class( 'Board' ).extends(Object)

function drawSprite( xPos, yPos )
	local newTile = Tile( xPos, yPos )

	local x = xPos + (xPos * spriteSize)
	local y = yPos + (yPos * spriteSize)

	newTile:moveTo( x, y )
	newTile:add() -- adds to display list
	
	return newTile
end

function Board:init( width, height )
	Board.super.init(self)
	--[[
		1. make a Matrix of Tiles (see tile.lua)
		2. drawRow needs to assign Tile to Matrix position on init
		3. check board for connected Tiles
	]]--
	self.height = height
	self.width = width
	
	-- setup map matrix
	self.matrix = {}
	
	self:draw()
end

function Board:clear()
	for i = 1, self.width, 1 do
		for j = 1, self.height, 1 do
			self.matrix[i][j]:removeSprite()
		end
	end
end

function Board:compare( tile1, tile2, direction, count )
	local isFirstInRow = count == 0

	if (tile1.value == tile2.value) then
		count += 1
		
		local oneMore = nil

		if ( direction == 'row' and tile2.xCoordinate + 1 <= self.width ) then
			oneMore = self:compare(tile2, self.matrix[tile2.xCoordinate + 1][tile2.yCoordinate], 'row', count)
			
			if (oneMore) then
				count += 1
			end
		elseif ( direction == 'column' and tile2.yCoordinate + 1 <= self.height ) then
			oneMore = self:compare(tile2, self.matrix[tile2.xCoordinate][tile2.yCoordinate + 1], 'column', count)
			
			if (oneMore) then
				count += 1
			end
		end

		if count >= 2 then
			tile1.marked = true
			tile2.marked = true
			
			local deathFrame1 = tile1.spriteTable[tile1.value]:getImage(2)
			local deathFrame2 = tile2.spriteTable[tile2.value]:getImage(2)
			
			local function applyDeathFrame()
				tile1:setImage(deathFrame1)
				tile2:setImage(deathFrame2)
			end
			
			local function clear()
				self:clearMarkedTiles()
			end
			
			-- applyDeathFrame()
			playdate.timer.performAfterDelay(500, applyDeathFrame)
			playdate.timer.performAfterDelay(1000, clear)
		end
		
		return true
	else
		return false
	end
end

function Board:clearMarkedTiles()
	for i = 1, self.width, 1 do
		for j = 1, self.height, 1 do
			local tile = self.matrix[i][j]
			if (tile.marked) then
				tile:removeSprite()

				tile:reset()
				tile:add()
			end
		end
	end
end

function Board:draw()
	for i = 1, self.width, 1 do
		self.matrix[i] = {}
		for j = 1, self.height, 1 do
			self.matrix[i][j] = drawSprite(i, j)
		end
	end
	
	for i = 1, self.width, 1 do
		for j = 1, self.height, 1 do
			local initTile = self.matrix[i][j]
			
			-- i is width, j is height
			if ( ( i + 1 ) < self.width ) then
				self:compare(initTile, self.matrix[i + 1][j], 'row', 0 )
			end
			
			if ( ( j + 1 ) < self.height ) then
				self:compare(initTile, self.matrix[i][j + 1], 'column', 0 )
			end
		end
	end
end

function Board:reDraw()
	self:clear()
	self:draw()
end

function Board:shiftTilesDown()
	for i = 1, self.width, 1 do
		for j = 1, self.height - 1, 1 do -- don't check last row
			local moveDown = self.matrix[i][j + 1]
		end
	end
end
