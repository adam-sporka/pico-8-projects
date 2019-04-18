pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
cls()
t=0
::_4::
for u=0,1,.001
do x=flr(64+64*cos(2*u+t))
y=flr(64+64*sin(u+t))
y=bxor(x,y) pset(x,y,u*16)
end t+=.003
flip()
goto _4

