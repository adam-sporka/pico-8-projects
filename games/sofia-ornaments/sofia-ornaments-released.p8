pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--sofia ornaments 1.1
--@adam_sporka

function new_seg(x1,y1,x2,y2)
	s={}
	s.x1=x1
	s.y1=y1
	s.x2=x2
	s.y2=y2
	return s
end

function div_seg(seg,mode)
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
		new_seg(seg.x1,seg.y1,mx,my),
		new_seg(mx,my,seg.x2,seg.y2)
end

function subdiv(segs,mode)
	new_segs={}
	for s in all(segs) do
		s1,s2=div_seg(s,mode)
		add(new_segs,s1)
		add(new_segs,s2)
	end
	return new_segs
end

function dostuff(formula)
	segs={}
	add(segs,new_seg(48,48,80,48))
	add(segs,new_seg(80,48,80,80))
	add(segs,new_seg(80,80,48,80))
	add(segs,new_seg(48,80,48,48))
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

function drawsegs(segs,col)
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
	cls(1)
	if #string%2==1 then
		clr=7
	else
		clr=7
	end

	segs=dostuff(string)
	x1,y1,x2,y2=getbbox(segs)
	x=x1+(x2-x1)/2
	y=y1+(y2-y1)/2
	camera(x-64,y-60)
	drawsegs(segs,clr)
	camera(0,0)
	line(0,120,127,120,5)
	rectfill(0,121,127,127,0)
	print("use 🅾️⬆️⬇️➡️❎",0,122,6)
	if #string>0 then
		rule="rule \""..string.."\""
		print(rule,128-#rule*4,122,6)
	end
end

str=""
drawstring(str)

function update_ui()
	if btnp(4) then
		str=""
		drawstring(str)
	end
	if btnp(5) then
	 a="1"
		if rnd()<0.5 then a="2" end
		if #str>=8 then str=sub(str,#str-6) end
		str=str..a
		drawstring(str)
	end
	if btnp(1) then
		if #str<8 then
			str=str.."0"
			drawstring(str)
		end
	end
	if btnp(2) then
		if #str<8 then
			str=str.."1"
			drawstring(str)
		end
	end
	if btnp(3) then
		if #str<8 then
			str=str.."2"
			drawstring(str)
		end
	end
end

function _update()
	update_ui()
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117777777771111111777777777111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117171117171111111717111717111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117771117771111111777111777111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117111111171111111711111117111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117111111171111111711111117111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117111111171111111711111117111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117771117771111111777111777111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117171117171111111717111717111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111177777777777771117111777777777777711111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111171717111711111117111111171117171711111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111177777177777111777771117777717777711111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111171717171717111717171117171717171711111111111111111111111111111111111111111111111
11111111111111111111111111111111111111117777777777777777777777777777777777777777777777777111111111111111111111111111111111111111
11111111111111111111111111111111111111117171117171117111111111111111111111117111717111717111111111111111111111111111111111111111
11111111111111111111111111111111111111117771117771777111111111111111111111117771777111777111111111111111111111111111111111111111
11111111111111111111111111111111111111117111111171717111111111111111111111117171711111117111111111111111111111111111111111111111
11111111111111111111111111111111111177777777711177777111111111111111111111117777711177777777711111111111111111111111111111111111
11111111111111111111111111111111111171717171711171717111111111111111111111117171711171717171711111111111111111111111111111111111
11111111111111111111111111111111111177717777717771777111111111111111111111117771777177777177711111111111111111111111111111111111
11111111111111111111111111111111111171117171717171117111111111111111111111117111717171717111711111111111111111111111111111111111
11111111111111111111111111111111111171117777777771117111111111111111111111117111777777777111711111111111111111111111111111111111
11111111111111111111111111111111111171111111711111117111111111111111111111117111111171111111711111111111111111111111111111111111
11111111111111111111111111111111111177711177711111777111111111111111111111117771111177711177711111111111111111111111111111111111
11111111111111111111111111111111111171711171711111717111111111111111111111117171111171711171711111111111111111111111111111111111
11111111111111111111111111111111777777777777711177777111111111111111111111117777711177777777777771111111111111111111111111111111
11111111111111111111111111111111717171117111111171111111111111111111111111111111711111117111717171111111111111111111111111111111
11111111111111111111111111111111777771777771117771111111111111111111111111111111777111777771777771111111111111111111111111111111
11111111111111111111111111111111717171717171117171111111111111111111111111111111717111717171717171111111111111111111111111111111
11111111111111111111111177777777777777777777777771111111111111111111111111111111777777777777777777777777711111111111111111111111
11111111111111111111111171711171711171111111111111111111111111111111111111111111111111111111711171711171711111111111111111111111
11111111111111111111111177711177717771111111111111111111111111111111111111111111111111111111777177711177711111111111111111111111
11111111111111111111111171111111717171111111111111111111111111111111111111111111111111111111717171111111711111111111111111111111
11111111111111111111111171111111777771111111111111111111111111111111111111111111111111111111777771111111711111111111111111111111
11111111111111111111111171111111717171111111111111111111111111111111111111111111111111111111717171111111711111111111111111111111
11111111111111111111111177711177717771111111111111111111111111111111111111111111111111111111777177711177711111111111111111111111
11111111111111111111111171711171711171111111111111111111111111111111111111111111111111111111711171711171711111111111111111111111
11111111111111111111111177777777711171111111111111111111111111111111111111111111111111111111711177777777711111111111111111111111
11111111111111111111111111111111111171111111111111111111111111111111111111111111111111111111711111111111111111111111111111111111
11111111111111111111111111111111117771111111111111111111111111111111111111111111111111111111777111111111111111111111111111111111
11111111111111111111111111111111117171111111111111111111111111111111111111111111111111111111717111111111111111111111111111111111
11111111111111111111111111111111777771111111111111111111111111111111111111111111111111111111777771111111111111111111111111111111
11111111111111111111111111111111117171111111111111111111111111111111111111111111111111111111717111111111111111111111111111111111
11111111111111111111111111111111117771111111111111111111111111111111111111111111111111111111777111111111111111111111111111111111
11111111111111111111111111111111111171111111111111111111111111111111111111111111111111111111711111111111111111111111111111111111
11111111111111111111111177777777711171111111111111111111111111111111111111111111111111111111711177777777711111111111111111111111
11111111111111111111111171711171711171111111111111111111111111111111111111111111111111111111711171711171711111111111111111111111
11111111111111111111111177711177717771111111111111111111111111111111111111111111111111111111777177711177711111111111111111111111
11111111111111111111111171111111717171111111111111111111111111111111111111111111111111111111717171111111711111111111111111111111
11111111111111111111111171111111777771111111111111111111111111111111111111111111111111111111777771111111711111111111111111111111
11111111111111111111111171111111717171111111111111111111111111111111111111111111111111111111717171111111711111111111111111111111
11111111111111111111111177711177717771111111111111111111111111111111111111111111111111111111777177711177711111111111111111111111
11111111111111111111111171711171711171111111111111111111111111111111111111111111111111111111711171711171711111111111111111111111
11111111111111111111111177777777777777777777777771111111111111111111111111111111777777777777777777777777711111111111111111111111
11111111111111111111111111111111717171717171117171111111111111111111111111111111717111717171717171111111111111111111111111111111
11111111111111111111111111111111777771777771117771111111111111111111111111111111777111777771777771111111111111111111111111111111
11111111111111111111111111111111717171117111111171111111111111111111111111111111711111117111717171111111111111111111111111111111
11111111111111111111111111111111777777777777711177777111111111111111111111117777711177777777777771111111111111111111111111111111
11111111111111111111111111111111111171711171711111717111111111111111111111117171111171711171711111111111111111111111111111111111
11111111111111111111111111111111111177711177711111777111111111111111111111117771111177711177711111111111111111111111111111111111
11111111111111111111111111111111111171111111711111117111111111111111111111117111111171111111711111111111111111111111111111111111
11111111111111111111111111111111111171117777777771117111111111111111111111117111777777777111711111111111111111111111111111111111
11111111111111111111111111111111111171117171717171117111111111111111111111117111717171717111711111111111111111111111111111111111
11111111111111111111111111111111111177717777717771777111111111111111111111117771777177777177711111111111111111111111111111111111
11111111111111111111111111111111111171717171711171717111111111111111111111117171711171717171711111111111111111111111111111111111
11111111111111111111111111111111111177777777711177777111111111111111111111117777711177777777711111111111111111111111111111111111
11111111111111111111111111111111111111117111111171717111111111111111111111117171711111117111111111111111111111111111111111111111
11111111111111111111111111111111111111117771117771777111111111111111111111117771777111777111111111111111111111111111111111111111
11111111111111111111111111111111111111117171117171117111111111111111111111117111717111717111111111111111111111111111111111111111
11111111111111111111111111111111111111117777777777777777777777777777777777777777777777777111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111171717171717111717171117171717171711111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111177777177777111777771117777717777711111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111171717111711111117111111171117171711111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111177777777777771117111777777777777711111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117171117171111111717111717111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117771117771111111777111777111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117111111171111111711111117111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117111111171111111711111117111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117111111171111111711111117111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117771117771111111777111777111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117171117171111111717111717111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117777777771111111777777777111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600660666000000666660006666600066666000666660006666600000000000000666060606000666000006060660066006600666066606660660066606060
60606000600000006600066066606660660006606600666066060660000000000000606060606000600000006060060006000600006000600060060000606060
60606660660000006606066066000660660006606600066066606660000000000000660060606000660000000000060006000600666066606660060066600000
60600060600000006600066066000660666066606600666066060660000000000000606060606000600000000000060006000600600060006000060060000000
06606600666000000666660006666600066666000666660006666600000000000000606006606660666000000000666066606660666066606660666066600000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

