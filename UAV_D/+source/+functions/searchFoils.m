function airfoilMap = searchFoils(DesignParameters)
airfoilMap = containers.Map;
files = dir('+source/Airfoils');
for i = 1 : length(files)
    filename = files(i).name;
    if ~strcmp(filename,'.') && ~strcmp(filename,'..')
        dummy = Airfoil;
        dummy.Reynolds = DesignParameters.Reynolds_Range;
        dummy.Mach = DesignParameters.Mach_Range;
        dummy.init(strcat('+source/Airfoils/',filename));
        airfoilMap(filename) = dummy;
    end
end
end