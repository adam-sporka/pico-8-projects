pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
cls()
t=0::_::
for a=0,127 do
x=bxor((a+1+t)%128,a)
y=a
pset(x,y,(t/32)%8+8)
end
t+=1
flip()
goto _
