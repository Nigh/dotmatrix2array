
dm=require("dm")
suit = require('SUIT')
cg = require("carry_gen")
local input = {text = ""}

local UI ={
	dm_x=40,dm_y=80,
	mini_x=1100,mini_y=10,
}

local white = {1,1,1,0.7}

function love.load()
	love.graphics.setBackgroundColor( 40/0xff, 82/0xff, 121/0xff )
	love.math.setRandomSeed( 6173420+love.timer.getTime( ) )
	love.graphics.setLineWidth( 1 )
	main_frame=dm:new(256,256)

	gfont = love.graphics.newFont("font.ttf", 12)
	love.graphics.setFont(gfont)
	-- cg.generate(main_frame)
end

local slider_w= {value = 256, min = 4, max = 256, step = 16}
local slider_h= {value = 256, min = 4, max = 256, step = 16}
local slider_color = {
	normal   = {bg = {0.73,0.73,0.73}, fg = {0.73,0.73,0.73}},
	hovered  = {bg = {0.19,0.6,0.73}, fg = {1,1,1}},
	active   = {bg = {1,0.6,0}, fg = {1,1,1}}
}

local chkLT = {text = "左上",checked = true}
local chkLB = {text = "左下"}
local chkRT = {text = "右上"}
local chkRB = {text = "右下"}
local chkb_group1 = {chkLT,chkLB,chkRT,chkRB}

local chkVertical = {text = "纵向",checked = true}
local chkHorizontal = {text = "横向"}
local chkb_group2 = {chkVertical,chkHorizontal}

local chkLSB = {text = "低位在前",checked = true}
local chkMSB = {text = "高位在前"}
local chkb_group3 = {chkLSB,chkMSB}

local chkScanV = {text = "纵向",checked = true}
local chkScanH = {text = "横向"}
local chkb_group4 = {chkScanV,chkScanH}

local chkTrans = {text = "转置"}

function love.update( dt )
	UI.mini_x = love.graphics.getWidth()-main_frame.w-20
	main_frame:setframesize(love.graphics.getWidth()-main_frame.w-80,love.graphics.getHeight()-UI.dm_y-30)
	local fw,fh = main_frame:getframesize()
	suit.layout:reset(UI.dm_x,10,10,10)

	suit.Button("绘制",{align = "center"},suit.layout:right(90,52))
	suit.Button("选择",{align = "center"},suit.layout:right(90,52))
	suit.Button("旋转",{align = "center"},suit.layout:right(90,52))
	if suit.Button("裁切",{align = "center"},suit.layout:right(90,52)).hit then trim(main_frame) end
	suit.Button("保存",{align = "center"},suit.layout:right(90,52))
	suit.Button("读取",{align = "center"},suit.layout:right(90,52))	
	if suit.Button("生成",{align = "center"},suit.layout:right(90,52)).hit then
		local a,b,c,d
		if chkLT.checked then a = 'lt' end
		if chkLB.checked then a = 'lb' end
		if chkRT.checked then a = 'rt' end
		if chkRB.checked then a = 'rb' end
		
		if chkVertical.checked then b = 'v' end
		if chkHorizontal.checked then b = 'h' end
		
		if chkScanV.checked then c = 'v' end
		if chkScanH.checked then c = 'h' end

		if chkLSB.checked then d = 'LSB' end
		if chkMSB.checked then d = 'MSB' end
		-- cg.generate(main_frame,'lt','v','h','LSB')
		cg.generate(main_frame,a,b,c,d)
	end

	local cbw = 60
	local lx,ly,lw,lh = suit.layout:offset(30,10,cbw*2+0,20)
	suit.Checkbox(chkLT, {align='left',radiogroup=chkb_group1}, lx,ly,cbw,lh)
	suit.Checkbox(chkLB, {align='left',radiogroup=chkb_group1}, lx,ly+lh,cbw,lh)
	suit.Checkbox(chkRT, {align='left',radiogroup=chkb_group1}, lx+cbw,ly,cbw,lh)
	suit.Checkbox(chkRB, {align='left',radiogroup=chkb_group1}, lx+cbw,ly+lh,cbw,lh)
	suit.Groupbox("起始位置", {color=white}, lx,ly,lw,lh*2)

	lx,ly,lw,lh = suit.layout:offset(20,0,cbw,20)
	suit.Checkbox(chkVertical, {align='left',radiogroup=chkb_group2}, lx,ly,lw,lh)
	suit.Checkbox(chkHorizontal, {align='left',radiogroup=chkb_group2}, lx,ly+lh,lw,lh)
	suit.Groupbox("字节方向", {color=white}, lx,ly,lw,lh*2)

	lx,ly,lw,lh = suit.layout:offset(20,0,cbw,20)
	suit.Checkbox(chkScanV, {align='left',radiogroup=chkb_group4}, lx,ly,lw,lh)
	suit.Checkbox(chkScanH, {align='left',radiogroup=chkb_group4}, lx,ly+lh,lw,lh)
	suit.Groupbox("扫描方向", {color=white}, lx,ly,lw,lh*2)

	lx,ly,lw,lh = suit.layout:offset(20,0,80,20)
	suit.Checkbox(chkLSB, {align='left',radiogroup=chkb_group3}, lx,ly,lw,lh)
	suit.Checkbox(chkMSB, {align='left',radiogroup=chkb_group3}, lx,ly+lh,lw,lh)
	suit.Groupbox("位顺序", {color=white}, lx,ly,lw,lh*2)

	-- lx,ly,lw,lh = suit.layout:offset(20,0,60,20)
	-- suit.Checkbox(chkTrans, {align='left'}, lx,ly,lw,lh)
	-- suit.Groupbox("转置", {color=white}, lx,ly,lw,lh)

	suit.layout:reset(UI.dm_x-40,UI.dm_y+fh-256-16,10,15)
	suit.Label(("%d"):format(slider_h.value),{align = "center"}, suit.layout:row(40,10))

	suit.layout:reset(UI.dm_x-30,UI.dm_y+fh-256,10,15)
	suit.Slider(slider_h,{vertical=true,color=slider_color},suit.layout:row(16,256))

	suit.layout:reset(UI.dm_x+16,UI.dm_y+fh+10,15,10)
	suit.Slider(slider_w,{color=slider_color},suit.layout:row(256,16))
	suit.Label(("%d"):format(slider_w.value),{align = "left"}, suit.layout:right(30,10))
	slider_w.value = math.ceil(slider_w.value)
	slider_h.value = math.ceil(slider_h.value)
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

function trim(dm)
	local _=false
	for i=dm.h,1,-1 do
		for j=1,dm.w do
			if main_frame[i][j] then
				slider_h.value = i>slider_h.min and i or slider_h.min
				_ = true
				break
			end
		end
		if _ then break end
	end

	_=false
	for j=dm.w,1,-1 do
		for i=1,dm.h do
			if main_frame[i][j] then
				slider_w.value = j>slider_w.min and j or slider_w.min
				_ = true
				break
			end
		end
		if _ then break end
	end

end
