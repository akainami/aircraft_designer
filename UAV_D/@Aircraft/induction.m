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
function obj = induction(obj,structurename)
structure = obj.(strcat(structurename,'Geometry'));
for iReynold = 1 : length(obj.DesignParameters.Reynolds_Range)
    % Initialize useful variables/vectors
    nStation = length(structure.Stations);
    chord = zeros(nStation,1);
    cLalpha = zeros(nStation,1);
    alphaLzero = zeros(nStation,1);
    alphaTwisted = zeros(nStation,1);
    theta_0 = linspace(0 ,pi, nStation);
    
    % Alpha-AlphaEff polar
    for iAlpha =  1 : length(structure.AlphaRange{iReynold})
        alpha = structure.AlphaRange{iReynold}(iAlpha); % deg
        
        % Obtain Station Data
        for iStat = 1 : nStation
            Station = structure.Stations{iStat}; % Copy Station Structure
            
            chord(iStat) = Station.Chord; % Chord Length
            
            alphaTwisted(iStat) = alpha + Station.AlphaTwist; % Twisted Body Angles
            
            cLalpha(iStat) = interp1(Station.Alpha{iReynold}',Station.LiftDeriv{iReynold},...
                alphaTwisted(iStat)); % Lift Derivative
            sampledLift = [Station.LiftPolar{iReynold},...
                Station.Alpha{iReynold}];
            sampledLift = sortrows(sampledLift);
            [~,ind]=unique(sampledLift(:,1));
            alphaLzero(iStat) = ...
                interp1(sampledLift(ind,1),sampledLift(ind,2),0); 
            % Zero Lift Angles
        end
        % AoA's to be used, convert to rad
        ALPHA_NINF = (alphaTwisted(2:nStation-1) - alphaLzero(2:nStation-1))/180*pi;
        ALPHA = zeros(nStation-2,nStation-2);
        for i = 2 : nStation-1
            for j = 2 : nStation-1
                ALPHA(i-1,j-1) = 4*structure.WingSpan*...
                    sin((j-1)*theta_0(i))...
                    /( cLalpha(i)*chord(i))...
                    +(j-1)*sin((j-1)*theta_0(i))...
                    /sin(theta_0(i));
            end
        end
        ALPHA_N = ALPHA\ALPHA_NINF;
        
        alphaInd = zeros(nStation,1);
        for i = 2 : nStation-1
            alphaInd(i)=sum((1:nStation-2)'.*ALPHA_N.*sin((1:nStation-2)'*...
                theta_0(i))./sin(theta_0(i)));
        end
        alphaInd([1 end])=sum((1:nStation-2)'.*ALPHA_N.*(1:nStation-2)');
        alphaInd = alphaInd*180/pi;
        
        % Effective Aoa
        obj.(strcat(structurename,'Geometry')).Induction.alphaEff{iReynold}(:,iAlpha) = alphaTwisted - alphaInd;
    end
    
end
end
