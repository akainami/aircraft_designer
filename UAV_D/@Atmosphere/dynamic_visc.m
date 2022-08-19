function obj = dynamic_visc(obj)
b = 0.000001458;
T = obj.TEMPERATURE;
S = 110.4; % Sutherland Coeff
obj.DYNAMIC_VISCOSITY = (b*T^(3/2)) / (T+S);
end