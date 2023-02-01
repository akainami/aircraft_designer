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
function obj = createStations(obj,structurename)
% Import 
fid = fopen(strcat('+source/Configs/',structurename,'_stations.dat'));
rawdata = textscan(fid,'%s %s');
fclose(fid);
cfg = table;
keys = rawdata{1};
values = rawdata{2};
for i = 1 : length(keys)
    cfg.(keys{i}) = str2double(values{i});
end
% Data Structures
structurename = strcat(structurename,'Geometry');
structure = obj.(structurename);
structure.Stations = {};
secHolder = structure.Section;
A = struct; % DUMMY

% Wing Span Array
if strcmp(structurename,'WingGeometry')
    bArr = -structure.WingSpan/2*cos(linspace(0,pi,cfg.n));
elseif strcmp(structurename,'HorizontalTailGeometry')
    bArr = -structure.WingSpan/2*cos(linspace(0,pi,cfg.n));
elseif strcmp(structurename,'VerticalTailGeometry')
    bArr = -structure.WingSpan/2*cos(linspace(pi/2,pi,cfg.n));
end
for iStation = 1 : cfg.n
    % Section Determination
    A.id = iStation;
    A.y = bArr(iStation);
    panelBool = true;
    iSection = 0;
    while panelBool
        iSection = iSection + 1;
        if abs(A.y) <= abs(secHolder{iSection}.CumulativeSpan)
            panelBool = false;
        end
    end
    cSection = secHolder{iSection};
    
    % Geometry
    A.Chord = interp1([cSection.CumulativeSpan,cSection.CumulativeSpanInit],...
        [cSection.ChordTip,cSection.Chord],...
        abs(bArr(iStation)));
    A.DihedralOffset = interp1([cSection.CumulativeSpan,cSection.CumulativeSpanInit],...
        [cSection.DihedralOffsetTip,cSection.DihedralOffsetRoot],...
        abs(bArr(iStation)));
    A.SweepOffset = interp1([cSection.CumulativeSpan,cSection.CumulativeSpanInit],...
        [cSection.SweepOffsetTip,cSection.SweepOffsetRoot],...
        abs(bArr(iStation)));
    A.Geometry = cSection.Airfoil.Geometry;
    A.TwistRate = cSection.TwistRate;
    A.AlphaTwist = cSection.BodyIncidence + cSection.TwistRate * ...
        ( abs(bArr(iStation)) -  cSection.CumulativeSpanInit ); 
    % BodyIncidence [deg] + TwistRate [deg/m] * Span [m]
    
    % Aerodynamic Polars
    A.LiftDeriv = cSection.Airfoil.LiftDeriv;
    A.LiftPolar = cSection.Airfoil.LiftPolar;
    A.DragPolar = cSection.Airfoil.DragPolar;
    A.MomentPolar = cSection.Airfoil.MomentPolar;
    A.Alpha = cSection.Airfoil.Alpha;
    
    % Replace into structure
    structure.Stations{iStation} = A;
end

structure.bArr = bArr;
obj.(structurename) = structure;
end
