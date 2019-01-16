
local dm={}

-- local dots={}

local default_size = 8
local default_gap = 0
local frame_w,frame_h = 1200, 600

function dm:new(w,h)
	local dotmatrix={
		w=w,h=h,
		cx=0,cy=0,
		size=default_size,
		gap=default_gap,
		draw=dm_draw,
		draw_mini=dm_draw_mini,
		set=dm_set,
		clear=dm_clear,
		toggle=dm_toggle,
		hit=dm_is_hit,
		inframe=dm_is_inframe,
		setframesize=dm_setframesize,
		getframesize=dm_getframesize,
		setdrawsize=dm_setdrawsize,
		dots=love.graphics.newCanvas(w,h),
	}
	dotmatrix.dots:setFilter( "nearest", "nearest" )
	love.graphics.setPointSize( 1 )
	love.graphics.setCanvas(dotmatrix.grid)
	for i=1,h do
		table.insert(dotmatrix,{})
		for j=1,w do
			table.insert(dotmatrix[i],false)
		end
	end
	return dotmatrix
end

function dm_setframesize(self,w,h)
	frame_w,frame_h = w,h
end

function dm_getframesize(self,w,h)
	return frame_w,frame_h
end

function dm_setdrawsize(self,w,h)
	self.w,self.h = w,h
end

local function myStencilFunction()
	love.graphics.rectangle("fill", 0, 0, frame_w, frame_h)
end

function util_draw_dots(self)
	local points = {}
	for i=1,self.h do
		for j=1,self.w do
			if self[i][j]==true then
				table.insert(points,j)
				table.insert(points,i)
			end
		end
	end
	love.graphics.points( points )
end

function util_draw_grid(self)
	for i=1,self.h+1 do
		love.graphics.line(0, (i-1)*self.size, self.size*self.w, (i-1)*self.size)
	end
	for i=1,self.w+1 do
		love.graphics.line((i-1)*self.size, 0, (i-1)*self.size, self.size*self.h)
	end
end

function dm_draw(self)
	local r, g, b, a = love.graphics.getColor()

	love.graphics.push()
	love.graphics.origin()
	love.graphics.setCanvas({self.dots, stencil=true})
	love.graphics.clear()
	util_draw_dots(self)
	love.graphics.setCanvas()
	love.graphics.pop()

	love.graphics.stencil(myStencilFunction, "replace", 1)
	love.graphics.setStencilTest("equal", 1)
	love.graphics.setColor(r, g, b, a)

	love.graphics.push()
	love.graphics.scale(self.size)
	love.graphics.translate(self.cx/self.size,self.cy/self.size)
	love.graphics.draw(self.dots)
	love.graphics.pop()

	love.graphics.setColor(r, g, b, (a*self.size/8)/3)
	love.graphics.push()
	love.graphics.translate(self.cx,self.cy)
	util_draw_grid(self)
	love.graphics.pop()
	love.graphics.setStencilTest()
	love.graphics.setColor(r, g, b, a)
	love.graphics.rectangle("line", 0, 0, frame_w, frame_h)
end

function dm_draw_mini(self)
	love.graphics.draw(self.dots)
	love.graphics.rectangle("line", -1, -1, self.w+1, self.h+1)
end

function dm_set(self,x,y)
	if self[y]~=nil and self[y][x]~=nil then
		self[y][x] = true
	end
end

function dm_clear(self,x,y)
	if self[y]~=nil and self[y][x]~=nil then
		self[y][x] = false
	end
end

function dm_toggle(self,x,y)
	if self[y]~=nil and self[y][x]~=nil then
		self[y][x] = not self[y][x]
	end
end

function dm_is_hit(self,mx,my)
	mx = mx-self.cx
	my = my-self.cy
	if mx>0 and mx<=self.size*self.w and my>0 and my<=self.size*self.h then
		return true,math.floor(mx/self.size)+1,math.floor(my/self.size)+1
	end
	return false,nil,nil
end

function dm_is_inframe(self,mx,my)
	if mx>0 and mx<=frame_w and my>0 and my<=frame_h then
		return true
	end
	return false
end


return dm
