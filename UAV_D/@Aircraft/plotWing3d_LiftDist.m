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

