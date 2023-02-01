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
function obj = initht(obj)
% Import config data
obj.HorizontalTailGeometry.PanelCount = length(dir('+source/Data/htstruct/'))-2; % '..' & '.'

% Replace data
for iPanel = 1 : obj.HorizontalTailGeometry.PanelCount
    csname = strcat('cs',string(iPanel),'.dat');
    obj.initcs(iPanel,csname,'ht');
end

% Overall Wingspan
obj.HorizontalTailGeometry.WingSpan = 0;
obj.HorizontalTailGeometry.WingArea = 0;
for i = 1 : obj.HorizontalTailGeometry.PanelCount
    obj.HorizontalTailGeometry.WingSpan = obj.HorizontalTailGeometry.WingSpan +...
        obj.HorizontalTailGeometry.Section{i}.SectionSpan;
    obj.HorizontalTailGeometry.WingArea = obj.HorizontalTailGeometry.WingArea +...
        2*obj.HorizontalTailGeometry.Section{i}.SectionArea;
end
obj.HorizontalTailGeometry.AspectRatio = obj.HorizontalTailGeometry.WingSpan^2/obj.HorizontalTailGeometry.WingArea;

% AoA Range of Potential Flow Analysis
obj.HorizontalTailGeometry.AlphaRange = obj.HorizontalTailGeometry.Section{1}.Airfoil.Alpha;

% Reynolds Array
obj.HorizontalTailGeometry.Reynolds_Range = obj.DesignParameters.Reynolds_Range;

% Create 3-D Wing 
obj.createStations('HorizontalTail');

% Obtain Effective Aoa's
obj.induction('HorizontalTail');

% Obtain CL CD CM
obj.CoeffCalculation('HorizontalTail');

end
