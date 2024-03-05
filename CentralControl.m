classdef CentralControl
    % properties
    %     Property1
    % end

    methods
        % function obj = CentralControl(inputArg1)
            
        % end
        
% ========= this entire function is not actually helpful so i've commented it just incase =========

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

        function vectorToEscape = findEscapeDirection(obj,drone,dronePositions) 
        % find the direction that a given drone should fly away if it's too
        % close to another drone(s).

            positionsOfdronesWhichAreTooClose = [];

            for i = 1 : size(dronePositions,2)
                droneiPosition = dronePositions(:,i);
            
                if drone.position == droneiPosition
                    continue
                
                elseif norm(drone.position - droneiPosition) < Drone.safetyAreaRadius                    
                    positionsOfdronesWhichAreTooClose = [positionsOfdronesWhichAreTooClose , droneiPosition];
                end    
            end

            ourDroneIsSafe = size(positionsOfdronesWhichAreTooClose,2) == 0;
            if ourDroneIsSafe
                vectorToEscape = NaN
                return
            end

            centerOfMass = sum(positionsOfdronesWhichAreTooClose, 2) / size(positionsOfdronesWhichAreTooClose,2);

            vectorToEscape = drone.position - centerOfMass;
            return

        end
        

    end
end