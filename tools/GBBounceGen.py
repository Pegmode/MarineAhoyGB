# pushV = 8
# p = pushV
# v = pushV
# g = -1
# isSprite = True
# spriteStart = 80#change this to suit your situtation


pushV = 8
p = pushV
v = pushV
g = -1


isSprite = True
spriteStart = 68#change this to suit your situtation
positions = []


while p >= 0:
  if isSprite:
    positions.append(hex(spriteStart-p)[2:].upper())
  else:
    positions.append(hex(p)[2:].upper())
  v += g
  p += v

print("bounceTable:")
for pos in positions:
  print("${},".format(pos),end='')