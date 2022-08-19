function obj = CoeffCalculation(obj,structname)
% Returns [CL CD CM]
structname = strcat(structname,'Geometry');
cstruct = obj.(structname);

n = length(cstruct.bArr);
for iReynold = 1 : length(obj.DesignParameters.Reynolds_Range)
    inductionArr = cstruct.Induction.alphaEff{iReynold}';
    alphaArr = cstruct.AlphaRange{iReynold};
    for j = 1 : length(cstruct.AlphaRange{iReynold})
        alpha = cstruct.AlphaRange{iReynold}(j);
        inductionVec = interp1(alphaArr,inductionArr,alpha);
        
        cLVec = zeros(1,n);
        cDVec = zeros(1,n);
        cMVec = zeros(1,n);
        for i = 1 : n
            if inductionVec(i) > min(cstruct.AlphaRange{iReynold})
                cLVec(i) = interp1(cstruct.AlphaRange{iReynold},...
                    cstruct.Stations{i}.LiftPolar{iReynold}, inductionVec(i));
                cDVec(i) = interp1(cstruct.AlphaRange{iReynold},...
                    cstruct.Stations{i}.DragPolar{iReynold}, inductionVec(i));
                cMVec(i) = interp1(cstruct.AlphaRange{iReynold},...
                    cstruct.Stations{i}.MomentPolar{iReynold},inductionVec(i));
            end
        end
        
        % create chord vec
        chordVec = zeros(1,n);
        for i = 1 : n
            chordVec(i) = cstruct.Stations{i}.Chord;
        end
        
        % create area vec
        areaVec = zeros(1,n-1);
        for i = 1 : n - 1
            areaVec(i) = (chordVec(i)+chordVec(i+1)) / 2 * (cstruct.bArr(i+1)-cstruct.bArr(i));
        end
        
        % average coeffs
        cLmVec = zeros(1,n-1);
        cDmVec = zeros(1,n-1);
        cMmVec = zeros(1,n-1);
        for i = 1 : n - 1
            cLmVec(i) = (cLVec(i)+cLVec(i+1))/2;
            cDmVec(i) = (cDVec(i)+cDVec(i+1))/2;
            cMmVec(i) = (cMVec(i)+cMVec(i+1))/2;
        end
        
        %
        obj.(structname).Coeff{iReynold}(j,:) = [cstruct.AlphaRange{iReynold}(j),...
            sum(cLmVec.*areaVec)/sum(areaVec),...
            sum(cDmVec.*areaVec)/sum(areaVec),...
            sum(cMmVec.*areaVec)/sum(areaVec)];
    end
end
end

