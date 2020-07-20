import flippy
import strutils
import os as os



#[
  This is a seperate tool to split a large single image into multiple smaller ones for gif animation 
  this is handy for sprite sheets when you want to see a quick animated sequence of what the character may look like
  in movement/ action
]#

proc splitToPngs*(imagepath: string) =


  var mainImage: Image = loadImage(imagepath) 
  echo "image loaded"
 
  var w,h :int
  # get info on image size
  try:
    stdout.write("how many images are on the x axis: ")
    w = parseInt(stdin.readLine())
    stdout.write("how many images are on the y axis: ")
    h = parseInt(stdin.readLine())
  except ValueError:
    echo "Error, input was not a number"
    quit()
  
  

  var numImages = w*h
  

  w = mainImage.width div w # get the width of a single image and reassign to w
  h = mainImage.height div h # get the height of a single image and reassign to h


  echo "splitting image file"

  var 
    littleImage: seq[Image]
    x = 0
    y = 0
    
  echo "w: " & $w  & ", h: " & $h
  echo "image width: " & $mainImage.width  & ", image height: " & $mainImage.height 
  echo "Number of seperate images: " & $numImages

  for n in 0..<numImages:
    littleImage.add(getSubImage(mainImage,x,y,w,h))
    x += w
    if x >= mainImage.width:
      x = 0
      y = y + h
      echo "x reached end" # DEBUG
    if y >= mainImage.height:
      y = mainImage.height - h
      echo "y reached end" # DEBUG
    echo "x: " & $x  & ", y: " & $y

  # save the images 
  os.createDir("splitImages")
  os.setCurrentDir("splitImages/")
  var imgCount = 0
  for n in littleImage:
    save(n, os.getCurrentDir() & $imgCount & ".png")
    imgCount.inc()
    # check for success
  assert os.execShellCmd("cd ..") == 0
  echo "image splitting done"
#------------>

echo "The following questions assume that each seperate image you want to split is an even square, not a rectangle"
echo "If you are unsure if your image can be seperated into squares press ctrl/cmd + c to exit"

# get image file path
stdout.write("enter file path: ")
var path = stdin.readLine()
splitToPngs(path)