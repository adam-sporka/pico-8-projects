pico-8 cartridge // http://www.pico-8.com
version 20
__lua__
last_beep_channel=3
function beep(note)
	--if note>63 then note=63 end
	note=note%64
	channel=(last_beep_channel+1)%4
	al=0x3200+68*channel+2*0
	ah=al+1
	c=0
	e=0
	v=2
	w=5
	p=note
	bh=shl(c,7)+shl(e,4)+shl(v,1)+shr(w,2)
	bl=shl(w%4,6)+p
	poke(al,bl)
	poke(ah,bh)
	a=0x3200+68*channel+65
	poke(a,24)
	sfx(channel)
	last_beep_channel=channel
end

discs={}
function new_disc(x,y,r,a,w)
	d={}
	d.x,d.y,d.r,d.a,d.w=x,y,r,a,w
	d.color=(#discs)%8+8
	add(discs,d)
	return #discs
end

links={}
function new_link(i1,i2)
	l={}
	l.i1,l.i2=i1,i2
	l.f,l.e,l.d,l.t=0,0,0,0
	add(links,l)
end

function default_scene()
	a=new_disc(64,32,32,0,1)
	b=new_disc(64,64,8,0,2)
	c=new_disc(64,96,48,0,.5)
	d=new_disc(64,32,64,0,.25)
	new_link(a,b)
 new_link(b,c)
 new_link(a,d)
end

function ragtime()
	a=new_disc(112,112, 16,0,0.5)
	b=new_disc( 48, 48,  8,0,1.0)
	c=new_disc( 16, 80,  8,0,1.5)
	d=new_disc( 48, 48, 24,0,2.0)
	new_link(a,b)
 new_link(b,c)
 new_link(c,d)
end

function random_scene()
	for i=1,4 do
		x=flr(rnd()*4)*32+16
		y=flr(rnd()*4)*32+16
		r=flr(rnd()*4)*8
		new_disc(x,y,r,0,i/2)
		if i>1 then
			new_link(i-1,i)
		end
	end
end

function reinitialize()
	discs={}
	links={}
	--default_scene()
	--ragtime()
	random_scene()
end

function _init()
	reinitialize()
end

function get_disc_pos(i)
	return discs[i].x,discs[i].y,discs[i].r
end

function get_point_pos_now(i)
	x=discs[i].x+sin(discs[i].a/64)*discs[i].r
	y=discs[i].y+cos(discs[i].a/64)*discs[i].r
	return x,y
end

function get_point_pos_next(i)
	x=discs[i].x+sin((discs[i].a+discs[i].w)/64)*discs[i].r
	y=discs[i].y+cos((discs[i].a+discs[i].w)/64)*discs[i].r
	return x,y
end

function _draw()
	cls()
	for i=1,#discs do
		x,y,r=get_disc_pos(i)
	 circ(x,y,r,5)
		x,y=get_point_pos_now(i)
		circ(x,y,2,discs[i].color)
	end
	for i=1,#links do
		if links[i].t>0 then
			x1,y1=get_point_pos_now(links[i].i1)
			x2,y2=get_point_pos_now(links[i].i2)
			line(x1,y1,x2,y2,6)
			beep(links[i].d)
		end
	end
end

function move()
	for i=1,#discs do
		discs[i].a+=discs[i].w
	end
end

function dists()
	for i=1,#links do
		links[i].f=links[i].e
		links[i].e=links[i].d
		x1,y1=get_point_pos_next(links[i].i1)
		x2,y2=get_point_pos_next(links[i].i2)
		d1=abs(x2-x1)
		d2=abs(y2-y1)
		d=sqrt(d1*d1+d2*d2)
		links[i].d=d
		f=links[i].f
		e=links[i].e
		d=links[i].d
		links[i].t=0
		if f>e and e<d then
			links[i].t=1
		elseif f<e and e>d then
			links[i].t=2
		end
	end
end

function dump_config_to_clip()
	r=""
	for i=1,#discs do
		d=discs[i]
		r=r..d.x..","
		r=r..d.y..","
		r=r..d.r..","
		r=r..d.a..","
		r=r..d.w.."\n"
	end
	printh(r,"@clip")
end

function _update()
	move()
	dists()
	if btnp(4) then
		dump_config_to_clip()
	end
	if btnp(5) then
		reinitialize()
	end
end

-- some fun configurations

-- 112,112,24,27.5,0.5
-- 16,16,0,55,1
-- 80,48,0,82.5,1.5
-- 48,112,16,110,2

-- 80,80,24,77.5,0.5
-- 112,16,8,155,1
-- 48,48,0,232.5,1.5
-- 112,80,24,310,2

-- 48,80,0,125,0.5
-- 112,80,0,250,1
-- 48,48,24,375,1.5
-- 48,112,8,500,2

-- 112,16,8,116.5,0.5
-- 16,48,24,233,1
-- 80,16,0,349.5,1.5
-- 80,112,24,466,2

-- 112,48,16,107,0.5
-- 48,16,16,214,1
-- 48,80,16,321,1.5
-- 48,16,16,428,2

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100003700037000370000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100003200032000320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344

