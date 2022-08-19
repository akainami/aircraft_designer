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