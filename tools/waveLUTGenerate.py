
#User vars
START_INDEX = 0xD4 #animation start tile index
END_INDEX = 0xD9 #animation end tile index
FRAME_RATE = 10 #animation frame rate
EXTEND_ENDS = True #do we double frames for last and first tile?
EXTEND_MULT = 3
LOOP_Sentinal = 0 #value to use for to determine when to loop


def gbHexFormat(val):
    outval = hex(val)[2:]
    if len(outval) == 1:
        outval = "0"+outval
    return outval.upper()

def writeData(data):
    outString = ''
    outString += "DB "
    i = 0
    for val in data:
        if i == 15:
            outString += "${}\nDB ".format(gbHexFormat(val))
            i = 0
            continue
        outString += "${}, ".format(gbHexFormat(val))
        i += 1
    outString = outString[:-2]
    return outString

def addFrame(animTable,frameIndex):
    for i in range(FRAME_RATE):
        animTable.append(frameIndex)

def generateDirection(animTable,direction,beginIndex):
    animSize = END_INDEX - START_INDEX
    for i in range(animSize):
        currentFrame = beginIndex + i*direction
        if (EXTEND_ENDS) & (i == 0):
            for j in range(EXTEND_MULT):
                addFrame(animTable,currentFrame)
                continue
        addFrame(animTable,currentFrame)

def buildLUT():
    animTable = []
    generateDirection(animTable,1,START_INDEX)
    generateDirection(animTable,-1,END_INDEX)
    animTable.append(LOOP_Sentinal)
    return animTable



def main():
    animTable = buildLUT()
    outArray = writeData(animTable)
    print(outArray)
main()