function OUT = airfoilCurveFlipper(filename, breakpoint)
rawdata = importdata(filename);
split1 = rawdata(1:breakpoint,:);
split2 = rawdata(breakpoint+2:end,:);
OUT = [flip(split1);split2];
end

