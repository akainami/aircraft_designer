function obj = pressure(obj)
obj.PRESSURE_SL = 101325; % Pa
if obj.ALTITUDE <= 11000 % TROPOPAUSE
    obj.PRESSURE = obj.PRESSURE_SL*(1-0.0065*obj.ALTITUDE/obj.TEMPERATURE_SL)^5.2558797;
else
    error('ALTITUDE ABOVE TROPOPAUSE')
end
end