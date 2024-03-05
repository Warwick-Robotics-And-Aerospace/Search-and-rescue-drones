classdef Drone < PhysicalObject % drone inherits behavior from PhysicalObject

    properties (SetAccess = public)
        % instance variables
        waypoint (2,1) {mustBeNonNan} = [0,0]'; % metres
        mass (1,1) = 0.7; % kg        
        motorForce  = 4;
        flightMode string = "normal";
        panicMode (1,1) logical  = false;
        escapeDirection (2,1) {mustBeNonNan} = [0,0]';
    end

    properties (Constant)
        % class variables
        airResistanceConstant = 0.006; % Based on drag coefficient of 0.1, frontal area of 0.1 m^2
        windSpeed = [0,0]'; % m/s
        safetyAreaRadius = 10; % metres
    end

    methods
        function accelerationFromAir = CalculateAirAcceleration(obj)
            airSpeed = obj.velocity - obj.windSpeed;
            forceDueToAir = - norm(airSpeed) * airSpeed * obj.airResistanceConstant;
            accelerationFromAir = forceDueToAir / obj.mass;
        end



        function accelerationFromMotors = CalculateMotorAcceleration(obj)           


            vectorToWaypoint = obj.waypoint - obj.position;
            targetDirection = vectorToWaypoint / norm(vectorToWaypoint);
            distanceToWaypoint = norm(vectorToWaypoint);

            if obj.panicMode == true
                targetDirection = obj.escapeDirection;
                targetSpeed = 1000000000; % Drone should fly away as fast as it can
            elseif obj.flightMode == "normal"
                targetSpeed = abs(distanceToWaypoint)^0.8;
            elseif obj.flightMode == "cruise"
                targetSpeed = min(abs(distanceToWaypoint)^0.8, 10);                
            else
                disp("Flight mode error:")
                disp(obj.flightMode)
            end
            
            targetVelocity = targetDirection * targetSpeed;
            velocityChangeNeeded = - (obj.velocity - targetVelocity);

            motorPowerScaleDownFactor = min(abs(velocityChangeNeeded),1);
            forceDueToMotors = velocityChangeNeeded / norm(velocityChangeNeeded) * obj.motorForce .* motorPowerScaleDownFactor;

            accelerationFromMotors = forceDueToMotors / obj.mass;
        end

        function PlotVector(obj, coordinates)
            vectorScaleFactor = 3;

            x1 = obj.position(1,1);
            y1 = obj.position(2,1);

            coordinates = coordinates * vectorScaleFactor;
            x2 = coordinates(1,1) + x1;
            y2 = coordinates(2,1) + y1;

            plot([x1,x2],[y1,y2])
        end

        function UpdateAcceleration(obj)
            accelerationFromAir = obj.CalculateAirAcceleration();
            accelerationFromMotors = obj.CalculateMotorAcceleration();

            obj.PlotVector(accelerationFromMotors)
            
            obj.acceleration = accelerationFromAir + accelerationFromMotors;
        end
        function UpdateVelocity(obj)
            obj.UpdateAcceleration()
            obj.velocity = obj.velocity + obj.acceleration * obj.dt; % multiply by time step dt to make simulation independent of time step size
        end
        
        function DrawSafetyBubble(obj)
            x = linspace(obj.position(1)-obj.safetyAreaRadius, obj.position(1)+obj.safetyAreaRadius);
            plot([x], [obj.position(2) + sqrt(obj.safetyAreaRadius^2-((x-obj.position(1)).^2)) ; obj.position(2) - sqrt(obj.safetyAreaRadius^2-((x-obj.position(1)).^2))])
        end 

        function Move(obj)
            obj.UpdateVelocity()
            obj.position = obj.position + obj.velocity * obj.dt;  % multiply by time step dt to make simulation independent of time step size
        end

        function Update(obj)
            obj.Move()
            obj.DrawSafetyBubble()
        end

        function SetWaypoint(obj, waypoint)
            obj.waypoint = waypoint;
        end
    end
end




