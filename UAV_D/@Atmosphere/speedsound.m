function obj = speedsound(obj)
K = 1.4; % For air
R = 287; % Ideal gas constant
obj.SPEEDSOUND = sqrt(K*R*obj.TEMPERATURE);
end