cellSize  = 25 -- Width and height of cells.
gridLines = {}
leveldata = {}
windowWidth, windowHeight = 800,600
screenOffset = 50

fpstable = {}
avgfps = 0

local basemusic = love.audio.newSource("worlhargame.mp3", "stream")
local editmusic = love.audio.newSource("worlharedit.ogg", "stream")
editmusic:setVolume(0)

level = require("level-parsing")
require("level-parsing")

--------------------------------------- IMPORTANT CORE VARIABLES --------------------------------------

--either "playing" or "editing"
editMode = "playing"
--the font 
mainFont = love.graphics.newFont("Univers_Condensed.ttf", screenOffset - 16) -- 34

--------------------------------------- IMPORTANT CORE VARIABLES --------------------------------------

Object = require("classic")

success = love.window.setMode(windowWidth, windowHeight + (screenOffset*2), flags)

--- FUNCTIONS ---

function math.mid(x,y,z) -- flawed but who cares
  return math.min(math.max(x,y),z)
end

function splitstr(inputstr, sep)
   if sep == nil then
      sep = "%s"
   end
   local t={}
   for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
   end
   return t
end

-- test = splitstr("I,am,a,test", ",") -- Example

-- for _, v in ipairs(test) do print(v) end -- Example

-- Vertical lines.
for x = cellSize, 775, cellSize do
	local line = {x, screenOffset, x, windowHeight + screenOffset}
	table.insert(gridLines, line)
end
-- Horizontal lines.
for y = cellSize, 575, cellSize do
	local line = {0, y + screenOffset, windowWidth, y + screenOffset}
	table.insert(gridLines, line)
end

function love.load() -- Create callback
  --mouse init
  mousething = {x=0, y=0, dx=0, dy=0}

	love.audio.play( basemusic )
  love.audio.play( editmusic )
  require("player")
  gridx = 0; -- Level Parsing shit...
  gridy = 3; -- Level Parsing shit...
  player = Player(120, 400, 300)
end

function love.update(dt) -- Update callback
  -- editMode setting
  if love.keyboard.isDown("m") then
    editMode = "editing"
    editmusic:setVolume(1)
		basemusic:setVolume(0)
	end
  if love.keyboard.isDown("p") then
    editMode = "playing"
    editmusic:setVolume(0)
		basemusic:setVolume(1)
	end

  --teleport player
  if love.keyboard.isDown("t") then
    player.playerx = mousething.x - 10.5 --size of player /2
    player.playery = mousething.y - 10.5
  end

  wallx = cellSize*gridx
  wally = cellSize*gridy
  
  --edit map
  if editMode == "editing" then
    if mousething.y > screenOffset and mousething.y < windowHeight + screenOffset and mousething.x > 0 and mousething.x < windowWidth then
      if love.mouse.isDown(1) then
        level[1][1][1][math.floor((mousething.y - cellSize) / cellSize)][math.floor((mousething.x + cellSize) / cellSize)] = 1
      elseif love.mouse.isDown(2) then
        level[1][1][1][math.floor((mousething.y - cellSize) / cellSize)][math.floor((mousething.x + cellSize) / cellSize)] = 0
      end
    end
  end

   --update cube
  if editMode == "playing" then
    player.update(player, dt)
  end

  --fps
  table.insert(fpstable, 1/love.timer.getDelta())
  if #fpstable > 100 then
    table.remove(fpstable, 1)
  end
  avgfps = 0
  for i = 1,#fpstable do
    avgfps = avgfps + fpstable[i]
  end
  avgfps = avgfps / #fpstable

end

function love.draw() -- Draw callback
  ----floor fill
  --if editMode == "playing" then
    --colors
    --local col1 = love.math.colorFromBytes(245, 245, 255)
    --local col2 = love.math.colorFromBytes(212, 212, 255)
    for y=1,24 do
      for x=1,32 do
        if (x+y)%2 == 0 then
          --love.graphics.setColor(col1)
          love.graphics.setColor(love.math.colorFromBytes(245, 245, 255, editMode == "playing" and 255 or 127))
        else
          --love.graphics.setColor(col2)
          love.graphics.setColor(love.math.colorFromBytes(212, 212, 255, editMode == "playing" and 255 or 127))
        end
        love.graphics.rectangle("fill", (x - 1) * cellSize,(y + 1) * cellSize, cellSize,cellSize)
      end
    end
  --end
  
  --walls
  ----outline
  love.graphics.setColor(0,0,0)
  for y=1,24 do
    --outline thickness
    local otn = 2
    for x=1,32 do
      if level[1][1][1][y][x] == 1 then
        love.graphics.rectangle("fill", (x - 1) * cellSize - otn,(y + 1) * cellSize - otn, cellSize + (otn*2),cellSize + (otn*2))
      end
    end
  end
  ----fill
  love.graphics.setColor(love.math.colorFromBytes(171, 165, 255))
  for y=1,24 do
    for x=1,32 do
      if level[1][1][1][y][x] == 1 then
        love.graphics.rectangle("fill", (x - 1) * cellSize,(y + 1) * cellSize, cellSize,cellSize)
      end
    end
  end


  --grid
  if editMode == "editing" then
	  love.graphics.setLineWidth(2)
      love.graphics.setColor(0.75, 0.75, 0.75, 0.5)
	  for i, line in ipairs(gridLines) do
	  	love.graphics.line(line)
	  end
  end
  
  love.graphics.setBackgroundColor(0.5,0.5,0.5,1)
  
  player.draw(player)

  --HUD or UI or smth idk
  if editMode == "editing" then

  elseif editMode == "playing" then
    --top and bottom bars
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0,0 , windowWidth, screenOffset)
    love.graphics.rectangle("fill", 0,windowHeight + screenOffset , windowWidth,screenOffset)
	  --top text
    local deaths = 0 --to do: make global deaths variable
    local ccoins = 0 --and a coins collected variable
    local acoins = 10 -- so much to do
    love.graphics.setFont(mainFont)
    love.graphics.setColor(1, 1, 1, 1)
    local text = {"L1-A1", "Deaths: " .. deaths, "Coins: " .. ccoins .. "/" .. acoins}
	  love.graphics.print(text[1], 8, 8)
    love.graphics.print(text[2], windowWidth - 8 - mainFont:getWidth(text[2]), 8)
    love.graphics.print(text[3], (windowWidth - mainFont:getWidth(text[3]))/2, 8)
  end

  -- fps
  love.graphics.print(math.floor(avgfps + 0.5) .. " fps", 0, windowHeight + screenOffset + 16)
  --love.graphics.print(avgfps .. " fps", 0, windowHeight + screenOffset + 16)
  
  -- debug
  love.graphics.setColor(0, 0, 0, 1)
end

function love.mousepressed(mx, my, mbutton)
	if mbutton == 1 and mx >= player.playerx - 1 and mx < player.playerx+21 and my >= player.playery - 1 and my < player.playery+21 then
		love.audio.newSource("elephanthit.ogg", "static"):play()
  end
end

function love.mousemoved( x, y, dx, dy, istouch )
	mousething.x = x
	mousething.y = y
	mousething.dx = dx
	mousething.dy = dy
end