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
  my_character = character.newCharacter("res/sample.png",8)
  --get the size of the window to move the character
  config.width, config.height = lg.getDimensions( )
  my_character.posx = config.width/2
  my_character.posy = config.height/2
end

local dir
--local help = ""

function love.touchpressed(id, x, y)
    local cx = my_character.posx - x
    local cy = my_character.posy - y
    if cx > 10 and my_character.flipx > 0 then
        character.left(my_character)
    elseif cx < 10 and my_character.flipx < 0 then
        character.right(my_character)
    else
      --todo fix hard coded values
      if cy > 100 then
          character.up(my_character)
      elseif cy < -100 then
          character.down(my_character)
      elseif cx > 10 then
          character.left(my_character)
      elseif cx < 10 then
          character.right(my_character)
      end
    end
end

function love.touchmoved(id, x, y)
    local cx = my_character.posx - x
    local cy = my_character.posy - y

    if cx > 10 and my_character.flipx > 0 then
        character.left(my_character)
    elseif cx < 10 and my_character.flipx < 0 then
        character.right(my_character)
    else
      --todo fix hard coded values
      if cy > 100 then
          character.up(my_character)
      elseif cy < -100 then
          character.down(my_character)
      elseif cx > 10 then
          character.left(my_character)
      elseif cx < 10 then
          character.right(my_character)
      end
    end
end

function love.touchreleased()
    character.no_move(my_character)
end

function love.mousepressed(id, x, y)
    local cx = my_character.posx - x
    local cy = my_character.posy - y
    if cx > 10 and my_character.flipx > 0 then
        character.left(my_character)
    elseif cx < 10 and my_character.flipx < 0 then
        character.right(my_character)
    else
      --todo fix hard coded values
      if cy > 100 then
          character.up(my_character)
      elseif cy < -100 then
          character.down(my_character)
      elseif cx > 10 then
          character.left(my_character)
      elseif cx < 10 then
          character.right(my_character)
      end
    end
end


function love.mousereleased()
    character.no_move(my_character)
end

function love.keypressed( key )
    if key == "right" then
      character.right(my_character)
    elseif key == "left" then
      character.left(my_character)
    elseif key == "up" then
      character.up(my_character)
    elseif key == "down" then
      character.down(my_character)
    end
end

function love.keyreleased( key )
  character.no_move(my_character)
end

function love.update(dt)
  dtotal = dtotal + dt
  --change sequence every refresh time
  if dtotal > config.refresh_rate then
    character.move(my_character)
    dtotal = 0
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
