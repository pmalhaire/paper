local lg = love.graphics

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
  
  for i=0, character.pose_count-1 do
    character.sequence[i] = lg.newQuad(i*character.pose_width, 0, character.pose_width, character.pose_height, character.total_width, character.total_height)
  end
  character.current_pose = character.sequence[character.pose_index]
  return character
end

local function _move(character,direction)
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

local character = {  
    newCharacter = function(image_path,pose_count) return new(image_path,pose_count) end,
    move = function(character,direction) return _move(character,direction) end
}

return character