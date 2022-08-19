function obj = temperature(obj)
obj.TEMPERATURE_SL = 288.15 + obj.DELTAISA; % K
obj.TEMPERATURE = obj.TEMPERATURE_SL - 6.5 * obj.ALTITUDE / 1000;
end