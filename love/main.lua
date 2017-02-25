local lg = love.graphics
local my_character
local config = {refresh_rate=.07}
--keep delta time
local dtotal = 0
local character = require ("character")
local touch_id



local function draw(character)
	lg.draw(character.image, character.current_pose, character.posx, character.posy, 0,character.flipx,1,character.flipx*character.pose_width/2,character.pose_height/2)
end

function love.load()
  --debug
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  my_character = character.newCharacter("res/sample.jpg")
  --get the size of the window to move the character
  config.width, config.height = lg.getDimensions( )
  my_character.flipx = 1
  my_character.posx = config.width/2
  my_character.posy = config.height/2
end

local dir
--local help = ""

function love.touchpressed(id, x, y)
    local cx = my_character.posx - x
    local cy = my_character.posy - y
    if cx > 10 and my_character.flipx > 0 then
        dir = "left"
    elseif cx < 10 and my_character.flipx < 0 then
        dir = "right"
    else
      --todo fix hard coded values
      if cy > 100 then
          dir = "up"
      elseif cy < -100 then
          dir = "down"
      elseif cx > 10 then
          dir = "left"
      elseif cx < 10 then
          dir = "right"
      end
    end
end

function love.touchmoved(id, x, y)
    local cx = my_character.posx - x
    local cy = my_character.posy - y

    if cx > 10 and my_character.flipx > 0 then
        dir = "left"
    elseif cx < 10 and my_character.flipx < 0 then
        dir = "right"
    else
      --todo fix hard coded values
      if cy > 100 then
          dir = "up"
      elseif cy < -100 then
          dir = "down"
      elseif cx > 10 then
          dir = "left"
      elseif cx < 10 then
          dir = "right"
      end
    end
end

function love.touchreleased()
    dir = nil
end

function love.mousepressed(id, x, y)
    local cx = my_character.posx - x
    local cy = my_character.posy - y
    if cx > 10 and my_character.flipx > 0 then
        dir = "left"
    elseif cx < 10 and my_character.flipx < 0 then
        dir = "right"
    else
      --todo fix hard coded values
      if cy > 100 then
          dir = "up"
      elseif cy < -100 then
          dir = "down"
      elseif cx > 10 then
          dir = "left"
      elseif cx < 10 then
          dir = "right"
      end
    end
end


function love.mousereleased()
    dir = nil
end

function love.keypressed( key )
    if key == "right" then
      dir = "right"
    elseif key == "left" then
      dir = "left"
    elseif key == "up" then
      dir = "up"
    elseif key == "down" then
      dir="down"
    end
end
 
function love.keyreleased( key )
    if key == "right" or key == "left" or key == "up" or key == "down" then
      dir=nil
    end
end

function love.update(dt)
  dtotal = dtotal + dt
  --change sequence every refresh time
  if dtotal > config.refresh_rate then
    if dir then
      character.move(my_character, dir)
      dtotal = 0
    end
    --if we go out of the scren continue
    if  my_character.posx > config.width + my_character.pose_width - my_character.flipx * my_character.pose_width/2 then
      my_character.posx = 0
    elseif my_character.posx < -my_character.pose_width/2 then
      my_character.posx = config.width + my_character.pose_width
    end
    --if we go out of the scren continue
    if  my_character.posy > config.height - my_character.pose_height/2 then
      my_character.posy = config.height - my_character.pose_height/2
    elseif my_character.posy < my_character.pose_height/2 then
      my_character.posy = my_character.pose_height/2
    end
  end
end

function love.draw()
  draw(my_character)
end
