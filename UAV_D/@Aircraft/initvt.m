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
function obj = initvt(obj)
% If HT is V-invV, then return (VT won't be defined)
if obj.HorizontalTailGeometry.Section{1}.Dihedral > 25 ||...
        obj.HorizontalTailGeometry.Section{1}.Dihedral < -25
    obj.VerticalTailGeometry.PanelCount = 0;
    return
end

% Import config data
obj.VerticalTailGeometry.PanelCount = length(dir('+source/Data/vtstruct/'))-2; % '..' & '.'
% Replace data
for iPanel = 1 : obj.VerticalTailGeometry.PanelCount
    csname = strcat('cs',string(iPanel),'.dat');
    obj.initcs(iPanel,csname,'vt');
end

% Overall Wingspan
obj.VerticalTailGeometry.WingSpan = 0;
obj.VerticalTailGeometry.WingArea = 0;
for i = 1 : obj.VerticalTailGeometry.PanelCount
    obj.VerticalTailGeometry.WingSpan = obj.VerticalTailGeometry.WingSpan +...
        obj.VerticalTailGeometry.Section{i}.SectionSpan;
    obj.VerticalTailGeometry.WingArea = obj.VerticalTailGeometry.WingArea +...
        2*obj.WingGeometry.Section{i}.SectionArea;
end
obj.VerticalTailGeometry.AspectRatio = obj.VerticalTailGeometry.WingSpan^2/obj.VerticalTailGeometry.WingArea;

% Reynolds Array
obj.VerticalTailGeometry.Reynolds_Range = obj.DesignParameters.Reynolds_Range;

% AoA Range of Potential Flow Analysis
obj.VerticalTailGeometry.AlphaRange = obj.VerticalTailGeometry.Section{1}.Airfoil.Alpha;

% Create 3-D Wing 
obj.createStations('VerticalTail');

% Obtain Effective Aoa's
obj.induction('VerticalTail');

% Obtain CL CD CM
obj.CoeffCalculation('VerticalTail');
end
