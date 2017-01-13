function data = loadData(varargin)
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here

% Enable dependencies
[githubDir,~,~] = fileparts(pwd);
d12packDir      = fullfile(githubDir,'d12pack');
addpath(d12packDir);

if nargin >= 1
    projectDir = varargin{1};
else
    projectDir = '\\ROOT\projects\GSA_Daysimeter\GSA US Embassy\Reykjavik\Daysimeter_Data\croppedData';
end

ls = dir([projectDir,filesep,'*.mat']);
[~,idxMostRecent] = max(vertcat(ls.datenum));
dataName = ls(idxMostRecent).name;
dataPath = fullfile(projectDir,dataName);

d = load(dataPath);

data = d.objArray;

end

