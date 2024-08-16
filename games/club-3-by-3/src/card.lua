-- CARD FUNCTIONS

-- suits
-- 0 = undef
-- 1 = hearts
-- 2 = diamonds
-- 3 = clubs
-- 4 = spades

-- values
-- 1 = A
-- 2...10 = 2...10
-- 11 = J
-- 12 = Q
-- 13 = K

lb={"a","2","3","4","5","6","7","8","9","10","j","q","k","jkr"}
sx,sy=32,32

function get_color(suit)
	if (suit==1 or suit==2) return 8
	if (suit==3 or suit==4) return 5
	return 12
end

function suit(ncard)
	if (ncard<=0) return 0
	if (ncard>=53) return 5
	return flr((ncard-1)/13)+1
end

function val(ncard)
	if (ncard==0) return 0
	if (ncard>=53) return 14
	return ((ncard-1)%13)+1
end

function print_card(ncard,xx,yy)
	if ncard<=0 then
		return
	end
	cx,cy=cursor()
	x=xx or cx
	y=yy or cy
	s=suit(ncard)
	v=val(ncard)
	c=get_color(s)
	l=lb[v]
	r=s
	if s==5 then
		r=5
		l=""
	end
	str=l
	w=#str*4
	print(l,x-w/2+1,y-6,c)
	spr(r,x-3,y)
end

function draw_card(ncard,x,y)
	v=val(ncard)
	s=suit(ncard)
	rect(x+2,y,x+sx-3,y+sy-1,5)
	rect(x,y+2,x+sx-1,y+sy-3,5)
	rect(x+1,y+1,x+sx-2,y+sy-2,6)
	if ncard==0 then
	 rectfill(x+3,y+3,x+sx-4,y+sy-4,6)
	else
	 rectfill(x+3,y+3,x+sx-4,y+sy-4,7)
	 print_card(ncard,x+sx/2,y+sy/2)
	end
	n=-t*20
	if n<0 then n=0 end
	for a=1,n do
		rx=rnd(sx)+x
		ry=rnd(sy)+y
		pset(rx,ry,9)
	end
end

