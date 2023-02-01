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
function plotPolars(obj)
for iR = 1 : length(obj.Reynolds)
    figure('units','normalized','outerposition',[0.1 0.1 0.8 0.8]);

    %% DRAG
    subplot(2,2,1);
    plot(obj.Alpha{iR},obj.DragPolar{iR},'k','LineWidth',2);
    title(strcat('Reynolds ',string(obj.Reynolds(iR))));
    xlabel('Angle of Attack (^o)');
    ylabel('c_d');
    
    %% LIFT
    subplot(2,2,2);
    plot(obj.Alpha{iR},obj.LiftPolar{iR},'k','LineWidth',2);
    xlabel('Angle of Attack (^o)');
    ylabel('c_l');
    
    %% MOMENT
    subplot(2,2,3);
    plot(obj.Alpha{iR},obj.MomentPolar{iR},'k','LineWidth',2);
    xlabel('Angle of Attack (^o)');
    ylabel('c_m');
    
    %% L/D
    subplot(2,2,4);
    plot(obj.Alpha{iR},obj.LiftPolar{iR}./obj.DragPolar{iR},'k','LineWidth',2);
    xlabel('Angle of Attack (^o)');
    ylabel('L/D');
end
end
