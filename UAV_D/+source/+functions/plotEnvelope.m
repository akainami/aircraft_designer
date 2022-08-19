function envelope = plotEnvelope(obj)
%{
 == REQUIRED PARAMETERS FOR FLIGHT ENVELOPE ==
 AIRCRAFT
    stall_speed
    cl_max
    cl_min
    wing_area
    gross_weight
    load_factor_max
    load_factor_min
    ave_speed
env
    DENSITY
%}
AIRCRAFT = obj.DesignParameters;
env = obj.Atmosphere;

% Upper Stall Curve
etaVstallU = (1/2*env.DENSITY*AIRCRAFT.stall_speed^2*...
    AIRCRAFT.cl_max*AIRCRAFT.wing_area)...
    /AIRCRAFT.gross_weight;
vEtaMax = sqrt(AIRCRAFT.load_factor_max*AIRCRAFT.gross_weight...
    *2/(env.DENSITY*AIRCRAFT.cl_max*AIRCRAFT.wing_area));

A = [AIRCRAFT.stall_speed^2 AIRCRAFT.stall_speed;
    vEtaMax^2 vEtaMax];
B = [etaVstallU;
    AIRCRAFT.load_factor_max];
polyCoeff = A\B;
polyCoeff(end+1) = 0;
rangeUSC = linspace(AIRCRAFT.stall_speed, vEtaMax, 20);
upperStallCurve = polyval(polyCoeff, rangeUSC);

upperHorizontal = ones(1,20)*AIRCRAFT.load_factor_max;
rangeUH = linspace(vEtaMax, AIRCRAFT.max_speed,20);

% Lower Stall Curve
etaVstallL = (1/2*env.DENSITY*AIRCRAFT.stall_speed^2*...
    AIRCRAFT.cl_min*AIRCRAFT.wing_area)...
    /AIRCRAFT.gross_weight;
vEtaMin = sqrt(AIRCRAFT.load_factor_min*AIRCRAFT.gross_weight...
    *2/(env.DENSITY*AIRCRAFT.cl_min*AIRCRAFT.wing_area));

A = [AIRCRAFT.stall_speed^2 AIRCRAFT.stall_speed;
    vEtaMin^2 vEtaMin];
B = [etaVstallL;
    AIRCRAFT.load_factor_min];
polyCoeff = A\B;
polyCoeff(end+1) = 0;
rangeLSC = linspace(AIRCRAFT.stall_speed, vEtaMin, 20);
lowerStallCurve = polyval(polyCoeff, rangeLSC);
rangeLH = linspace(vEtaMin, AIRCRAFT.max_speed,20);
lowerHorizontal = ones(1,20)*AIRCRAFT.load_factor_min;

% Verticals
vertStall = [etaVstallL, etaVstallU];
rangeVS = [1 1]* AIRCRAFT.stall_speed;

vertMax = [AIRCRAFT.load_factor_max AIRCRAFT.load_factor_min];
rangeM = [1 1]*AIRCRAFT.max_speed;

% Creating the Envelope Polygon
envelope = [rangeVS,rangeLSC, rangeLH, rangeM, flip(rangeUH), flip(rangeUSC);
     vertStall,lowerStallCurve, lowerHorizontal,...
    vertMax, flip(upperHorizontal), flip(upperStallCurve)];
figure;
fill(envelope(1,:), envelope(2,:),[150/255 230/255 150/255]);
xlim([-2 AIRCRAFT.max_speed*1.2]);
ylim([AIRCRAFT.load_factor_min*1.4 AIRCRAFT.load_factor_max*1.25]);
title('Flight Envelope');
ylabel('Load Factor');
xlabel('TAS (m/s)');
end