Player = Object.extend(Object)

function Player.new(self, playerspeed, playerx, playery)
  self.playerspeed = playerspeed
  self.playerx = playerx
  self.playery = playery
  self.playerdx = 0
  self.playerdy = 0
end

function ipwc(self)
  -- is player wall colliding?
  local coll = false
  local coords = {self.playerx-3 ,self.playery-3 ,self.playerx+21 ,self.playery+21} -- check each player corner
  for i=1,4 do -- todo; add more points for the moving walls and add a crushing death
    local coord={coords[math.floor((i-1)%2)*2+1], coords[math.floor((i-1)/2)*2+2]- screenOffset} -- get coord for this i
    --print(((math.floor(coord[2]/cellSize))%24)+1 .. " " .. ((math.floor(coord[1]/cellSize))%32)+1) -- debug
    if level[1][1][1][((math.floor(coord[2]/cellSize))%24)+1][((math.floor(coord[1]/cellSize))%32)+1] == 1 then -- is there wall here
      coll = true -- we collidin today
    end
  end
  return coll
end

function ipwctv(self,way)
  -- send table of next player wall collisions
  local coll = {false, false, false, false}
  local coords = {self.playerx-3+self.playerdx ,self.playery-3+self.playerdy ,self.playerx+21+self.playerdx ,self.playery+21+self.playerdy} -- check each player corner
  local leeway = 12 -- wall slide sensitivity (bigger is less; 0 for whg3 wall sliding)
  if way[1] == 1 then
    coords[1] = coords[1] + leeway
  end
  if way[2] == 1 then
    coords[2] = coords[2] + leeway
  end
  if way[3] == 1 then
    coords[3] = coords[3] - leeway
  end
  if way[4] == 1 then
    coords[4] = coords[4] - leeway
  end
  for i=1,4 do -- todo; add more points for the moving walls and add a crushing death
    local coord={coords[math.floor((i-1)%2)*2+1], coords[math.floor((i-1)/2)*2+2]- screenOffset} -- get coord for this i
    --print(((math.floor(coord[2]/cellSize))%24)+1 .. " " .. ((math.floor(coord[1]/cellSize))%32)+1) -- debug
    if level[1][1][1][((math.floor(coord[2]/cellSize))%24)+1][((math.floor(coord[1]/cellSize))%32)+1] == 1 then -- is there wall here
      coll[i] = true -- we collidin today
    end
  end
  --print("endcoll")
  return coll
end

function ippwc(x,y)
  -- is point wall colliding?
  local coll = false
  if level[1][1][1][((math.floor((y - screenOffset)/cellSize))%24)+1][((math.floor(x/cellSize))%32)+1] == 1 then -- is there wall here
    coll = true -- we collidin today
  end
  return coll
end

