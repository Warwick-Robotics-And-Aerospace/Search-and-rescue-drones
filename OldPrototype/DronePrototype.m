classdef Drone < PhysicalObject

    properties % Variables for individual drone
        waypoint = [0,0]';             
    end

    properties(Constant) % Variables for entire swarm
        airResistanceConstant = 0.006; % kg/m
        droneMass = 1; % kg
    end

    methods
        function obj = Drone % constructor function
            disp("Drone created")
            disp(obj)
        end

        function headToWaypoint(obj)
            obj.velocity = obj.waypoint / norm(obj.waypoint);
        end
    end
end