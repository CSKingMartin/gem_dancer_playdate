local gfx <const> = playdate.graphics

class( 'Tile' ).extends( gfx.sprite )

function Tile:init( value, xPos, yPos )
	Tile.super.init(self)
	
	self.marked = false
	self.value = value
	self.xCoordinate = xPos
	self.yCoordinate = yPos
	
	self.spriteTable =
	{
	  [1] = gfx.imagetable.new("images/tile1"),
	  [2] = gfx.imagetable.new("images/tile2"),
	  [3] = gfx.imagetable.new("images/tile3"),
	  [4] = gfx.imagetable.new("images/tile4"),
	}

	local tile = self.spriteTable[value]:getImage(1)
	assert( tile ) -- make sure the image was where we thought
	self:setImage(tile) -- new sprite from image
end