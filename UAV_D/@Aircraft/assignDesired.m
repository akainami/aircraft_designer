function obj = assignDesired(obj, varargin)

% Obtain VarArgIn
variables = containers.Map;
for i = 1 : 2 : length(varargin)
    variables(varargin{i}) = varargin{i+1};
end

% Assign desired design structure
obj.DesignParameters = variables('DesignParameters');
obj.Atmosphere = variables('Atmosphere');
end