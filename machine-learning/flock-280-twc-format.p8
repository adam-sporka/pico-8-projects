pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
::z::x={}y={}
for t=0,63 do
x[t]=rnd()*128y[t]=rnd()*128
end
::_::cls()
for t=0,63 do
p=0q=0
for u=0,63 do
if (t!=u) and abs(x[t]-x[u])<20 and abs(y[t]-y[u])<20 then
p+=.01*(x[u]-x[t])q+=.01*(y[u]-y[t])
end
end
x[t]+=p
y[t]+=q
pset(x[t],y[t],t)
end
if(btnp(4)) goto z
flip()goto _
