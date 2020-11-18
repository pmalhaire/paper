math.randomseed( os.time() )

local init_g = .5 * math.random()
local init_b = .5 * math.random()

local y_ratio


local factor_contrast
local factor_bightness

function apply_contrast_brightness(val)
    local res = factor_contrast * (val   - 128) + 128 + factor_bightness
    if res > 255 then
      return 255
    elseif res < 0 then
      return 0
    else
      return res
    end
end

function pixel_contrast_brightness( _, _, r, g, b, a )
  r = apply_contrast_brightness(r)
  g = apply_contrast_brightness(g)
  b = apply_contrast_brightness(b)
   return r,g,b,a
end


function set_contrast_brightness(image_data, contrast, brightness)
  factor_contrast = (259 * (contrast + 255)) / (255 * (259 - contrast))
  factor_bightness = brightness
  image_data:mapPixel(pixel_contrast_brightness)
end

function pixel_gradient( _, y, r, g, b, a )
   if r>0 and g>0 and b>0 then
     r=y*y_ratio
     g=init_g
     b=init_b
   end
   return r,g,b,a
end

function gradient( image)
  image:mapPixel(pixel_gradient)
end

function pixel_erode( threshold, image, x, y )
  for xi=x-1, x+1 do
    for yi= y-1, y+1 do
      if yi >= 0 and yi < image:getHeight() and xi >= 0 and xi < image:getWidth() then
        local r, g, b = image:getPixel( xi , yi )
        if r < threshold or g < threshold or b <threshold then
          --keep if it's close to black
           return false
        end
      end
    end
  end
  --filter out white
  return true
end

function erosion( image, threshold )
  local eroded_image = love.image.newImageData(image:getWidth(),image:getHeight())
  for x = 0, image:getWidth()-1 do
      for y = 0, image:getHeight()-1 do
          if pixel_erode(threshold, image, x,y) then
            eroded_image:setPixel( x, y, 0, 0, 0, 0)
          else
            local r, g, b = image:getPixel( x , y )
            eroded_image:setPixel( x, y, r, g, b,255)
          end
      end
  end
  return eroded_image
end

function get_range( image )
  local min = {255,255,255}
  local max = {0,0,0}
  local h, w = image:getHeight()-1, image:getWidth()-1
  for x = 0, w do
      for y = 0, h do
          local r, g, b = image:getPixel( x , y )
          min[1] = math.min(r,min[1])
          min[2] = math.min(g,min[2])
          min[3] = math.min(b,min[3])
          max[1] = math.max(r,max[1])
          max[2] = math.max(g,max[2])
          max[3] = math.max(b,max[3])
      end
  end
  return min, max
end

function compute_image( image )
  local min, max = get_range(image)
  local bright_factor = 255 - math.max(max[1], max[2], max[3])
  local contrast_factor = math.min(min[1], min[2], min[3])
  local threshold = (min[1] + min[2] + min[3] + max[1] + max[2] + max[3])/6
  if contrast_factor ~= 0 then
    --todo fix this
    --set_contrast_brightness(image,contrast_factor, bright_factor)
  end
  local eroded_image = erosion(image, threshold)
  y_ratio = 1/image:getHeight()
  gradient(eroded_image)
  return love.graphics.newImage(eroded_image)
end
