import "CoreLibs/timer"
import 'tile'

local spriteSize = 32
class( 'Board' ).extends(Object)

function Board:init( width, height )
	Board.super.init(self)
	--[[
		1. make a Matrix of Tiles (see tile.lua)
		2. drawRow needs to assign Tile to Matrix position on init
		3. check board for connected Tiles
	]]--
	self.height = height
	self.width = width
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
	if (tile1.value == tile2.value) then
		count += 1
		
		local tileUpOneRowExists = nil

		if ( direction == 'row' and tile2.xPos + 1 <= self.width ) then
			tileUpOneRowExists = self:compare(
				tile2, self.matrix[tile2.xPos + 1][tile2.yPos], 'row', count
			)
			
			if (tileUpOneRowExists) then
				count += 1
			end
		elseif ( direction == 'column' and tile2.yPos + 1 <= self.height ) then
			tileUpOneRowExists = self:compare(tile2, self.matrix[tile2.xPos][tile2.yPos + 1], 'column', count)
			
			if (tileUpOneRowExists) then
				count += 1
			end
		end

		if count >= 2 then
			tile1.marked = true
			tile2.marked = true
			
			local function clear()
				self:clearMarkedTiles()
			end
		end
		
		return true
	else
		return false
	end
end

function Board:clearMarkedTiles()
	local count = 0
	for j = 1, self.height, 1 do
		for i = 1, self.width, 1 do
			local tile = self.matrix[i][j]
			if (tile.marked and not tile.checked) then
				tile:removeSprite()
				tile.value = nil
				tile.checked = true
				count += 1
			end
		end
	end
	
	-- backwards loop
	for j = self.width, 1, -1 do
		for i = self.height, 1, -1 do
			local tile = self.matrix[j][i]
				if (tile.marked) then
					self:pullDown(j, i - 1, 1)
				end
		end
	end
	
	-- self:fill()
end

function Board:draw()
	for i = 1, self.width, 1 do
		self.matrix[i] = {}
		for j = 1, self.height, 1 do
			self.matrix[i][j] = Tile( i, j )
			self.matrix[i][j]:draw( i, j )
		end
	end
	
	for i = 1, self.width, 1 do
		for j = 1, self.height, 1 do
			local initTile = self.matrix[i][j]
			
			-- i is column, j is row
			if ( ( i + 1 ) < self.width ) then
				self:compare(initTile, self.matrix[i + 1][j], 'row', 0 )
			end
			
			if ( ( j + 1 ) < self.height ) then
				self:compare(initTile, self.matrix[i][j + 1], 'column', 0 )
			end
		end
	end
	
	local function clearTiles()
		self:clearMarkedTiles()
	end	

	playdate.timer.performAfterDelay(1000, clearTiles)
end

function Board:fill()
	for i = 1, self.width, 1 do
		for j = 1, self.height, 1 do
			if (self.matrix[i][j].value == nil) then
				print(i, j, self.matrix[i][j].value)
				self.matrix[i][j]:reset()
			end
		end
	end
end

function Board:pullDown(x, y, count)
	if (y > 0) then
		local newTile = self.matrix[x][y] -- pulling down, making empty
		local emptySpace = self.matrix[x][y + 1] -- spot to be filled
		emptySpace.value = newTile.value
		emptySpace.marked = false
		newTile.value = nil

		if (newTile.marked == true) then -- it is also empty
			count += 1 	-- pull down upper tile one more space
						-- or generate one more tile in event of hitting the ceiling
			self:pullDown(x, y - 1, count)
		else
			local xPos = x + (x * spriteSize)
			local yPos = (y + count) + ((y + count) * spriteSize)
		
			local function move()
				self.matrix[x][y]:moveTo(xPos, yPos)
			end
			
			newTile.marked = true
			playdate.timer.performAfterDelay(250, move)

			self:pullDown(x, y - 1, count)
		end
	end
end
