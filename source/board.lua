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
					print(j, i)
					self:pullDown(j, i - 1, 1)
				end
		end
	end
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

function Board:pullDown(x, y, count)
	if (y > 0) then
		local target = self.matrix[x][y]
		self.matrix[x][y + 1].value = target.value
		self.matrix[x][y + 1].marked = false

		-- it is also empty
		if (target.marked) then
			print('found', x, y)
			count += 1 	-- pull down upper tile one more space
						-- or generate one more tile in event of hitting the ceiling
			self:pullDown(x, y - 1, count)
		else
			local xPos = x + (x * spriteSize)
			local yPos = (y + count) + ((y + count) * spriteSize)
			print(xPos, yPos)
			local function move()
				self.matrix[x][y]:moveTo(xPos, yPos)
			end
			
			playdate.timer.performAfterDelay(250, move)
			self:pullDown(x, y - 1, count)
		end
	end
end

function Board:reDraw()
	self:clear()
	self:draw()
end

