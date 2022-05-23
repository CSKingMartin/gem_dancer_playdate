local gfx <const> = playdate.graphics
local spriteSize = 32

class( 'Tile' ).extends( gfx.sprite )

function Tile:init( xPos, yPos )
	Tile.super.init(self)
	-- these are constant
	self.xPos = xPos
	self.yPos = yPos
	self.marked = true
	self.checked = false
	
	self.spriteTable =
	{
	  [1] = gfx.imagetable.new("images/tile1"),
	  [2] = gfx.imagetable.new("images/tile2"),
	  [3] = gfx.imagetable.new("images/tile3"),
	  [4] = gfx.imagetable.new("images/tile4"),
	}

	self:reset()
	
	self:setCollideRect( 0, 0, self:getSize() )
end

function Tile:draw(x, y)
	local xPos = x + (x * spriteSize)
	local yPos = y + (y * spriteSize)

	self:moveTo( xPos, yPos )
	self:add() -- adds to display list
end

function Tile:reset()
	print('yo')
	self.marked = false
	self.checked = false
	self.value = math.random(1, 4)
	local tile = self.spriteTable[self.value]:getImage(1)
	assert( tile ) -- make sure the image was where we thought
	self:setImage(tile) -- new sprite from image
end
