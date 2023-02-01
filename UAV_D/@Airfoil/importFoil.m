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
