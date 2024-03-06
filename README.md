# Search and Rescue Drones
### Summary

This repo is software to simulate (and in the future control) search and rescue drones. The intention is to connect the search & rescue pathfinding with ardupilot in future.

Object detection software will be needed to identify lost souls from a camera feed, and possibly also a feed from a infra-red camera too.

### Detailed Explanation
The 4 important matlab files are Drone.m, CentralControl.m, Main.m and PhysicialObject.m.

Drone and CentralControl and PhysicalObject are all classes.
Central Control is analagous to the ground control station.

Main is the main loop which calls functions inside of Drone and CentralControl to update the scene.

Path creator program takes in a last known location and generates waypoints. Still TODO is integrating this with the matlab simulation.
Path creator currently supports victor sierra currently. TODO More search patterns

### Todo

Still uncertain is how to make the matlab code control the drones which are running ardupilot, once we move away from simulations towards real drones.
