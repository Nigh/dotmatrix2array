
dm=require("dm")
suit = require('SUIT')
local input = {text = ""}

local UI ={
	dm_x=40,dm_y=80,
	mini_x=1100,mini_y=10,
}

function love.load()
	print("test")
	love.graphics.setBackgroundColor( 0x0a/0xff, 0x08/0xff, 0x06/0xff )
	love.math.setRandomSeed( 6173420+love.timer.getTime( ) )
	love.graphics.setLineWidth( 1 )
	main_frame=dm:new(128,128)
	suit.layout:reset(0,0)
	UI.mini_x = 1200 + UI.dm_x - main_frame.w
	btn00 = love.graphics.newImage("res/select_normal.png")
	btn01 = love.graphics.newImage("res/select_hover.png")
	btn02 = love.graphics.newImage("res/select_active.png")
	btn10 = love.graphics.newImage("res/draw_normal.png")
	btn11 = love.graphics.newImage("res/draw_hover.png")
	btn12 = love.graphics.newImage("res/draw_active.png")
	update_draw=true
end

function love.update( dt )
	suit.layout:reset(UI.dm_x,10)
	suit.layout:padding(10,5)

	suit.ImageButton(btn10, {align = "center",hovered = btn11,active = btn12}, suit.layout:right(100,30))
	suit.ImageButton(btn00, {align = "center",hovered = btn01,active = btn02}, suit.layout:right(100,30))

	suit.Button("btn1",{align = "center"},suit.layout:right(100,30))
	suit.Button("btn2",{align = "center"},suit.layout:right(100,30))
	suit.Button("btn3",{align = "center"},suit.layout:right(100,30))
	suit.Button("btn4",{align = "center"},suit.layout:right(100,30))
	suit.Button("btn5",{align = "center"},suit.layout:right(100,30))
end

function love.draw( ... )
	love.graphics.setColor(1, 1, 1,1)

	love.graphics.origin()
	love.graphics.translate( UI.dm_x, UI.dm_y )
	main_frame:draw(update_draw)
	update_draw = false
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
	if main_frame:inframe(mx,my) then
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
	if math.abs(dx)>2 or math.abs(dy)>2 then
		step = math.floor(math.pow(dx*dx+dy*dy,0.5)/3)+1
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
