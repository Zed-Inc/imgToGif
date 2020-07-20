import flippy
import strutils
import os as os

proc splitTgaToPng*(imagepath: string) =
  echo "splitting tga file"

  var mainImage: Image = loadImage(imagepath) 
  echo "tga image loaded"
  
  var w,h :int
  
  try:
    stdout.write("how many images are on the x axis: ")
    w = parseInt(stdin.readLine())
    stdout.write("how many images are on the y axis: ")
    h = parseInt(stdin.readLine())
  except ValueError:
    echo "Error, input was not a number"
    quit()

  var numImages = w*h
  echo "Number of seperate images: " & $numImages



  w = mainImage.width div w # get the width of a single image and reassign to w
  h = mainImage.height div h # get the height of a single image and reassign to h



  var littleImage: seq[Image]
  var x = 0; var y = 0

  for n in 0..<numImages:
    littleImage.add(getSubImage(mainImage,x,y,w,h))
    x += w
    if x >= mainImage.width:
      x = 0
      y += h
    if y >= mainImage.height:
      y = mainImage.height - h

  # save the images 
  os.createDir("splitTgaImages")
  os.setCurrentDir("splitTgaImages")
  var imgCount = 0
  for n in littleImage:
    save(n, os.getCurrentDir() & $imgCount & ".png")
    imgCount.inc()
  discard os.execShellCmd("cd ..")
  echo "image splitting done"
  

stdout.write("enter file path: ")
var path = stdin.readLine()

splitTgaToPng(path)