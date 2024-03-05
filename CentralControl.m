classdef CentralControl
    % properties
    %     Property1
    % end

    methods
        % function obj = CentralControl(inputArg1)
            
        % end

% ========= this entire function is not actually helpful so i've commented it just incase its handy to copy from =========

        % function [distancesMatrix] = CalculateDistancesMatrix(~, dronePositions) 
        %     % Returns a symmetric matrix which is NxN: N is the number of drones. 
        %     % Top left is distance between drone 1 and drone 1. 
        %     % Bottom left is distance between drone N and drone 1.
        %     distancesMatrix = NaN(size(dronePositions,2));
        % 
        %     for i = 1 : size(dronePositions,2)
        %         droneiPosition = dronePositions(:,i);
        % 
        %         for j = 1 : size(dronePositions,2)
        %             dronejPosition = dronePositions(:,j);
        % 
        %             droneiIsDronej = i == j;
        %             if droneiIsDronej % if the 2 drones are the same, we can leave the distance as NaN
        %                 continue
        %             end
        % 
        %             vectorBetweenDrones = dronejPosition - droneiPosition;
        %             distanceBetweenDrones = norm(vectorBetweenDrones);
        % 
        %             distancesMatrix(i,j) = distanceBetweenDrones;
        %         end
        %     end
        % end

        function vectorToEscape = FindEscapeDirection(obj,drone,otherDronePositions) 
        % find the direction that a given drone should fly away if it's too
        % close to another drone(s).

            posOfdronesTooClose =  obj.FindNearbyDrones(drone,otherDronePositions);

            if isempty(posOfdronesTooClose)
                vectorToEscape = [0,0]';
                return
            end

            centerOfMass = sum(posOfdronesTooClose, 2) / size(posOfdronesTooClose,2);          

            vectorToEscape = drone.position - centerOfMass;
            
            if vectorToEscape == 0
                vectorToEscape = rand(2,1);
            end

            vectorToEscape = vectorToEscape  / norm(vectorToEscape);
            return

        end

        function MakeDroneRunFromNeighbors(obj,drone,otherDronePositions)
            % signal to a drone that it must flee , and in which direction

            vectorToEscape = obj.FindEscapeDirection(drone,otherDronePositions);

            droneIsInDanger = all( vectorToEscape ~= 0 ); 
            drone.panicMode = droneIsInDanger;                   
            drone.escapeDirection = vectorToEscape;

        end

        function DronesAvoidance(obj,drones)
            droneQuantity = length(drones);

            dronePositions = zeros(2,droneQuantity);
            for j = 1:droneQuantity
                dronePositions(:,j) = drones{j}.position;
            end

            for z = 1:droneQuantity
                dronePositionsWithoutZ = dronePositions;
                dronePositionsWithoutZ(:,z) = [];
                obj.MakeDroneRunFromNeighbors(drones{z},dronePositionsWithoutZ);    
            end

        end

        function nearbyDrones = FindNearbyDrones(~,drone,otherDronePositions)
            nearbyDrones = [];
            for i = 1 : size(otherDronePositions,2)
                droneiPosition = otherDronePositions(:,i);        
                if norm(drone.position - droneiPosition) < Drone.safetyAreaRadius                    
                    nearbyDrones = [nearbyDrones , droneiPosition]; %#ok<AGROW>
                end    
            end
        end

    end

end