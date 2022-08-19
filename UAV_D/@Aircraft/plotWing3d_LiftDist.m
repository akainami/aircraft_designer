function plotWing3d_LiftDist(obj,structname1,alpha)
% structname = 'Wing';
structname = strcat(structname1,'Geometry');
cstruct = obj.(structname);
n = length(cstruct.bArr);

% Plot Wing
figure;
hold on;
obj.plotWing3d(structname1);

legend off;
legend("REYNOLDS NUMBERS");
% Plot L for each Re
legend('Location','eastoutside');
for iR = 1 : length(cstruct.AlphaRange)
    inductionArr = cstruct.Induction.alphaEff{iR}';
    alphaArr = cstruct.AlphaRange{iR};
    inductionVec = interp1(alphaArr,inductionArr,alpha);
    cLiftVec = nan(1,n);
    for i = 1 : n
        if inductionVec(i) > min(cstruct.AlphaRange{iR})
            cLiftVec(i) = interp1(cstruct.AlphaRange{iR},cstruct.Stations{i}.LiftPolar{iR},...
                inductionVec(i));
        end
    end
    plot3(cstruct.bArr,zeros(n,1),cLiftVec,...
        'DisplayName',string(cstruct.Reynolds_Range(iR)));
end

axis equal;
zlim([-0.5 1.5]); % CHANGE TO CHORD LENGTHS
zlabel('Lift Coefficient');
ylim([-0.5 0.5]);
ylabel('Chord [m]');
xlim(([min(cstruct.bArr)*1.1 1.1*max(cstruct.bArr)]));
xlabel('Wingspan [m]');
title(strcat('Alpha ',string(alpha)));
hold off;
end

