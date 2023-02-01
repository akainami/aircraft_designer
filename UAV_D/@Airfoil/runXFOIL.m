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
function runXFOIL(obj)
for iReynolds = 1 : length(obj.Reynolds)
    % Skip XFOIL if polar exists
    targetfol = strcat(obj.foldername,'/','xfoilpolar_Re_',string(round(obj.Reynolds(iReynolds))),'.dat');
    targetfile = strcat('xfoilpolar_Re_',string(round(obj.Reynolds(iReynolds))),'.dat');
    
    % Delete polar to re-run
    fol = dir(obj.foldername);
    existBool = false;
    for i = 1 : length(fol)
        filename = fol(i).name;
        if strcmp(filename,targetfile)
            existBool = true;
        end
    end
    
    if ~existBool
        % Copy airfoil geometry
        airfoilloc = strcat(obj.foldername, '/airfoil.dat');
        copyfile(airfoilloc,'+source/XFOIL/airfoil.txt');
        
        % Import config data
        fid = fopen('+source/Configs/XFOIL_CONFIG.dat');
        rawdata = textscan(fid,'%s %s');
        fclose(fid);
        cfg = table;
        keys = rawdata{1};
        values = rawdata{2};
        for i = 1 : length(keys)
            cfg.(keys{i}) = str2double(values{i});
        end
        
        % Working Directory
        wd = fileparts(which(mfilename));
        wd = erase(wd,'@Airfoil');
        wd = strcat(wd, '+source\XFOIL\');
        
        % Call xfoil_interface
        fid = fopen('+source\XFOIL\xfoilrun.inp','w');
        isNACA = contains(obj.foldername,'NACA');
        if isNACA
            nacacode = erase(obj.foldername,'+source/Airfoils/NACA');
            fprintf(fid, 'naca\n');
            fprintf(fid, '%s\n', nacacode);
            fprintf(fid, 'ppar\n');
            fprintf(fid, 'n %i\n', cfg.n);
        else
            fprintf(fid, 'load %s\n\n', 'airfoil.txt');
            fprintf(fid, 'ppar\n');
            fprintf(fid, 'n %i\n', cfg.n);
        end
        
        fprintf(fid, 't %i\n\n\n',cfg.t);
        fprintf(fid, 'oper\n');
        fprintf(fid, 're %d\n', obj.Reynolds(iReynolds));
%         fprintf(fid, 'm %d\n', obj.Mach(iReynolds)); % Enable for compressibility effects
        fprintf(fid, 'visc\n');
        fprintf(fid, 'iter %i\n', cfg.iter);
        fprintf(fid, 'pacc\n');
        fprintf(fid, '%s\n\n','xfoilpolar.dat');
        aseq = cfg.mina : cfg.da : cfg.maxa;
        for j = 1 : length(aseq)
        fprintf(fid, 'alfa %i\n', aseq(j));
        end
        fprintf(fid, '\nquit');
        fclose(fid);
        
        % Execute XFOIL
        cmd = sprintf('cd %s && xfoil.exe < xfoilrun.inp', wd);
        [~,~] = system(cmd);
        
        % Copy polar to appropiate folder
        copyfile('+source/XFOIL/xfoilpolar.dat',targetfol);
        
        % Delete files
        delete('+source/XFOIL/xfoilrun.inp');
        delete('+source/XFOIL/xfoilpolar.dat');
        delete('+source/XFOIL/airfoil.txt');
    end
end
end
