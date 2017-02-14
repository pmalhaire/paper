local lg = love.graphics
local character
local config = {refresh_rate=.07}
--keep delta time
local dtotal = 0

function newCharacter(image_path,pose_count)
  --load character
  character = {}
  character.image = love.graphics.newImage(image_path)
  character.pose_count = pose_count
  
  character.total_width = character.image:getWidth()
  character.total_height = character.image:getHeight()
  
  character.pose_height = character.image:getHeight()
  character.pose_width = character.image:getWidth() / character.pose_count
  
  character.sequence = {}
  
  character.pose_index = 0
  
  for i=0, character.pose_count-1 do
    character.sequence[i] = lg.newQuad(i*character.pose_width, 0, character.pose_width, character.pose_height, character.total_width, character.total_height)
  end
  character.current_pose = character.sequence[character.pose_index]
  return character
end

local function move(character,direction)
  if direction == "up" then
    character.posy = character.posy - character.pose_height/40
    if character.flipx == 1 then
      direction = "right"
    else
      direction = "left"
    end
  elseif direction == "down" then
    character.posy = character.posy + character.pose_height/40
    if character.flipx == 1 then
      direction = "right"
    else
      direction = "left"
    end
  end
  
  if direction == "right" then
    if character.flipx == 1 then
      character.pose_index = (character.pose_index + 1) % character.pose_count
      character.current_pose = character.sequence[character.pose_index]
      --move along the axis
      character.posx = character.posx + character.flipx * character.pose_width/character.pose_count
    else
      --in case of flip don't change position
      character.flipx = 1
      character.posx = character.posx - character.pose_width
    end
  elseif direction == "left" then
    if character.flipx == -1 then
      character.pose_index = (character.pose_index + 1) % character.pose_count
      character.current_pose = character.sequence[character.pose_index]
      --move along the axis
      character.posx = character.posx + character.flipx * character.pose_width/character.pose_count
    else
      --in case of flip don't change position
      character.flipx = -1
      character.posx = character.posx + character.pose_width
    end
  end
end

local function draw(character)
	lg.draw(character.image, character.current_pose, character.posx, character.posy, 0,character.flipx,1,character.flipx*character.pose_width/2,character.pose_height/2)
end

function love.load()
  --debug
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  character = newCharacter("res/sample.png",8)
  --get the size of the window to move the character
  config.width, config.height = lg.getDimensions( )
  character.flipx = 1
  character.posx = config.width/2
  character.posy = config.height/2
end

local dir

function love.touchmoved(id, x, y, dx, dy)
    if dy > 10 then
        dir = "up"
    elseif dy < 10 then
        dir = "down"
    elseif dx < 0 then
        dir = "left"
    elseif dx > 0 then
        dir = "right"
    end
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
      move(character, dir)
      dtotal = 0
    end
    --if we go out of the scren continue
    if  character.posx > config.width + character.pose_width - character.flipx * character.pose_width/2 then
      character.posx = 0
    elseif character.posx < -character.pose_width/2 then
      character.posx = config.width + character.pose_width
    end
    --if we go out of the scren continue
    if  character.posy > config.height - character.pose_height/2 then
      character.posy = config.height - character.pose_height/2
    elseif character.posy < character.pose_height/2 then
      character.posy = character.pose_height/2
    end
  end
end

function love.draw()
  draw(character)
end
