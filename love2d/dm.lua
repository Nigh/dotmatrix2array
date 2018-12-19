
local dm={}

local dots={}

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
		canvas=love.graphics.newCanvas(frame_w,frame_h),
	}
	love.graphics.setPointSize( 1 )
	for i=1,h do
		table.insert(dotmatrix,{})
		for j=1,w do
			table.insert(dotmatrix[i],false)
		end
	end
	return dotmatrix
end

local function myStencilFunction()
   love.graphics.rectangle("fill", 0, 0, frame_w, frame_h)
end

function dm_draw(self,refresh)
	local r, g, b, a = love.graphics.getColor()
	if refresh then
		love.graphics.push()
		love.graphics.origin()
		love.graphics.setCanvas({self.canvas, stencil=true})
		love.graphics.clear()
		for i=1,self.h do
			for j=1,self.w do
				if self[i][j]==true then
					love.graphics.setColor(r, g, b, a)
					love.graphics.rectangle("fill", (j-1)*self.size+self.cx, (i-1)*self.size+self.cy, self.size-self.gap, self.size-self.gap)
				else
					love.graphics.setColor(r, g, b, a/3)
					love.graphics.rectangle("line", (j-1)*self.size+self.cx, (i-1)*self.size+self.cy, self.size-self.gap, self.size-self.gap)
				end
			end
		end
		love.graphics.setCanvas()
		love.graphics.pop()
	end

	love.graphics.stencil(myStencilFunction, "replace", 1)
	love.graphics.setStencilTest("equal", 1)
	love.graphics.setColor(r, g, b, a)
	love.graphics.draw(self.canvas)
	love.graphics.setStencilTest()
	love.graphics.setColor(r, g, b, a)
	love.graphics.rectangle("line", 0, 0, frame_w, frame_h)
end

function dm_draw_mini(self)
	for i=1,self.h do
		for j=1,self.w do
			if self[i][j]==true then
				love.graphics.points((j-1), (i-1))
			end
		end
	end
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
