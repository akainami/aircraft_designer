function obj = importFoil(obj)
isNACA = contains(obj.foldername,'NACA');
obj.foilname = erase(obj.foldername, '+source/Airfoils/');
% Handle imported data
%{
Both vectors do a loop around the foil, instead of splitting to two.
%}
if isNACA
    nacacode = erase(obj.foldername,'+source/Airfoils/NACA');
    fid = fopen('+source\XFOIL\xfoilrun.inp','w');
    fprintf(fid, 'naca\n');
    fprintf(fid, '%s\n', nacacode);
    fprintf(fid, 'save\n');
    fprintf(fid, '%s\n','airfoil.dat');
    fprintf(fid, '\nquit');
    fclose(fid);
    wd = fileparts(which(mfilename));
    wd = erase(wd,'@Airfoil');
    wd = strcat(wd, '+source\XFOIL\');
    cmd = sprintf('cd %s && xfoil.exe < xfoilrun.inp', wd);
    [~,~] = system(cmd);
    % system() cant find the path, "cd D:\" is broken
	% use D:\ instead of cd D:\
    targetfol = strcat(obj.foldername,'/airfoil.dat');
    copyfile('+source/XFOIL/airfoil.dat',targetfol);
    delete('+source/XFOIL/xfoilrun.inp');
    delete('+source/XFOIL/airfoil.dat');
    
    fileID = fopen(targetfol,'r');
    formatSpec = '%f%f';
    rawdata = textscan(fileID, formatSpec, 'Delimiter', ' ',...
        'MultipleDelimsAsOne', true, 'TextType', 'string',...
        'HeaderLines' ,1, 'ReturnOnError', false,...
        'EndOfLine', '\r\n');
    fclose(fileID);
    obj.Geometry.x_c = rawdata{1};
    obj.Geometry.y_c = rawdata{2};
else
    filename = strcat(obj.foldername,'/airfoil.dat');
    rawdata = importdata(filename);
    obj.Geometry.x_c = rawdata(:,1);
    obj.Geometry.y_c = rawdata(:,2);
end

% Incompressibility assumption
% if obj.Mach < 0.3
%     obj.Mach = 0;
% end
end