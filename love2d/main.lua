
dm=require("dm")
suit = require('SUIT')
local input = {text = ""}

local UI ={
	dm_x=40,dm_y=80,
	mini_x=1100,mini_y=10,
}

function love.load()
	love.graphics.setBackgroundColor( 0x0a/0xff, 0x08/0xff, 0x06/0xff )
	love.math.setRandomSeed( 6173420+love.timer.getTime( ) )
	love.graphics.setLineWidth( 1 )
	main_frame=dm:new(256,256)
	
	btn00 = love.graphics.newImage("res/select_normal.png")
	btn01 = love.graphics.newImage("res/select_hover.png")
	btn02 = love.graphics.newImage("res/select_active.png")
	btn10 = love.graphics.newImage("res/draw_normal.png")
	btn11 = love.graphics.newImage("res/draw_hover.png")
	btn12 = love.graphics.newImage("res/draw_active.png")
end

local slider_w= {value = 256, min = 16, max = 256, step = 16}
local slider_h= {value = 256, min = 16, max = 256, step = 16}
local chkLT = {text = "LT"}
local chkLB = {text = "LB"}
local chkRT = {text = "RT"}
local chkRB = {text = "RB"}
local chkHorizontal = {text = "Ho"}
local chkVertical = {text = "Ve"}
local chkLSB = {text = "LSB"}
local chkMSB = {text = "MSB"}
function love.update( dt )
	UI.mini_x = love.graphics.getWidth()-main_frame.w-20
	main_frame:setframesize(love.graphics.getWidth()-main_frame.w-80,love.graphics.getHeight()-UI.dm_y-30)
	local fw,fh = main_frame:getframesize()
	suit.layout:reset(UI.dm_x,10,10,10)

	suit.ImageButton(btn10, {align = "center",hovered = btn11,active = btn12}, suit.layout:right(100,30))
	suit.ImageButton(btn00, {align = "center",hovered = btn01,active = btn02}, suit.layout:right(100,30))
	suit.Button("btn1",{align = "center"},suit.layout:right(100,30))
	suit.Button("btn2",{align = "center"},suit.layout:right(100,30))
	suit.Button("btn3",{align = "center"},suit.layout:right(100,30))
	suit.Button("btn4",{align = "center"},suit.layout:right(100,30))
	suit.Button("btn5",{align = "center"},suit.layout:right(100,30))

	suit.layout:down(100,10)
	suit.layout:push(suit.layout:right(100,20))
	suit.Checkbox(chkLT, {align='left'}, suit.layout:right(100,20))
	suit.Checkbox(chkLB, {align='left'}, suit.layout:down(100,20))
	suit.layout:pop()

	suit.layout:push(suit.layout:right(100,20))
	suit.Checkbox(chkRT, {align='left'}, suit.layout:right(100,20))
	suit.Checkbox(chkRB, {align='left'}, suit.layout:down(100,20))
	suit.layout:pop()

	suit.layout:push(suit.layout:right(100,20))
	suit.Checkbox(chkVertical, {align='left'}, suit.layout:right(100,20))
	suit.Checkbox(chkHorizontal, {align='left'}, suit.layout:down(100,20))
	suit.layout:pop()

	suit.layout:push(suit.layout:right(100,20))
	suit.Checkbox(chkLSB, {align='left'}, suit.layout:right(100,20))
	suit.Checkbox(chkMSB, {align='left'}, suit.layout:down(100,20))
	suit.layout:pop()



	suit.layout:reset(UI.dm_x-40,UI.dm_y+fh-256-16,10,15)
	suit.Label(("%d"):format(slider_h.value),{align = "center"}, suit.layout:row(40,10))

	suit.layout:reset(UI.dm_x-30,UI.dm_y+fh-256,10,15)
	suit.Slider(slider_h,{vertical=true},suit.layout:row(16,256))

	suit.layout:reset(UI.dm_x+16,UI.dm_y+fh+10,15,10)
	suit.Slider(slider_w,suit.layout:row(256,16))
	suit.Label(("%d"):format(slider_w.value),{align = "left"}, suit.layout:right(30,10))
	main_frame:setdrawsize(slider_w.value,slider_h.value)
end

function love.draw( ... )
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.origin()
	love.graphics.translate( UI.dm_x, UI.dm_y )
	main_frame:draw()
	love.graphics.origin()

	love.graphics.translate( UI.mini_x, UI.mini_y )
	main_frame:draw_mini()
	love.graphics.origin()

	love.graphics.setColor(1, 1, 1)
	love.graphics.print(tostring(love.timer.getFPS( )), 0, 0)
	suit.draw()
end

function love.textedited(text, start, length)
    -- for IME input
    suit.textedited(text, start, length)
end

function love.textinput(t)
	-- forward text input to SUIT
	suit.textinput(t)
end

function love.keypressed(key, scancode, isrepeat)
	suit.keypressed(key)
end

function love.keyreleased(key)
end

function love.mousepressed( mx, my, button, istouch, presses )
	if main_frame:inframe(mx-UI.dm_x,my-UI.dm_y) then
		if button==1 then
			mouse_draw = true
			local f,x,y=main_frame:hit(mx-UI.dm_x,my-UI.dm_y)
			if f==true then
				main_frame:set(x,y)
				update_draw = true
			end
		elseif button==2 then
			mouse_clear = true
			local f,x,y=main_frame:hit(mx-UI.dm_x,my-UI.dm_y)
			if f==true then
				main_frame:clear(x,y)
				update_draw = true
			end
		elseif button==3 then
			mouse_drag = true
		end
	end
end

function love.mousemoved(mx, my, dx, dy)
	local step = 1
	local xs,ys = 0,0
	if mouse_draw or mouse_clear then
		if math.abs(dx)>2 or math.abs(dy)>2 then
			step = math.floor(math.pow(dx*dx+dy*dy,0.5)/2)+1
			xs,ys = dx/step,dy/step
		end

		for i=1,step do
			if mouse_draw then
				local f,x,y=main_frame:hit(mx-UI.dm_x,my-UI.dm_y)
				if f==true then
					main_frame:set(x,y)
					update_draw = true
				end
			elseif mouse_clear then
				local f,x,y=main_frame:hit(mx-UI.dm_x,my-UI.dm_y)
				if f==true then
					main_frame:clear(x,y)
					update_draw = true
				end
			end
			mx, my = mx-xs, my-ys
		end
	end

	if mouse_drag then
		main_frame.cx = main_frame.cx+dx
		main_frame.cy = main_frame.cy+dy
		update_draw = true
	end
end

function love.mousereleased(mx, my, button)
	if button==1 and mouse_draw then
		mouse_draw = false
	end
	if button==2 and mouse_clear then
		mouse_clear = false
	end
	if button==3 and mouse_drag then
		mouse_drag = false
	end
end

function love.wheelmoved(x, y)
	local mx, my = love.mouse.getPosition()
	mx = mx - UI.dm_x
	my = my - UI.dm_y
	if main_frame:inframe(mx,my) then
		local k=1
		if y<0 and main_frame.size>2 then
			k = (main_frame.size-1)/main_frame.size
			main_frame.size = main_frame.size-1
		elseif y>0 and main_frame.size<20 then
			k = (main_frame.size+1)/main_frame.size
			main_frame.size = main_frame.size+1
		end
		main_frame.cx = (main_frame.cx - mx)*k + mx
		main_frame.cy = (main_frame.cy - my)*k + my
		update_draw = true
	end
end

function love.quit()
    return false
end
