function liftDistWing(UAV_D)
alpha = -16 : 1 : 16;
for i = 1 : 33
    UAV_D.plotWing3d_LiftDist('Wing',alpha(i));
end
end