function Player.update(self, dt)
  --print(ippwc(mousething.x,mousething.y))

  --for collision and ice, we need a dx and dy
  --if no ice, keep setting them to 0
  self.playerdx = 0
  self.playerdy = 0
  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    self.playerdx = self.playerdx + self.playerspeed * dt
  end
  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    self.playerdx = self.playerdx + self.playerspeed * dt * -1
  end
  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    self.playerdy = self.playerdy + self.playerspeed * dt * -1
  end
  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    self.playerdy = self.playerdy + self.playerspeed * dt
  end
  --check for collision
  if ipwc(self) then -- is it already colliding?
    --get out of my walls!!!
    --[[
    local i=32*24
    local t=1
    until i==0 or not ipwc(self) do
      for a=1,t*4 do

      end
    end
    --]]
  else -- not colliding yet; gotta move and check
    -- check each possible x wall slide (there are 4)
    if self.playerdy == 0 and not (self.playerdx == 0) then
      local function thing(way)
        local otherthing=ipwctv(self,way)
        return tostring(otherthing[1])..","..tostring(otherthing[2])..","..tostring(otherthing[3])..","..tostring(otherthing[4])
      end
      if self.playerdx > 0 and thing({1,0,0,1}) == "false,true,false,false" then -- down-right
        --print("down right x try")
        self.playerdy = self.playerdx
      end
      if self.playerdx > 0 and thing({1,1,0,0}) == "false,false,false,true" then -- up-right
        --print("up right x try")
        self.playerdy = self.playerdx * -1
      end
      if self.playerdx < 0 and thing({0,1,1,0}) == "false,false,true,false" then -- up-left
        --print("up left x try")
        self.playerdy = self.playerdx
      end
      if self.playerdx < 0 and thing({0,0,1,1}) == "true,false,false,false" then -- down-left
        --print("down left x try")
        self.playerdy = self.playerdx * -1
      end
    end
    -- check each possible y wall slide (there are 4)
    if self.playerdx == 0 and not (self.playerdy == 0) then
      local function thing(way)
        local otherthing=ipwctv(self,way)
        return tostring(otherthing[1])..","..tostring(otherthing[2])..","..tostring(otherthing[3])..","..tostring(otherthing[4])
      end
      if self.playerdy < 0 and thing({1,0,0,1}) == "false,true,false,false" then -- left-up
        --print("left up x try")
        self.playerdx = self.playerdy
      end
      if self.playerdy > 0 and thing({1,1,0,0}) == "false,false,false,true" then -- left-down
        --print("left down x try")
        self.playerdx = self.playerdy * -1
      end
      if self.playerdy > 0 and thing({0,1,1,0}) == "false,false,true,false" then -- right-down
        --print("right down x try")
        self.playerdx = self.playerdy
      end
      if self.playerdy < 0 and thing({0,0,1,1}) == "true,false,false,false" then -- right-up
        --print("right up x try")
        self.playerdx = self.playerdy * -1
      end
    end

    local fld={self.playerdx, self.playerdy} -- how much ground you have to cover
    while not (fld[1] == 0 and fld[2] == 0) do -- once all (possible) ground is covered stop checking
      if math.abs(fld[1]) > math.abs(fld[2]) then -- x movement/collision
        self.playerx = self.playerx + math.mid(fld[1], -1, 1) -- try moving
        if ipwc(self) then -- collided 1 px or less in the x direction?
          self.playerx = self.playerx - math.mid(fld[1], -1, 1) -- go back
          self.playerdx = self.playerdx - fld[1] -- set dx appropiately
          fld[1] = 0 -- no more x ground to cover
        else -- no collision yet
          fld[1] = fld[1] - math.mid(fld[1], -1, 1) -- less x ground to cover
        end
      else -- y movement/collision (favored)
        self.playery = self.playery + math.mid(fld[2], -1, 1) -- try moving
        if ipwc(self) then -- collided 1 px or less in the y direction?
          self.playery = self.playery - math.mid(fld[2], -1, 1) -- go back
          self.playerdy = self.playerdy - fld[2] -- set dy appropiately
          fld[2] = 0 -- no more y ground to cover
        else -- no collision yet
          fld[2] = fld[2] - math.mid(fld[2], -1, 1) -- less y ground to cover
        end
      end
    end
  end
  --print(ipwc(self))

  --note; if collisions are done like this for all objects (including floor/void) diagonals wont be possible; so do it

  --screen warp
  self.playerx = self.playerx % windowWidth
  self.playery = ((self.playery-screenOffset) % windowHeight) + screenOffset
end

function Player.draw(self)
  for x = -1, 1 do
    for y = -1, 1 do
      -- red fill
      love.graphics.setLineWidth(1)
      love.graphics.setColor(1, 0, 0, 1) 
      love.graphics.rectangle("fill", self.playerx + (x*windowWidth), self.playery + (y*windowHeight), 19,19)
      -- black outline
      love.graphics.setLineWidth(4)
      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.rectangle("line", self.playerx + (x*windowWidth), self.playery + (y*windowHeight), 18,18)
      -- reset for other graphics
      love.graphics.setLineWidth(1)
      love.graphics.setColor(0, 0, 0, 1)
    end
  end
end