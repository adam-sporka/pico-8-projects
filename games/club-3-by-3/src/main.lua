t=0

function _draw()
	cls(t)
	draw_card(flr(t),16,16)
end

function _update()
	t=t+0.125
end
