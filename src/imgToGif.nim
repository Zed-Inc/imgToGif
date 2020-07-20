const greeting_thing = """ 
_________ _______  _______               _       _______ _________ _______ 
\__   __/(       )(  ____ \             ( \     (  ____ \\__   __/(  ____ \
   ) (   | () () || (    \/              \ \    | (    \/   ) (   | (    \/
   | |   | || || || |         _____  _____\ \   | |         | |   | (__    
   | |   | |(_)| || | ____   (_____)(_____)) )  | | ____    | |   |  __)   
   | |   | |   | || | \_  )               / /   | | \_  )   | |   | (      
___) (___| )   ( || (___) |              / /    | (___) |___) (___| )      
\_______/|/     \|(_______)             (_/     (_______)\_______/|/       
                                                                           
"""

const helpFlagInfo = """ 
  <-- HELP -->
    when using the img -> gif program pass in only the path to a folder full of 'png' images
    make sure they are in the order you want them in because that is how they will be stitched together
  
  <-- USAGE -->
    imgToGif {path to folder} {some flags here}

  <-- FLAGS -->
    --help        |   gets you back to this screen 
    --loop        |   does the gif loop or does it just run through once, true or false 
    --loopCount   |   how many times you want the gof to loop, this is only valid if loop = true
    --outName     |   The name of the output gif, do not add the '.gif' extension onto it
  <-- EXAMPLE ->
    imgToGif sprites/ --loop:true --loopCount:10 --outName:spriteAnimation 
  """

const extension: string = ".gif"

# print proc, just syntax sugar for stdout.write()
proc print(str: string) =
  stdout.write(str)

# Imports
import gifwriter, flippy
import os
import strutils, times
#----------->



type
  GifInfo = object
    loop       : bool
    loop_count : int
    album_path : string
    output_name: string
    output_path: string # this will just be the same path as the input album path
    # len        : float 



# Forward declarations
proc main()
proc getImgs(path:string): seq[Image]
proc getInfoRaw(gif: var GifInfo)
proc parseParams(gif: var GifInfo, params: seq[string])
#--------->

# start program
when isMainModule:
  main()
# ------------>


proc main() = 
  var
    info: GifInfo
    images: seq[Image]
  # some default initalization, these options will be over written in the param parsing or info getting
  info.loop = false; info.loop_count = 1; info.output_name = $now()
  echo greeting_thing & "\n"

  if commandLineParams().len == 0:
    echo "No params passed in...getting info"
    getInfoRaw(info)
  elif commandLineParams()[0] == "--help":
    echo helpFlagInfo
    quit()
  else:
    parseParams(info, commandLineParams())

  images = getImgs(info.album_path)

  var gif = newGif(info.output_name & extension, 128,128, fps = 24)
  var loopIteration: int = 0

  while true:
    for n in images: 
      gif.write(n.data) # write image data to the gif 
    loopIteration.inc()
    # check if the gif should be looping and that the loop iteration is correct
    if info.loop == true and loopIteration == info.loop_count:
      break
    elif info.loop_count == loopIteration:
      break
    
    # close the gif
  gif.close()
  echo "...Done..."

  


# get some nice RAW info on the gif
proc getInfoRaw(gif: var GifInfo) =
  print("Album path: ")
  gif.album_path = readLine(stdin)

  print("Output name: ")
  gif.output_name = readLine(stdin)
  
  print("Loop? [Y/n]: ")
  var temp = readLine(stdin)
  if temp == " " or temp.toLower() == "y":
    gif.loop = true
  elif temp.toLower == "n":
    gif.loop = false
  else:
    print("Error answer was neither y/n, gif will not loop")
    gif.loop = false
  
  if gif.loop:
    print("Loop Count: ")
    gif.loop_count = parseInt(readLine(stdin))

# parse our parameters
proc parseParams(gif: var GifInfo, params: seq[string]) =
  echo "params parsing: " & $params # DEBUG
  gif.album_path = params[0] # the first parameter will always be the path to the album
  for param in params[1..<params.len]:
    if param.contains("--loop"):
      gif.loop = parseBool(param.split(":")[1])
    elif param.contains("--loopCount"):
      gif.loop_count = parseInt(param.split(":")[1])
    elif param.contains("--outName"):
      gif.output_name = param.split(":")[1]
    

# load all the images from the folder into a sequence
proc getImgs(path: string): seq[Image] =
  var imgNames: seq[string]
  echo "getting images"
  # svae our current directory
  var currDir = os.getCurrentDir()
  # shift to the fdirectory storing our images
  os.setCurrentDir(path)
  for img in walkFiles("*.png"):
    echo img # DEBUG 
    imgNames.add(img)
    
  echo "loading images" # DEBUG
  # load in the images
  for img in imgNames:
    result.add(loadImage(path & img))

  # go back to our original directory
  os.setCurrentDir(currDir)


