function plotWing3d(obj,structname,varargin)
structname = strcat(structname,'Geometry');
cstruct = obj.(structname);
n = length(cstruct.bArr);
xOff = 0;
yOff = 0;
zOff = 0;
for i = 1 : 2 : length(varargin)
    if strcmp(varargin{i},'Xoffset')
        xOff = varargin{i+1};
    end
    if strcmp(varargin{i},'Yoffset')
        yOff = varargin{i+1};
    end
    if strcmp(varargin{i},'Zoffset')
        zOff = varargin{i+1};
    end
end
% Max point number
rec = zeros(length(cstruct.Section),1);
for i = 1 : length(cstruct.Section)
    rec(i) = length(cstruct.Section{i}.Airfoil.Geometry.x_c);
end
maxRec = max(rec);
LE3D = nan(maxRec,3,n);

hold on;
for i = 1 : n
    k = length(cstruct.Stations{i}.Geometry.x_c);
    if strcmp(structname,'WingGeometry') || strcmp(structname,...
            'HorizontalTailGeometry')        
        % Rotate for twist
        holderx = (cstruct.Stations{i}.Geometry.x_c-1);
        holdery = (cstruct.Stations{i}.Geometry.y_c);
        px = cosd(cstruct.Stations{i}.AlphaTwist).*(holderx-holderx(1))-sind(cstruct.Stations{i}.AlphaTwist).*(holdery-holdery(1))+holderx(1);
        py = sind(cstruct.Stations{i}.AlphaTwist).*(holderx-holderx(1))+cosd(cstruct.Stations{i}.AlphaTwist).*(holdery-holdery(1))+holdery(1);
        
        % x
        LE3D(1:k,1,i) = cstruct.Stations{i}.y*ones(length(cstruct.Stations{i}.Geometry.y_c),1)...
            +zOff;
        % y
        LE3D(1:k,2,i) = px*cstruct.Stations{i}.Chord ...
            +xOff ...
            +cstruct.Stations{i}.SweepOffset; 
        % z
        LE3D(1:k,3,i) = py*cstruct.Stations{i}.Chord...
            +cstruct.Stations{i}.DihedralOffset...
            +yOff;
    else
        LE3D(1:k,3,i) = cstruct.Stations{i}.y*ones(length(cstruct.Stations{i}.Geometry.y_c),1) ...
            +zOff;
        LE3D(1:k,2,i) = (cstruct.Stations{i}.Geometry.x_c-1)*cstruct.Stations{i}.Chord ...
            +xOff;
        LE3D(1:k,1,i) = cstruct.Stations{i}.Geometry.y_c*cstruct.Stations{i}.Chord ...
            +yOff;
    end
    plot3(LE3D(:,1,i),LE3D(:,2,i),LE3D(:,3,i));
end
xlabel('x');
ylabel('y');
zlabel('z');
axis equal;
hold off;
end

