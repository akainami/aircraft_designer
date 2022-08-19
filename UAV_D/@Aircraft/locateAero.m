function obj = locateAero(obj)
% Import config data
fid = fopen('+source/Data/AIRCRAFT_STRUCTURES.dat');
rawdata = textscan(fid,'%s %s');
fclose(fid);

cfg = containers.Map;
cfg('xHT') = 0;
cfg('yHT') = 0;
cfg('zHT') = 0;
cfg('xVT') = 0;
cfg('yVT') = 0;
cfg('zVT') = 0;

keys = rawdata{1};
values = rawdata{2};
for i = 1 : length(keys)
cfg(keys{i}) = str2double(values{i});
end

obj.Fuselage.AeroLocations = cfg;
end

