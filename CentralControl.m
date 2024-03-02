classdef CentralControl
    % properties
    %     Property1
    % end

    methods
        % function obj = CentralControl(inputArg1)
            
        % end

        function [distancesMatrix] = CalculateDistancesMatrix(~, dronePositions) 
            % Returns a symmetric matrix which is NxN: N is the number of drones. 
            % Top left is distance between drone 1 and drone 1. 
            % Bottom left is distance between drone 4 and drone 1.
            distancesMatrix = NaN(size(dronePositions,2));
            
            for i = 1 : size(dronePositions,2)
                drone1Position = dronePositions(:,i);

                for j = 1 : size(dronePositions,2)
                    drone2Position = dronePositions(:,j);

                    drone1IsDrone2 = i == j;
                    if drone1IsDrone2 % if the 2 drones are the same, we can leave the distance as NaN
                        continue
                    end

                    vectorBetweenDrones = drone2Position - drone1Position;
                    distanceBetweenDrones = norm(vectorBetweenDrones);

                    distancesMatrix(i,j) = distanceBetweenDrones;
                end
            end
        end

        function DroneDangerClusters(obj,dronePositions) 
            % link drones into groups when they are too close to eachother. 
            % (Should usually happen with groups of 2!)
            distancesMatrix = CalculateDistancesMatrix(obj, dronePositions);

            allDronesSafe = min(distancesMatrix,[],"all") > Drone.safetyAreaRadius;

            if allDronesSafe
                return
            end

            for i = 1 : size(distancesMatrix)
                for j = 1 : size(distancesMatrix)
                    distanceBetweenDroneiandDronej = distancesMatrix(i,j);
                   
                    if isnan(distanceBetweenDroneiandDronej)
                        continue

                    elseif distanceBetweenDroneiandDronej < Drone.safetyAreaRadius

                        % TODO: link dronei and dronej together
                        
                    end

                end
            end

        end

    end
end