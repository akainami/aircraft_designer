function obj = importPolars(obj)
for iReynolds = 1 : length(obj.Reynolds)
    filename = strcat('xfoilpolar_Re_',string(round(obj.Reynolds(iReynolds))),'.dat');
    fileloc = strcat(obj.foldername,'/',filename);
    formatSpec = '%f%f%f%f%f%f%f%*s%*s%*s%*s%[^\n\r]';
    fileID = fopen(fileloc,'r');
    rawdata = textscan(fileID, formatSpec, 'Delimiter', ' ',...
        'MultipleDelimsAsOne', true, 'TextType', 'string',...
        'HeaderLines' ,12, 'ReturnOnError', false,...
        'EndOfLine', '\r\n');
    fclose(fileID);
    alphas = rawdata{:,1};
    lifts = rawdata{:,2};
    drags = rawdata{:,3};
    moments = rawdata{:,5};
    obj.Alpha{iReynolds} = alphas;
    obj.LiftPolar{iReynolds} = lifts;
    obj.DragPolar{iReynolds} = drags;
    obj.MomentPolar{iReynolds} = moments;
    
    % WIP
    % It was instantaneous derivative
    % Changed to overall slope
    if ~isempty(alphas)
        smallBool = true;
        for i = 1 : length(alphas)
            if  alphas(i) == 0
                zeroInd = i;
                break
            end
        end
        i = zeroInd;
        while(smallBool)
            if i > 1
                if lifts(i-1) < lifts(i)
                    i = i - 1;
                else
                    alphaMinInd = i;
                    smallBool = false;
                end
            else
                alphaMinInd = 1;
                smallBool = false;
            end
        end
        greatBool = true;
        i = zeroInd;
        while(greatBool)
            if i < length(alphas)
                if lifts(i+1) > lifts(i)
                    i = i + 1;
                else
                    alphaMaxInd = i;
                    greatBool = false;
                end
            else
                alphaMaxInd = i;
                greatBool = false;
            end
        end
        obj.LiftDeriv{iReynolds} = ones(1,length(alphas));
        % between min-max
        obj.LiftDeriv{iReynolds}(alphaMinInd:alphaMaxInd) = ...
            ones(1,length(alphaMinInd:alphaMaxInd))*...
            (lifts(alphaMaxInd)-lifts(alphaMinInd))/...
            ((alphas(alphaMaxInd)-alphas(alphaMinInd))*pi/180);
        % outside of the interval
        obj.LiftDeriv{iReynolds}(1 : alphaMinInd-1) = ...
            ones(1,length(1:alphaMinInd-1))*...
            (lifts(1)-lifts(alphaMinInd))/...
            ((alphas(1)-alphas(alphaMinInd))*pi/180);
        
        obj.LiftDeriv{iReynolds}(alphaMaxInd+1:end) = ...
            ones(1,length(alphaMaxInd+1:length(alphas)))*...
            (lifts(alphaMaxInd)-lifts(end))/...
            ((alphas(alphaMaxInd)-alphas(end))*pi/180);
        %         for i = 2 : length(obj.LiftPolar{iReynolds})-1
        %             obj.LiftDeriv{iReynolds}(i) = (obj.LiftPolar{iReynolds}(i+1) - ...
        %                 obj.LiftPolar{iReynolds}(i-1))/((obj.Alpha{iReynolds}(i+1) - ...
        %                 obj.Alpha{iReynolds}(i-1))*pi/180);
        %         end
        %         obj.LiftDeriv{iReynolds}(1) = (obj.LiftPolar{iReynolds}(2)-obj.LiftPolar{iReynolds}(1))...
        %             /((obj.Alpha{iReynolds}(2)-obj.Alpha{iReynolds}(1))*pi/180);
        %         obj.LiftDeriv{iReynolds}(end+1) = (obj.LiftPolar{iReynolds}(end)-obj.LiftPolar{iReynolds}(end-1))...
        %             /((obj.Alpha{iReynolds}(end)-obj.Alpha{iReynolds}(end-1))*pi/180);
    else
        obj.LiftDeriv{iReynolds} = [];
    end
end
end