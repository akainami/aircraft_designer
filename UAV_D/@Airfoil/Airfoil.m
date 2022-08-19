classdef Airfoil < handle
    properties
        foldername
        foilname
        
        Geometry
        LiftPolar
        DragPolar
        MomentPolar
        LiftDeriv
        
        Alpha
        Reynolds
        Mach
    end
    methods
        function obj = init(obj,foldername)
            obj.foldername = foldername;
            obj.Geometry = struct();
            obj.importFoil;
            obj.runXFOIL;
            obj.importPolars;
        end
    end
end