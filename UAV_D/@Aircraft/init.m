function obj = init(obj)
% Foils
obj.assignAirfoils;

% Aerodynamics
obj.initwing;
obj.initht;
obj.initvt;

% Essentials
obj.Thrust = Thrust;
obj.Thrust.init;

obj.Fuselage = Fuselage;
obj.Fuselage.init;

obj.locateAero;

end

