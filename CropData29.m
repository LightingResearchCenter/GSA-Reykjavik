function CropData29

% Reset MATLAB
close all
clear
clc

% Enable dependencies
[githubDir,~,~] = fileparts(pwd);
d12packDir      = fullfile(githubDir,'d12pack');
addpath(d12packDir);

% Map paths
timestamp = datestr(now,'yyyy-mm-dd_HHMM');

projectDir = '\\ROOT\projects\GSA_Daysimeter\GSA US Embassy\Reykjavik\Daysimeter_Data';
dataDir = fullfile(projectDir,'convertedData');
saveDir = fullfile(projectDir,'croppedData');

saveName  = [timestamp,'.mat'];
savePath  = fullfile(saveDir,saveName);

% Load data from previous crop session
objArray = loadData(saveDir);
% Load new data
objArrayNew = loadData(dataDir);

% Isolate data from subject 29
idx29 = strcmp({objArrayNew.ID}','29');
obj29 = objArrayNew(idx29);

% Append subject 29 to previously cropped data
objArray = [objArray;obj29];

% Create DB file and object
DB = matfile(savePath,'Writable',true);
DB.objArray = objArray;

% Crop data
nObj = numel(objArray);
for iObj = nObj
    disp([num2str(iObj) ' of ' num2str(nObj)]);
    thisObj = objArray(iObj);
    
    % Check if data was already cropped
    if ~all(thisObj.Observation) || ~all(thisObj.Compliance)
        menuTxt = sprintf('Subject: %s\nappears to be cropped.\nWould you like to skip?',thisObj.ID);
        opts = {'Yes, (Skip)','No, (Crop)'};
        choice = menu(menuTxt,opts);
        if choice == 1
            continue
        end
    end
    
    % Crop the data
    thisObj = crop(thisObj);
    
    objArray(iObj) = thisObj;
    
    % Save data
    DB.objArray = objArray;
    
    if iObj ~= nObj
        menuTxt = sprintf('Cropping saved.\nWould you like to continue');
        opts = {'Yes, continue','No, exit'};
        choice = menu(menuTxt,opts);
        if choice == 2
            return
        end
    end
end

end
