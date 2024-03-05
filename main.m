clear drones
droneQuantity = 4;
simulationTime = 30; % seconds
centralControl = CentralControl;
waypoints = [50,20,90,100 ; 20,40,100,10];

drones = {nan,nan,nan,nan}; % pre-allocate drones' cell array 
for index = 1:droneQuantity
    drones{index} = Drone;
    try
        drones{index}.SetWaypoint(waypoints(:,index));
    catch
        disp("Waypoints array not big enough")
    end
end

drones{1}.flightMode = "cruise";
drones{2}.flightMode = "cruise";

dt = PhysicalObject.dt;

for index = 0 : simulationTime / dt % main simulation loop ============
    realTimePassed = index*dt;
    hold on
    grid on
    xlim([0,120]);
    ylim([0,120]); 
    
    % Plot our waypoints
    for h = 1:length(waypoints)
        scatter(waypoints(1,h),waypoints(2,h));
    end    

    centralControl.DronesAvoidance(drones)

    for j = 1:droneQuantity
        drones{j}.Update()        
    end

    dronePositions = zeros(2,droneQuantity);
    for j = 1:droneQuantity
        dronePositions(:,j) = drones{j}.position;
    end

    scatter(dronePositions(1,:),dronePositions(2,:))   



    pause(dt);
    cla reset;
end


