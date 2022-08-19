function obj = assignAirfoils(obj)
% Directly obtain data from "Airfoils\" instead of manual definition
airfoilMap = source.functions.searchFoils(obj.DesignParameters);

% Assign foils
obj.Foils = airfoilMap;
end