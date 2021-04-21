pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
tvec={
 __add=function(a,b)
  return vec(a[1]+b[1],a[2]+b[2])
 end,
 __sub=function(a,b)
  return vec(a[1]-b[1],a[2]-b[2]) 
 end,
 __unm=function(a)
  return a*-1
 end,
 __mul=function(a,b)
  if getmetatable(b)==tvec then
      return a[1]*b[1]+a[2]*b[2]
     else
      return vec(a[1]*b,a[2]*b)
     end
 end,
 __div=function(a,b)
  return a*(1/b)
 end,
 __tostring=function(s)
  return s:tostring()
 end,
 __concat=function(a,b)
  if(getmetatable(a)==tvec)a=a:tostring()
  if(getmetatable(b)==tvec)b=b:tostring()
  return a..b
 end,
 __index={
  length=function(s)
   return sqrt(s*s)
  end,
  tostring=function(s)
      return "("..s[1]..","..s[2]..")"
  end,
  normalised=function(s)
   return s/s:length()
  end
 }
}

function vec(x,y)
 local v={x,y}
 setmetatable(v,tvec)
  return v
end

shape={5,5,5,5}
dirs={{0,1},{1,0},{0,-1},{-1,0}}
ball=vec(60,60)
ballv=vec(-1,-1.5)

function reflect(pt,l0,l1)
	local px=pt[1]
	local py=pt[2]
	local x0=l0[1]
	local y0=l0[2]
	local x1=l1[1]
	local y1=l1[2]
	local dx=x1-x0
	local dy=y1-y0
	a=(dx*dx-dy*dy)/(dx*dx+dy*dy)
	b=2*dx*dy/(dx*dx+dy*dy)
	x2=a*(px-x0)+b*(py-y0)+x0
	y2=b*(px-x0)-a*(py-y0)+y0
	return vec(x2,y2)
end

function x()
	if 1==1 then
		return true
	end
end

function bounce(ball,ballv)
 b1=ball
 b2=ball+ballv
	segs={}
	for a=1,4 do
		segs[#segs+1]=getsegment(a)
	end
	segs[#segs+1]={vec(-62,62),vec(62,62)}
	segs[#segs+1]={vec(62,62),vec(62,-62)}
	segs[#segs+1]={vec(62,-62),vec(-62,-62)}
	segs[#segs+1]={vec(-62,-62),vec(-62,62)}
	for a=1,#segs do
	 p1=segs[a][1]
	 p2=segs[a][2]
		line(p1[1],p1[2],p2[1],p2[2],5)
		r=intersect(p1,p2,b1,b2)
		if r~=nil then
			r1=reflect(b1,p1,p2)
			r2=reflect(b2,p1,p2)
			sfx(0)
			return r2,r2-r1
		end
	end
	return b1,b2-b1
end

function animate()
	ball=ball+ballv
end

function draw_ball()
	circfill(ball[1],-ball[2],1,15)
end

function reshape(i)
	local can=true
	for a=1,4 do
		if a~=i then
			if shape[a]<=2 then
				can=false
			end
		end
	end
	if can then
		shape[i]+=3
		for a=1,4 do
			if a~=i then
				shape[a]-=1
			end
		end
	end
end

function shrink()
	for a=1,4 do
		shape[a]=4*0.1+shape[a]*0.9
	end
end

function getpos(i)
	local d=dirs[i]
	local x=d[1]*shape[i]*4
	local y=d[2]*shape[i]*4
	return vec(x,y)
end

function getsegment(j)
	local i1=j
	local i2=j+1
	if i2==5 then i2=1 end
	local p1=getpos(i1)
	local p2=getpos(i2)
	return {p1,p2}
end

function draw_shape()
	for a=1,4 do
		local p=getsegment(a)
		line(p[1][1],-p[1][2],p[2][1],-p[2][2],2)
	end
	for a=1,4 do
		local p=getpos(a)
		circfill(p[1],-p[2],1,12)
	end
end

function _init()
	camera(-64,-64)
end

function _update()
	if btnp(0) then reshape(4) end
	if btnp(1) then reshape(2) end
	if btnp(2) then reshape(1) end
	if btnp(3) then reshape(3) end
	if btn(4) then shrink() end
	animate()
	ball,ballv=bounce(ball,ballv)
end

function intersect(a1,a2,b1,b2)
 a2-=a1
 b1-=a1
 b2-=a1
 local t=a2:normalised()
 local n=vec(t[2],-t[1])
 local d1,d2=b1*n,b2*n
 if(sgn(d1)==sgn(d2))return nil
 local f=-d1/(d2-d1)
 local i=b1+(b2-b1)*f
 local ti=t*i
 if(ti<0 or ti>a2:length())return nil 
 return a1+i   
end

function _draw()
	cls()
	draw_shape()
	draw_ball()
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100003505034050300502a050240501e0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
