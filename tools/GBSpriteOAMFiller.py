#sprite builder
startTile = 0xBA
xLen = 4
yLen = 5
metaX = 16
metaY = 80-12

ignoreTiles = [16,19]

numtiles = xLen*yLen

def buildSpriteString(x,y,tileNo):#no special flags
  return "db {}, {}, ${}, 0".format(y,x,hex(tileNo)[2:])

currentX = metaX
currentY = metaY
currentTile = startTile
for row in range(yLen):
  currentY = metaY+row*8
  for col in range(xLen):
    currentX = metaX+col*8
    #print("Row:{} Col:{} ".format(row,col))
    if row*xLen + col in ignoreTiles:
      print(buildSpriteString(currentX,currentY,0))
      continue
    print(buildSpriteString(currentX,currentY,currentTile))
    currentTile += 1
  currentX = metaX