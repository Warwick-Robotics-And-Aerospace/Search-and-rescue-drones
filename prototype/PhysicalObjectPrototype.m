classdef PhysicalObject < handle

    properties
        position = [0,0]';
        velocity = [0,0]';
        acceleration = [0,0]';
    end

    properties (Constant)
        dt = 0.01; % time step
    end


    methods
        function SetPosition(obj, position)
            obj.position = position;
        end
    end
end