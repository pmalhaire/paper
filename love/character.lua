local processing = require ("processing")
local lg = love.graphics
local step_size = 30
local NO_MOVE, RIGHT, LEFT, UP, DOWN, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT = 'n', 'r', 'l', 'u', 'd', 'ur', 'ul', 'dl', 'dr'

local function new(image_path, pose_count, area_width, area_height)
  --load character
  local character = {}
  local img = love.image.newImageData(image_path)
  local image = compute_image(img)
  character.image = image
  character.pose_count = pose_count

  character.total_width = character.image:getWidth()
  character.total_height = character.image:getHeight()

  character.pose_height = character.image:getHeight()
  character.pose_width = character.image:getWidth() / character.pose_count

  character.sequence = {}

  character.pose_index = 0
  character.flipx = 1
  character.direction = NO_MOVE
  character.area_width = area_width
  character.area_height = area_height
  --draw the character in the middle
  character.posx = area_width/2
  character.posy = area_height/2

  for i=0, character.pose_count-1 do
    character.sequence[i] = lg.newQuad(i*character.pose_width, 0, character.pose_width, character.pose_height, character.total_width, character.total_height)
  end
  character.current_pose = character.sequence[character.pose_index]
  return character
end

local function _move(character)
  if character.direction == NO_MOVE then
    return
  end

  if character.direction == UP_LEFT or character.direction == UP_RIGHT then
    character.posy = character.posy - character.pose_height/step_size
  elseif character.direction == DOWN_LEFT or character.direction == DOWN_RIGHT  then
    character.posy = character.posy + character.pose_height/step_size
  end

  if character.direction == RIGHT or character.direction == UP_RIGHT or character.direction == DOWN_RIGHT then
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
  elseif character.direction == LEFT or character.direction == UP_LEFT or character.direction == DOWN_LEFT then
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

      --if we go out of the scren continue
  if  character.posx > character.area_width + character.pose_width - character.flipx * character.pose_width/2 then
    character.posx = 0
  elseif character.posx < -character.pose_width/2 then
    character.posx = character.area_width + character.pose_width
  end
  --if we go out of the scren continue
  if  character.posy > character.area_height - character.pose_height/2 then
    character.posy = character.area_height - character.pose_height/2
  elseif character.posy < character.pose_height/2 then
    character.posy = character.pose_height/2
  end
end

local function _left(character)
    character.direction = LEFT
end

local function _right(character)
    character.direction = RIGHT
end

local function _up_right(character)
    character.direction = UP_RIGHT
end

local function _up_left(character)
    character.direction = UP_LEFT
end

local function _down_right(character)
    character.direction = DOWN_RIGHT
end

local function _down_left(character)
    character.direction = DOWN_LEFT
end

local function _no_move(character)
    character.direction = NO_MOVE
end

local function _move_to_position(character,x,y)
  local cx = character.posx - x
  local cy = character.posy - y
  local xdir, ydir

  if cx < 0 then
    xdir = RIGHT
  else
    xdir = LEFT
  end

  if cy > character.pose_height/8 then
    ydir = UP
  elseif cy < -character.pose_height/8 then
    ydir = DOWN
  end

  if ydir == UP then
    if xdir == RIGHT then
      character.direction = UP_RIGHT
    else
      character.direction = UP_LEFT
    end
  elseif ydir == DOWN then
    if xdir == RIGHT then
      character.direction = DOWN_RIGHT
    else
      character.direction = DOWN_LEFT
    end
  else
    character.direction = xdir
  end
end

local character = {
    newCharacter = function(image_path,pose_count,area_width,area_height) return new(image_path, pose_count, area_width, area_height) end,
    move = function(character) return _move(character) end,
    left = function(character) return _left(character) end,
    right = function(character) return _right(character) end,
    up_left = function(character) return _up_left(character) end,
    up_right = function(character) return _up_right(character) end,
    down_left = function(character) return _down_left(character) end,
    down_right = function(character) return _down_right(character) end,
    no_move = function(character) return _no_move(character) end,
    move_to_position = function(character,x,y) return _move_to_position(character,x,y) end
}

return character
