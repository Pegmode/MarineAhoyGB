startHeight = 0x88
gravity = 1
v = 0

outTable = []

#start bounce down
p = startHeight
while p > 0:
  outTable.append(p)
  v += gravity
  p = p - v

bounceTimes = 2
bounceForce = 10
p = 1

for i in range(bounceTimes):
  v = bounceForce
  while p > 0:
    outTable.append(p)
    p += v
    v = v - gravity
  bounceForce = bounceForce - 4
  p = 1
print("\n\n\n")
print(outTable)
for pos in outTable:
  print("${},".format(hex(pos)[2:].upper()),end = "")