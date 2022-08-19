function DesignParameters = desiredDesign(env)
% Import config data
fid = fopen(strcat('+source/Data/DesignParameters.dat'));
rawdata = textscan(fid,'%s %s');
fclose(fid);
key = rawdata{1};
vals = rawdata{2};
param = containers.Map;
for i = 1 : length(key)
    param(key{i}) = str2double(vals(i));
end

DesignParameters = struct();
DesignParameters.mass                 = param('mass'); % kg
DesignParameters.wingspan             = param('wingspan'); % m
DesignParameters.max_speed            = param('max_speed'); % TAS, m/s
range                                 = param('range'); % Precision
DesignParameters.aspect_ratio         = param('aspect_ratio'); % -
DesignParameters.load_factor_max      = param('load_factor_max'); % Structural
DesignParameters.load_factor_min      = param('load_factor_min'); % Structural
DesignParameters.cl_max               = param('cl_max'); % Aerodynamic
DesignParameters.cl_min               = param('cl_min'); % Aerodynamic


%% Evaluated Parameters

DesignParameters.gross_weight = DesignParameters.mass*env.GRAVITY; % N
DesignParameters.wing_area = DesignParameters.wingspan^2/DesignParameters.aspect_ratio; % m2
DesignParameters.stall_speed = sqrt(2*DesignParameters.gross_weight/...
    env.DENSITY/DesignParameters.cl_max/DesignParameters.wing_area); % TAS, m/s

DesignParameters.SpeedRange = linspace(DesignParameters.stall_speed, DesignParameters.max_speed, range);

% Dimensionless Stuff
DesignParameters.Reynolds_Range = env.DENSITY/env.DYNAMIC_VISCOSITY...
    *DesignParameters.SpeedRange...
    *(DesignParameters.wing_area/DesignParameters.wingspan); 

DesignParameters.Mach_Range = DesignParameters.SpeedRange/env.SPEEDSOUND;
end