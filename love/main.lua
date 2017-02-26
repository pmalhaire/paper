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

  --get the size of the window to move the character
  config.width, config.height = lg.getDimensions( )
  my_character = character.newCharacter("res/sample.png",8,config.width,config.height)
end

local dir
--local help = ""

function love.touchpressed(id, x, y)
  character.move_to_position(my_character,x,y)
end

function love.touchmoved(id, x, y)
  character.move_to_position(my_character,x,y)
end

function love.touchreleased()
    character.no_move(my_character)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    character.move_to_position(my_character,x,y)
  end
end

function love.mousemoved(x, y, button)
  if love.mouse.isDown(1) then
    character.move_to_position(my_character,x,y)
  end
end

function love.mousereleased()
    character.no_move(my_character)
end

local xdir = "left"
local lastkey = nil
function love.keypressed( key )
    lastkey = key
    if key == "right" then
      character.right(my_character)
      xdir = key
    elseif key == "left" then
      character.left(my_character)
      xdir = key
    elseif key == "up" then
      if xdir == "right" then
        character.up_right(my_character)
      else
        character.up_left(my_character)
      end
    elseif key == "down" then
      if xdir == "right" then
        character.down_right(my_character)
      else
        character.down_left(my_character)
      end
    end
end

function love.keyreleased( key )
  if key == lastkey then
    character.no_move(my_character)
  end
end

function love.update(dt)
  dtotal = dtotal + dt
  --change sequence every refresh time
  if dtotal > config.refresh_rate then
    character.move(my_character)
    dtotal = 0
  end
end

function love.draw()
  draw(my_character)
end
