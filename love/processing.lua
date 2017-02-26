--initialize the gradient
local init_gradient=100

function pixel_gradient( x, y, r, g, b, a )
   if r>0 and g>0 and b>0 then
     r=(y+init_gradient)%255
     g=y%255
     b=y%255
   end
   return r,g,b,a
end

function gradient( image)
  image:mapPixel(pixel_gradient)
end

function pixel_erode( threshold, image, x, y )
  local erode
  for xi=x-1, x+1 do
    for yi= y-1, y+1 do
      if yi >= 0 and yi < image:getHeight() and xi >= 0 and xi < image:getWidth() then
        local r, g, b, a = image:getPixel( xi , yi )
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
  local x
  local y
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
  local x
  local y
  local min = {255,255,255,255}
  local max = {0,0,0,0}
  for x = 0, image:getWidth()-1 do
      for y = 0, image:getHeight()-1 do
          local r, g, b, a = image:getPixel( x , y )
          min = {math.min(r,min[1]),math.min(g,min[2]),math.min(b,min[3]),math.min(a,min[4])}
          max = {math.max(r,max[1]),math.max(g,max[2]),math.max(b,max[3]),math.max(a,max[4])}
      end
  end
  return min, max
end

function compute_image( image )
  local min, max = get_range(image)
  local threshold = (min[1] + min[2] + min[3] + max[1] + max[2] + max[3])/6
  eroded_image = erosion(image, threshold)
  gradient(eroded_image)
  return love.graphics.newImage(eroded_image)
end