local colors = 
{
	{0, 255, 0, 128},
	{255, 0, 0, 128},
	{0, 0, 255, 128},
	{255, 255, 0, 128},

}

local controllers = 
{
	{271, 164},
	{333, 164},
	{268, 219},
	{331, 219}

}

local pressed = {
	{},
	{},
	{},
	{},
}
local released = {
	{},
	{},
	{},
	{},
}

local buttons = {
	{476, 228, 20},
	{528, 188, 20},
	{429, 189, 20},
	{482, 147, 20},
	{143, 24, 10},
	{462, 24, 10},
	{104, 77, 10},
	{500, 77, 10},
	{117, 212, 10},
	{385, 300, 10},
	{234, 192, 10},
	{365, 192, 10},

}

local hats = 
{
	u = {209, 251},
	ru = {239, 258},
	r = {255, 285},
	rd = {242, 307},
	d = {212, 315},
	ld = {183, 307},
	l = {168, 285},
	lu = {177, 259},
	c = {209, 284}
}

function drawTriggerAxis(value, top, bottom)

	local halfwidth = 5
	local height = bottom[2] - top[2]
	love.graphics.push()
	love.graphics.translate( unpack(bottom) )
	love.graphics.rectangle("fill", -halfwidth, 0, halfwidth*2, -height * value)

	love.graphics.pop()

end

function drawXAxis(value, mid)
	local height = 5
	local maxwidth = 50

	love.graphics.push()
	love.graphics.translate( unpack(mid) )


	local lx = 0
	local rx = 0

	if value > 0 then
		rx = value * maxwidth/2
		lx = 0
	else
		lx = value * maxwidth/2
		rx = 0
	end

	--print(string.format("%f %d %d", value, lx, rx))
	love.graphics.rectangle("fill", lx, -height/2, rx-lx, height)

	love.graphics.pop()

end

function drawYAxis(value, mid)
	local maxheight = 50
	local width = 5

	love.graphics.push()
	love.graphics.translate( unpack(mid) )

	local ty = 0
	local by = 0

	if value > 0 then
		ty = -value * maxheight/2
		by = 0
	else
		by = -value * maxheight/2
		ty = 0
	end

	--print(string.format("%f %d %d", value, lx, rx))
	love.graphics.rectangle("fill", -width/2, by, width, ty-by)

	love.graphics.pop()

end



local axes = 
{
	{
		{118, 210},
		func = drawXAxis
	},
	{
		{118, 210},
		func = drawYAxis
	},
	{
		{384, 301},
		func = drawXAxis
	},
	{
		{384, 301},
		func = drawYAxis
	},
	{
		{170, 14},
		{170, 58},
		func = drawTriggerAxis
	},
	{
		{430, 14},
		{430, 58},
		func = drawTriggerAxis
	},
}

function love.load()
	padimg = love.graphics.newImage("xboxpad.png")


end

function love.draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(padimg, 0, 0)

	--love.graphics.setColorMode("replace")

	for i=1,4 do
		love.graphics.setColor(unpack(colors[i]))
		if love.joystick.isOpen(i) then
			love.graphics.print( love.joystick.getName(i), 11, 10 * i)
			love.graphics.circle("fill", controllers[i][1], controllers[i][2], 4)
		end
		for b=1,12 do
			local scale = 1
			if pressed[i][b] then
				scale = 1.5
			elseif released[i][b] then
				scale = 0.5
			end

			if love.joystick.isDown(i, b) or released[i][b] then
				local x, y, r = unpack(buttons[b])
				love.graphics.circle("fill", x, y, r*scale)
			end
		end
		for a=1,6 do
			if axes[a].func then
				axes[a].func(love.joystick.getAxis(i, a), axes[a][1], axes[a][2])
			end
		end

		local hat = love.joystick.getHat(i, 1)
		if hat ~= "" and love.joystick.isOpen(i) then
			love.graphics.circle("fill", hats[hat][1], hats[hat][2], 5)
		end
	end

	for i=1,4 do
		for b=1,12 do
			pressed[i][b] = false
			released[i][b] = false
		end
	end

end

function love.update(dt)
	if love.joystick.update then
		love.joystick.update()
	end
end

function love.joystickpressed( joystick, button )
	--print(button)
	pressed[joystick][button] = true
end

function love.joystickreleased( joystick, button )
	print("release "..tostring(button))
	released[joystick][button] = true
end

function love.mousepressed(x, y, btn)
	print(string.format("%d, %d", x, y))
end