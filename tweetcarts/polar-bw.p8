pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
b=0
::_::cls()
x=16 y=48
e=0.6*cos(b)
for t=0,10,0.005 do
x+=cos(e*t*sin(t)+(1-e)*t*cos(t))
y+=sin(e*t*sin(t)+(1-e)*t*cos(t))
pset(x,y)
end
b+=0.001
flip()
goto _
