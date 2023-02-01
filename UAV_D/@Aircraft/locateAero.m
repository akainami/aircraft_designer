%{
MIT License

Copyright (c) 2022 akainami

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
%}
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

