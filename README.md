# Search and Rescue Drone Simulation
## Summary

This repo is software to simulate (and in the future, control) search and rescue drones. The intention is to connect the search & rescue pathfinding with ardupilot in future.

Currently, the simulation is 2D, with a top down view. **A gif of this simulation can be found in ExtraFiles/DroneAvoidance.gif**

Object detection software will be needed to identify lost souls from a camera feed, and possibly also a feed from a infra-red camera too. Software for this is yet to be implemented.

## Detailed Code Explanation
The 4 important matlab files are Drone.m, CentralControl.m, Main.m and PhysicialObject.m.

Drone and CentralControl and PhysicalObject are all classes. Drone inherits from PhysicalObject. It is possible that obstacles like trees and also search targets like people will be added as classes into the simulation - and they will inherit from PhysicalObject too.

Central Control designed to be ran on a central control station.

Main is the main loop which calls functions inside of Drone and CentralControl to update the scene.

The three classes are PhysicalObject, Drone, and CentralControl, designed to simulate the behavior of drones within a larger environment. Summary of each class:

PhysicalObject Class:
    This serves as a base class for objects in the simulation.
    It contains properties representing the object's position, velocity, and acceleration.
    The class includes a method to set the object's position.

Drone Class:
    Inherits from PhysicalObject and encapsulates the behavior of a drone.
    Properties include waypoint, mass, motor force, flight mode, panic mode, and escape direction.
    Constant properties define air resistance, wind speed, and safety area radius.
    Methods include calculating air and motor accelerations, updating velocity and position, plotting vectors, and managing safety parameters.

CentralControl Class:
    Orchestrates the behavior of drones in the simulation environment.
    Methods include finding escape direction for drones, signaling drones to flee from nearby neighbors, coordinating avoidance behavior, and identifying nearby drones.

### PhysicalObject

PhysicalObject serves as a base class for other objects in the simulation. It contains properties representing the object's position, velocity, and acceleration, each specified as a 2x1 vector with units of meters or meters per second.

The class also includes a constant property dt representing the time step used in the simulation.

The only method defined in this class is SetPosition, which allows setting the object's position to a new value.

Overall, this class provides a foundation for creating objects with physical properties in the simulation, allowing for manipulation of their position and providing a constant time step for simulation accuracy.

### Drone

Inherits behavior from PhysicalObject. The class contains methods to calculate acceleration from air resistance (CalculateAirAcceleration) and motor thrust (CalculateMotorAcceleration). It also includes methods for updating acceleration (UpdateAcceleration), velocity (UpdateVelocity), and position (Move). The DrawSafetyBubble method visualizes a safety area around the drone, and the PlotVector method helps visualize acceleration vectors.

Overall, the Drone class encapsulates the behavior of a drone, including its movement dynamics, response to external factors like wind, collision avoidance mechanisms, and navigation towards designated waypoints.

### Central Control

The CentralControl class provides functionality for managing drone interactions and implementing avoidance behavior to prevent collisions in a simulated environment.

FindEscapeDirection Method: This method calculates the direction in which a given drone should fly away if it's too close to other drones. It first identifies nearby drones using the FindNearbyDrones method, then computes the direction away from the center of mass of those nearby drones. If no nearby drones are found, it returns a zero vector.

MakeDroneRunFromNeighbors Method: This method signals to a drone that it must flee and in which direction it should flee. It calls FindEscapeDirection to determine the escape direction and sets the drone's panicMode and escapeDirection properties accordingly.

DronesAvoidance Method: This method orchestrates drone avoidance behavior. It iterates through all drones, calculates their positions, and then for each drone, determines the nearby drones using MakeDroneRunFromNeighbors and updates their panic mode and escape direction.

FindNearbyDrones Method: This method identifies nearby drones based on a predefined safety area radius. It iterates through the positions of other drones and checks if their distance from the given drone falls within the safety radius.

## Todo

Still uncertain is how to make the matlab code control the drones which are running ardupilot, once we move away from simulations towards real drones.

Path creator program takes in a last known location and generates waypoints. Still TODO is integrating this with the matlab simulation.
Path creator currently supports victor sierra currently. TODO More search patterns
