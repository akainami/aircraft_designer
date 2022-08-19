classdef Atmosphere < handle
    properties
        ALTITUDE
        DENSITY_SL
        DENSITY
        TEMPERATURE_SL
        TEMPERATURE
        SPEEDSOUND
        PRESSURE_SL
        PRESSURE
        DELTAISA
        GRAVITY = 9.80665; % m/s2
        
        DYNAMIC_VISCOSITY
    end
end