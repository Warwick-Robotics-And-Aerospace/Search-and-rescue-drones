drones = {0,0,0} % cell array

for i = 1:3
    drones{i} = Drone;
end

disp(drones{1}.position)