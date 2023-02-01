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
function obj = initwing(obj)
% Import config data
obj.WingGeometry.PanelCount = length(dir('+source/Data/wingstruct/'))-2; % '..' & '.'

% Replace data
for iPanel = 1 : obj.WingGeometry.PanelCount
    csname = strcat('cs',string(iPanel),'.dat');
    obj.initcs(iPanel,csname,'wing');
end

% Overall Wingspan
obj.WingGeometry.WingSpan = 0;
obj.WingGeometry.WingArea = 0;
for i = 1 : obj.WingGeometry.PanelCount
    obj.WingGeometry.WingSpan = obj.WingGeometry.WingSpan +...
        2*obj.WingGeometry.Section{i}.SectionSpan;
    obj.WingGeometry.WingArea = obj.WingGeometry.WingArea +...
        2*obj.WingGeometry.Section{i}.SectionArea;
end

obj.WingGeometry.AspectRatio = obj.WingGeometry.WingSpan^2/obj.WingGeometry.WingArea;

% Reynolds Array
obj.WingGeometry.Reynolds_Range = obj.DesignParameters.Reynolds_Range;

% AoA Range of Potential Flow Analysis
obj.WingGeometry.AlphaRange = obj.WingGeometry.Section{1}.Airfoil.Alpha;

% Create 3-D Wing 
obj.createStations('Wing');

% Obtain Effective Aoa's
obj.induction('Wing');

% Obtain CL CD CM
obj.CoeffCalculation('Wing');
end
