-- DCard is a card in the deck
-- This is the only place that persists the state of a card

-- State
-- 0 = not yet dealt
-- 1 = dealt
-- 2 = discarded
dcard=class:new({
	ncard=5,
	state=0
})

-- Deck is the list of cards
deck=class:new({
	cards={},
	new=function(self,tbl)
		local tbl=class.new(self,tbl)
		for a=1,60 do
			local card=dcard:new({ncard=a})
			add(self.cards,card)
		end
		for i=#self.cards, 2, -1 do
			local j = flr(rnd(i))
			self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
		end		
		return tbl
	end,
})

deck.draw=function(_ENV)
	rectfill(0,120,127,123,1)
	local x=0
	for card in all(cards) do
		x+=2
		line(x,121,x,122,get_color(suit(card.ncard)))
	end
	print(#cards,0,0,1)
	print(test,0,11,1)
end
