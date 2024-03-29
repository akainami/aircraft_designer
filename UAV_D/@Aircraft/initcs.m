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
function obj = initcs(obj,iPanel,csname,type)
% Import config data
fid = fopen(strcat('+source/Data/',type,'struct/',csname));
rawdata = textscan(fid,'%s %s');
fclose(fid);
key = rawdata{1};
vals = rawdata{2};
data = containers.Map;

for i = 1 : length(key)
    data(key{i}) = vals{i};
end

foilprop = 'Foils';
if strcmp(type,'wing')
    structure = 'WingGeometry';
elseif strcmp(type, 'ht')
    structure = 'HorizontalTailGeometry';
elseif strcmp(type, 'vt')
    structure = 'VerticalTailGeometry';
end

% Replace data
obj.(structure).Section{iPanel} = struct();
obj.(structure).Section{iPanel}.id = strcat('Section',string(iPanel));
obj.(structure).Section{iPanel}.Airfoil = obj.(foilprop)(data('Airfoil'));
obj.(structure).Section{iPanel}.SectionSpan = str2double(data('SectionSpan'));
obj.(structure).Section{iPanel}.Dihedral = str2double(data('Dihedral'));
if iPanel == 1
    obj.(structure).Section{iPanel}.Chord = str2double(data('Chord'));
    obj.(structure).Section{iPanel}.CumulativeSpan = str2double(data('SectionSpan'));
    obj.(structure).Section{iPanel}.CumulativeSpanInit = 0;
    obj.(structure).Section{iPanel}.BodyIncidence = str2double(data('BodyIncidence'));
    
    obj.(structure).Section{iPanel}.DihedralOffsetTip = str2double(data('SectionSpan'))*sind(str2double(data('Dihedral')));
    obj.(structure).Section{iPanel}.DihedralOffsetRoot = 0;
    
    obj.(structure).Section{iPanel}.SweepOffsetTip = str2double(data('SectionSpan'))*sind(str2double(data('SweepAngle')));
    obj.(structure).Section{iPanel}.SweepOffsetRoot = 0;
elseif iPanel > 1
    obj.(structure).Section{iPanel}.Chord = obj.(structure).Section{iPanel-1}.ChordTip;
    obj.(structure).Section{iPanel}.CumulativeSpan = str2double(data('SectionSpan')) ...
        + obj.(structure).Section{iPanel-1}.CumulativeSpan;
    obj.(structure).Section{iPanel}.CumulativeSpanInit = ...
        obj.(structure).Section{iPanel-1}.CumulativeSpan;
    obj.(structure).Section{iPanel}.BodyIncidence = obj.(structure).Section{iPanel-1}.BodyIncidence +...
        obj.(structure).Section{iPanel-1}.SectionSpan*obj.(structure).Section{iPanel-1}.TwistRate;
    
    obj.(structure).Section{iPanel}.DihedralOffsetTip = obj.(structure).Section{iPanel-1}.DihedralOffsetTip+str2double(data('SectionSpan'))*sind(str2double(data('Dihedral')));
    obj.(structure).Section{iPanel}.DihedralOffsetRoot = obj.(structure).Section{iPanel-1}.DihedralOffsetTip;
    
    obj.(structure).Section{iPanel}.SweepOffsetTip = obj.(structure).Section{iPanel-1}.SweepOffsetTip+str2double(data('SectionSpan'))*sind(str2double(data('SweepAngle')));
    obj.(structure).Section{iPanel}.SweepOffsetRoot = obj.(structure).Section{iPanel-1}.SweepOffsetTip;
end
% These are not RATIOs, but RATEs. Consider defining them as chord_dot(y)
% and bodyincidence_dot(y)
obj.(structure).Section{iPanel}.TaperRate = str2double(data('TaperRate'));
obj.(structure).Section{iPanel}.TwistRate = str2double(data('TwistRate'));
obj.(structure).Section{iPanel}.SweepAngle = str2double(data('SweepAngle'));
% Section ChordTip
obj.(structure).Section{iPanel}.ChordTip = obj.(structure).Section{iPanel}.Chord - ...
    str2double(data('SectionSpan'))*str2double(data('TaperRate'));
% Section Area
obj.(structure).Section{iPanel}.SectionArea = (2 * obj.(structure).Section{iPanel}.Chord - ...
    str2double(data('SectionSpan')) * str2double(data('TaperRate')) )...
    / 2 * str2double(data('SectionSpan'));
end
