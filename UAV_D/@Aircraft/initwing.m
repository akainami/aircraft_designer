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