pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
s={}t="░▥█▤░ "
for a=-1,15 do
for b=0,15 do
add(s,{x=a,y=b,t=(a+b)%#t+rnd(0),l=rnd(8)+7})
end
end
::_::
cls()
for g in all(s) do
g.t+=0.125
r=g.t%#t
u=sub(t,r,r)
?u,g.x*8+8*(1-g.t%1),g.y*8,g.l
end
flip()
goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
