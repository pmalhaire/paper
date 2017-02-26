local lg = love.graphics
local step_size = 30
local NO_MOVE, RIGHT, LEFT, UP, DOWN = 'n', 'r', 'l', 'u', 'd'

local function new(image_path,pose_count)
  --load character
  local character = {}
  character.image = love.graphics.newImage(image_path)
  character.pose_count = pose_count

  character.total_width = character.image:getWidth()
  character.total_height = character.image:getHeight()

  character.pose_height = character.image:getHeight()
  character.pose_width = character.image:getWidth() / character.pose_count

  character.sequence = {}

  character.pose_index = 0
  character.flipx = 1
  character.direction = NO_MOVE

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

  if character.direction == UP then
    character.posy = character.posy - character.pose_height/step_size
    if character.flipx == 1 then
      character.direction = RIGHT
    else
      character.direction = LEFT
    end
  elseif character.direction == DOWN then
    character.posy = character.posy + character.pose_height/step_size
    if character.flipx == 1 then
      character.direction = RIGHT
    else
      character.direction = LEFT
    end
  end

  if character.direction == RIGHT then
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
  elseif character.direction == LEFT then
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

local function _left(character)
    character.direction = LEFT
end

local function _right(character)
    character.direction = RIGHT
end

local function _up(character)
    character.direction = UP
end

local function _down(character)
    character.direction = DOWN
end

local function _no_move(character)
    character.direction = NO_MOVE
end

local character = {
    newCharacter = function(image_path,pose_count) return new(image_path,pose_count) end,
    move = function(character) return _move(character) end,
    left = function(character) return _left(character) end,
    right = function(character) return _right(character) end,
    up = function(character) return _up(character) end,
    down = function(character) return _down(character) end,
    no_move = function(character) return _no_move(character) end
}

return character
