function obj = density(obj)
R = 287;
obj.DENSITY_SL = obj.PRESSURE_SL/obj.TEMPERATURE_SL/R; % kg/m3
obj.DENSITY = obj.PRESSURE/obj.TEMPERATURE/R;
end