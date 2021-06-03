import math

#y\ =\ 4\left(\sin\left(\frac{2\pi}{256}x\right)\right)\ +\ 5\sin\left(\left(\frac{2\pi}{128}\right)x\right)+134

lut = []

for i in range(256):
    st1 = 2*(math.sin((math.pi*2/256)*i))
    st2 = 5*math.sin((math.pi*2/128)*i)
    st3 = 20*math.sin((math.pi*2/(256*2))*i)
    y = st1+st2+st3+ 120

    lut.append(math.floor(y))


outstring = 'db '
i = 0
for val in lut:
    if i == 16:
        i = 0
        outstring += '{}\n db '.format(val)
        continue
    i+=1
    outstring += '{}, '.format(val)
outstring = outstring[:-2]
print(outstring)