t=0

function _init()
	game_deck=deck.new()
end

function _draw()
	cls()
	game_deck:draw()
end

function _update()
	if btnp(4) then
		game_deck2=deck.new();
	end
end
