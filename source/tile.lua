local gfx <const> = playdate.graphics

class( 'Tile' ).extends( gfx.sprite )

function Tile:init( xPos, yPos )
	Tile.super.init(self)
	-- these are constant
	self.xCoordinate = xPos
	self.yCoordinate = yPos
	
	self.spriteTable =
	{
	  [1] = gfx.imagetable.new("images/tile1"),
	  [2] = gfx.imagetable.new("images/tile2"),
	  [3] = gfx.imagetable.new("images/tile3"),
	  [4] = gfx.imagetable.new("images/tile4"),
	}

	self:reset()
end

function Tile:reset()
	self.marked = false
	self.value = math.random(1, 4)
	local tile = self.spriteTable[self.value]:getImage(1)
	assert( tile ) -- make sure the image was where we thought
	self:setImage(tile) -- new sprite from image
end
