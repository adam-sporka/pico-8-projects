pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
function spr_to_pts(s)
	px=(s%16)*8
	py=(flr(s/16))*8
	ans={}
	for x=0,7 do
		for y=0,7 do
			c=sget(px+x,py+y)
			if c>0 then
				a={}
				a.x,a.y=x,y
				ans[c]=a
			end
		end
	end
	return ans
end

function pts_to_segments(pts)
	ans={}
	if pts[15]==nil then
		prev=nil
		for c,p in pairs(pts) do
			if prev~=nil then
				a={}
				a.x1,a.y1=prev.x,prev.y
				a.x2,a.y2=p.x,p.y
				ans[#ans+1]=a
			end
			prev=p
		end
	else
		hub=pts[15]
		for c,p in pairs(pts) do
			if c<15 then
				a={}
				a.x1,a.y1=hub.x,hub.y
				a.x2,a.y2=p.x,p.y
				ans[#ans+1]=a
			end
		end
	end
	return ans
end

ltr={}
function load_letter(c)
	pts=spr_to_pts(ord(c)-96)
	seg=pts_to_segments(pts)
	ltr[ord(c)]=seg
end

space={}
function setup_space()
	a={}
	a.x1,a.y1,a.x2,a.y2=3,3,3,3
	space[1]=a
	space[2]=a
	space[3]=a
end

function new_display_segment()
	local segment={}
	segment.cx1,segment.ty1,segment.tx2,segment.ty2=3,3,3,3
	segment.tx1,segment.cy1,segment.cx2,segment.cy2=3,3,3,3
	return segment
end

function new_display_cell()
	local cell={}
	cell[1]=new_display_segment()
	cell[2]=new_display_segment()
	cell[3]=new_display_segment()
	return cell
end

display={}
function setup_display()
	for y=1,8 do
		display[y]={}
		for x=1,8 do
			display[y][x]=new_display_cell()
		end
	end
end

function normalize(x,y)
	local c=sqrt(x*x+y*y)
	if c < 1 then
		return x,y
	end
	return x/c,y/c
end

function update_display_cell(col,row)
	local cell=display[row][col]
	for s=1,3 do
		dx1=cell[s].tx1-cell[s].cx1
		dy1=cell[s].ty1-cell[s].cy1
		dx1,dy1=normalize(dx1,dy1)
		dx2=cell[s].tx2-cell[s].cx2
		dy2=cell[s].ty2-cell[s].cy2
		dx2,dy2=normalize(dx2,dy2)
		cell[s].cx1+=dx1
		cell[s].cy1+=dy1
		cell[s].cx2+=dx2
		cell[s].cy2+=dy2
	end
	display[row][col]=cell
end

function draw_display_cell(col,row,size)
	x=(col-1)*size
	y=(row-1)*size
	local cell=display[row][col]
	for s in all(cell) do
		x1=x+(s.cx1)*size/8
		y1=y+(s.cy1)*size/8
		x2=x+(s.cx2)*size/8
		y2=y+(s.cy2)*size/8
		line(x1,y1,x2,y2)
	end
end

function set_target_ltr(col,row,c)
	local i=0
	for a in all(ltr[ord(c)]) do
		i+=1
		display[row][col][i].tx1=a.x1
		display[row][col][i].ty1=a.y1
		display[row][col][i].tx2=a.x2
		display[row][col][i].ty2=a.y2
	end
end

function _init()
	for l=ord("a"),ord("z") do
		load_letter(chr(l))
	end
	setup_space()
	setup_display()
end

t=0
function _update()
	local i=0
	for row=1,8 do
		for col=1,8 do
			update_display_cell(col,row)
			if (i%64==t%64) then
				if btn(4) then set_target_ltr(col,row,chr(32))
				else set_target_ltr(col,row,chr(97+(t%26)))
				end
			end
			i+=1
		end
	end
	t+=1
end

t=0
function _draw()
	cls()
	for row=1,8 do
		for col=1,8 do
			draw_display_cell(col,row,16)
		end
	end
end

__gfx__
00000000000200001000000000000020000000100000001000000010000000101000000000010000000000101000000010000000000f00002000004010000020
00000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000
00700700000000004000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700040000000000000003000000000000000f0000020f0000020200000400003000000000000000000000000002000000000000000000000000000000000
00077000000000000000003000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000400000200000000000000040000000000000000000000000
0000000010000030200000000000004000000020000000303000000000000030200000400032400000030000f000003020000030100200301000003000030000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
20000000000000202000300000000010100300201000004010000034100200301000004010000020100000200000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000030300000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000200000300000000000000000000000000000000000000000000f0000000000000000000000000000000000000000000000000000
40000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10000000000000101000000040000000000400002000003000020000000f00003000002000030000300000400000000000000000000000000000000000000000
