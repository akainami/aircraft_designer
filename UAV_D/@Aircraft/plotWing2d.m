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
