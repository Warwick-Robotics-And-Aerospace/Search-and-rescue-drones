import math
#This can be used to visualise the thing later however I have completly forgot how to get matplotlib
#import matplotlib.pyplot as plot
#This can be improved by calcualting drift on the fly but that is proabbly too difficult for me not to mention I don't know how to do that.

#Not yet implemented offsetting the angle by 30 degrees for another drone.
nDrones = float(input("Number of drones :"))
#areaWidth = float(input("What is the width of the area?"))
#areaLength = float(input("What is the length of the area")) Both not currently needed

driftSpeed = float(input("Drift speed of the target in ms^-1 :"))
driftAngle = float(input("What is the drift angle of the target in degrees :"))#Do not say 0
droneSpeed = float(input("What is the drone speed"))
legTime = float(input("How long should each leg take"))

print("Search Planner")
#need to, using the speed of drift and direction of drift, 
#You go first 2 on compass heading, then you come back towards the datum position after its drifted.
def victorSierra(droneSpeed,driftSpeed,driftAngle,legTime): #Creates a path using sector search method used by the US and Canadian coastguards
    theta = [2*math.pi/6*i+driftAngle/180*math.pi for i in range (6)] #Calculates the angles of each sector 
   #Finds the horizontal and verticle velocity for each leg.
    velocityX = [droneSpeed/legTime*math.cos(thetai) for (thetai) in theta]
    velocityY = [droneSpeed/legTime*math.sin(thetai) for (thetai) in theta]  
    #Finds the horiziontal and verticle components of the drift speed after converting the drift angle to radians
    if math.cos(driftAngle/180*math.pi) == 0:
        driftX = 0
    else:
        driftX = driftSpeed/math.cos(driftAngle/180*math.pi)
    #if driftAngle=0 driftY = 0 Same of others !!!!, change to consider the trig value not the angle value.
    if math.sin(driftAngle/180*math.pi) == 0:
        driftY = 0
    else:
        driftY = driftSpeed/math.sin(driftAngle/180*math.pi)
    #Creates the forces for each direction
    forceX = [driftX*i for i in range (1,7)]
    forceY = [driftY*i for i in range (1,7)]
    #These are the positions after they have been shifted by the water drift.
    waterPositionX = [velocityX[i] + forceX[i] for i in range (0,6)]
    waterPositionY = [velocityY[i] + forceY[i] for i in range (0,6)]

    runPositionsX = [0, waterPositionX[0], waterPositionX[1], driftX*3, waterPositionX[4],waterPositionX[5],driftX*6,waterPositionX[2],waterPositionX[3],driftX*9]
    runPositionsY = [0, waterPositionY[0], waterPositionY[1], driftY*3, waterPositionY[4],waterPositionY[5],driftY*6,waterPositionY[2],waterPositionY[3],driftY*9]
    #returns all the results
    print(" Drone speed = %g (ms^-1) at %g deg " % (droneSpeed,driftAngle))
    print(" Drift Speed = %g (ms^-1) at %g deg " % (driftSpeed,driftAngle))
    print(" Drone waypoints x,y")
    #Prints all the waypoints
    for i in range(len(runPositionsX)):
        print (" [ %0.3f, %0.3f] " % (runPositionsX[i],runPositionsY[i]))

#Calls victor Sierra, later this will be changed as we add more funcitons
victorSierra(droneSpeed,driftSpeed,driftAngle,legTime)