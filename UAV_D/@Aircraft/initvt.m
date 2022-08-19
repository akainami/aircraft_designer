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