global=_ENV

class=setmetatable({
	new=function(self,tbl)
		local tbl=tbl or {}
		setmetatable(tbl,{__index=self})
		return tbl
	end
},{__index=_ENV})
