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