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

clc; clear; close; tic;
%{
UAV Design Tool by Atakan Öztürk, 2022, Karabuk-Istanbul

- International Standard Atmosphere, ISA by BADA
- Desired Design inputs are put into desiredDesign.m
- Put Airfoil data in Airfoils/AIRFOIL_NAME/~ as airfoil.dat and
xfoilpolar.dat to analyze in XFOIL 6.99
- Define Wing Panel Surfaces in appropiate folders as +Xstruct/cs#.dat
- Configurate Induction_config.dat & Xstruct_stations.dat files to
determine precision
- Define Wing/Tail Locations in Aircraft_Structures.dat


References:
- Fundamentals of Aerodynamics, Anderson J. (1984)
- NASA XFOIL6.99

WIP:
** NACA foils should have a geometry creater, also fix searchFoils
%}

%% Atmosphere Initiation
environment = Atmosphere;
environment.init(0,0); % (h, dT) for ISA

%% Desired Design Initiation
DesignParameters = desiredDesign(environment);

%% Design Modelling
UAV_D = Aircraft;
UAV_D.assignDesired(...
    'DesignParameters',DesignParameters,...
    'Atmosphere',environment);
UAV_D.init;

%% Flight Mechanics & Trim & Stability

%% Flight Profile

%% Plots
% UAV_D.plotAircraft;
% UAV_D.plotWing2d('VerticalTail');
% UAV_D.plotWing3d_LiftDist('HorizontalTail',5);
% UAV_D.WingGeometry.Section{1}.Airfoil.plotFoil;
% UAV_D.WingGeometry.Section{1}.Airfoil.plotPolars;
% source.functions.liftDistWing(UAV_D);
% source.functions.plotEnvelope(UAV_D);

%%
clearvars -except UAV_D;
toc;
save('UAV_D_Backup','UAV_D');

%{
Elapsed Time Log
26.06.2022 - 0.009 s "Import ISA & DesignLimits"
27.06.2022 - 15.400 s "Import XFOIL"
28.06.2022 - 0.130 s "Create Wing3D"
29.06.2022 - 1.913 s "Import Induction & Finite Wing Polars & 3-Wings Model"
07.07.2022 - 1.020 s "Coefficient Calculations of Wing/VT/HT"
09.07.2022 - 2.864 s "Reynolds Effect on EVERYTHING & XFOIL-NACA recognition"
10.07.2022 - 4.405 s "NACA-Foil generation without airfoil.dat, pretty much most of the things on WIP"
12.07.2022 - 4.662 s "Sweep-Twist-Dihedral Geometries"
%}
