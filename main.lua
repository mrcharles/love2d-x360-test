love.joystick = require('XInputLUA')
xpad = require('XPad')
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
	a = {476, 228, 20},
	b = {528, 188, 20},
	x = {429, 189, 20},
	y = {482, 147, 20},
	lt = {143, 24, 10},
	rt = {462, 24, 10},
	lb = {104, 77, 10},
	rb = {500, 77, 10},
	ls = {117, 212, 10},
	rs = {385, 300, 10},
	back = {234, 192, 10},
	start = {365, 192, 10},

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


local buttonnames = {
	"a",
	"b",
	"x",
	"y",
	"lt",
	"rt",
	"lb",
	"rb",
	"ls",
	"rs",
	"back",
	"start",
}

local axisnames = {
	"leftx",
	"lefty",
	"rightx",
	"righty",
	"lefttrigger",
	"righttrigger",
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
	leftx = {
		{118, 210},
		func = drawXAxis
	},
	lefty = {
		{118, 210},
		func = drawYAxis
	},
	rightx = {
		{384, 301},
		func = drawXAxis
	},
	righty = {
		{384, 301},
		func = drawYAxis
	},
	lefttrigger = {
		{170, 14},
		{170, 58},
		func = drawTriggerAxis
	},
	righttrigger = {
		{430, 14},
		{430, 58},
		func = drawTriggerAxis
	},
}

local pads = {}

local buttonconfig = {
	jump = "a",
	action = "b",
	inventory = "x",
	walk = "leftx",
	pan = "righty",
}

local usealiases = false

function love.load()
	padimg = love.graphics.newImage("xboxpad.png")
	xpad:init(love.joystick)
	xpad:setButtonConfig(buttonconfig)

	if love.joystick.update then
		love.joystick.update()
	end

	for i=1,love.joystick.getNumJoysticks() do
		print("adding joystick ")
		table.insert(pads, xpad:newplayer())
	end
end

local realnames = true

function drawbuttonstate(pad, b)

end

function love.draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(padimg, 0, 0)

	local buttonlabels = buttonnames
	local axislabels = axisnames 
	local usealias = false

	if usealiases then
		buttonlabels = buttonconfig
		axislabels = buttonconfig
		usealias = true
	end

	--love.graphics.setColorMode("replace")
	for i,pad in ipairs(pads) do
		love.graphics.setColor(unpack(colors[i]))
		love.graphics.print( pad:getName(), 11, 10 * i)
		love.graphics.circle("fill", controllers[i][1], controllers[i][2], 4)

		for alias,button in pairs(buttonlabels) do
			local b = button
			if usealias then
				b = alias
			end
			if buttons[button] then
				local scale = 1
				local draw = false
				if pad:justPressed(b) then
					scale = 1.5
					draw = true
				elseif pad:justReleased(b) then
					scale = 0.5
					draw = true
				elseif pad:pressed(b) then
					draw = true
				end

				if draw then
					local x, y, r = unpack(buttons[button])
					love.graphics.circle("fill", x, y, r*scale)
				end
			end
		end

		for alias, axis in pairs(axislabels) do
			local a = axis
			if usealias then
				a = alias
			end
			if axes[axis] then
				if axes[axis].func then
					axes[axis].func(pad:getAxis(a), axes[axis][1], axes[axis][2])
				end
			end
		end

		local hat = pad:getDPad()
		if hat ~= "" and love.joystick.isOpen(i) then
			love.graphics.circle("fill", hats[hat][1], hats[hat][2], 5)
		end

		lt = pad:getAxis(axisnames[5])
		rt = pad:getAxis(axisnames[6])

		pad:setRumble(lt)
		pad:setVibrate(rt)
	end

	-- for i=1,4 do
	-- 	for b=1,12 do
	-- 		pressed[i][b] = false
	-- 		released[i][b] = false
	-- 	end
	-- end

end

function love.update(dt)
	if love.joystick.update then
		love.joystick.update()
	end
	xpad:update()
end

function love.joystickpressed( joystick, button )
	--print(button)
	--pressed[joystick][button] = true
end

function love.joystickreleased( joystick, button )
	--print("release "..tostring(button))
	--released[joystick][button] = true
end

function love.keyreleased(k)
	if k == " " then
		usealiases = not usealiases
	end
end

function love.mousepressed(x, y, btn)
	print(string.format("%d, %d", x, y))
end