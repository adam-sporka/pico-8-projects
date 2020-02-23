pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function nseg(x1,y1,x2,y2)
	s={}
	s.x1=x1
	s.y1=y1
	s.x2=x2
	s.y2=y2
	return s
end

function sseg(seg,mode)
	dx=seg.x2-seg.x1
	dy=seg.y2-seg.y1
	mx=seg.x1+dx/2
	my=seg.y1+dy/2
	if mode==1 then
		mx+=dy/2
		my+=-dx/2
	end
	if mode==2 then
		mx+=-dy/2
		my+=dx/2
	end
	return
		nseg(seg.x1,seg.y1,mx,my),
		nseg(mx,my,seg.x2,seg.y2)
end

function subdiv(segs,mode)
	new_segs={}
	for s in all(segs) do
		s1,s2=sseg(s,mode)
		add(new_segs,s1)
		add(new_segs,s2)
	end
	return new_segs
end

function dostuff(formula)
	segs={}
	-- add(segs,nseg(16,64,112,64))
	add(segs,nseg(40,40,88,40))
	add(segs,nseg(88,40,88,88))
	add(segs,nseg(88,88,40,88))
	add(segs,nseg(40,88,40,40))
	for a=1,#formula do
		mode=0
		if sub(formula,a,a)=="1" then
			mode=1
		elseif sub(formula,a,a)=="2" then
			mode=2
		end
		segs=subdiv(segs,mode)
	end
	return segs
end

function fade()
	for x=0,127 do
		for y=0,127 do
			c=pget(x,y)
			if c>5 then c-=1 else c=0 end
			pset(x,y,c)
		end
	end
end

function drawsegs(segs,col)
	for s in all(segs) do
		line(s.x1+1,s.y1,s.x2+1,s.y2,0)
		line(s.x1,s.y1+1,s.x2,s.y2+1,0)
		line(s.x1-1,s.y1,s.x2+1,s.y2,0)
		line(s.x1,s.y1-1,s.x2,s.y2-1,0)
	end
	for s in all(segs) do
		line(s.x1,s.y1,s.x2,s.y2,col)
	end
end

function getbbox(segs)
	x1,x2,y1,y2=999,-999,999,-999
	for s in all(segs) do
		if s.x1<x1 then x1=s.x1 end
		if s.y1<y1 then y1=s.y1 end
		if s.x2>x2 then x2=s.x2 end
		if s.y2>y2 then y2=s.y2 end
	end
	return x1,y1,x2,y2
end

function drawstring(string)
	if #string%2==1 then
		cls()
		clr=8
	else
		clr=7
	end

	if (#string%2==1) cls()
	segs=dostuff(string)
	camera(0,0)
	print("rule "..string,0,122,5)
	x1,y1,x2,y2=getbbox(segs)
	x=x1+(x2-x1)/2
	y=y1+(y2-y1)/2
	camera(x-64,y-64)
	drawsegs(segs,clr)
end

str=""
drawstring(str)

function update_ui()
	if btnp(4) then
		str=""
		drawstring(str)
	end
	if btnp(0) then
		if #str<13 then
			str=str.."0"
			drawstring(str)
		end
	end
	if btnp(1) then
		if #str<10 then
			str=str.."0"
			drawstring(str)
		end
	end
	if btnp(2) then
		if #str<10 then
			str=str.."1"
			drawstring(str)
		end
	end
	if btnp(3) then
		if #str<10 then
			str=str.."2"
			drawstring(str)
		end
	end
end

frame=0
function _update()
	frame+=1
	if frame%100==0 then
		frame=0
	 str=""
		drawstring(str)	
	elseif frame%6==0 then
		if #str<6 then
		 str=str..flr(rnd(2))+1
		 --str=str..flr(rnd(2))+1
			drawstring(str)	
		end
	end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
