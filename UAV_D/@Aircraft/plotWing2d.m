function plotWing2d(obj,structname)
structname = strcat(structname,'Geometry');
cstruct = obj.(structname);
n = length(cstruct.bArr);
LE = zeros(n,1);
bArr = cstruct.bArr;
TE = zeros(n,1);
for i = 1 : n
    LE(i) = cstruct.Stations{i}.Chord;
end
figure;
hold on;
plot(bArr, LE, 'k');
plot(bArr, TE, 'k');
plot(min(bArr)*[1 1],[TE(1) LE(1)],'k');
plot(max(bArr)*[1 1],[TE(end) LE(end)],'k');
hold off;
axis equal;
xlim([1.2*min(bArr) 1.2*max(bArr)]);
ylim([-0.5*max(LE) 1.5*max(LE)]);
end