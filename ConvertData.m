function ConvertData

clear
clc

addpath('C:\Users\jonesg5\Documents\GitHub\d12pack')
addpath('C:\Users\jonesg5\Documents\GitHub\circadian')

rootDir = '\\root\projects';
calPath = fullfile(rootDir,'DaysimeterAndDimesimeterReferenceFiles',...
    'recalibration2016','calibration_log.csv');

projectDir = '\\ROOT\projects\GSA_Daysimeter\GSA US Embassy\Reykjavik\Daysimeter_Data';
dataDir    = fullfile(projectDir,'originalData');

timestamp = datestr(now,'yyyy-mm-dd_HHMM');
dbName  = [timestamp,'.mat'];
dbPath  = fullfile(projectDir,'convertedData',dbName);

datalogLs = dir(fullfile(dataDir,'*data.txt'));
datalogPaths = fullfile(dataDir,{datalogLs.name}');
loginfoPaths = regexprep(datalogPaths,'DATA\.txt','LOG.txt');
cdfPaths     = regexprep(datalogPaths,'-DATA\.txt','.cdf');

LocObj = d12pack.LocationData;
LocObj.BuildingName             = 'United States Embassy in Reykjavik';
LocObj.Street                   = 'Laufásvegur 21';
LocObj.City                     = 'Reykjavik';
LocObj.Country                  = 'Iceland';
LocObj.Organization             = 'Department of State';
LocObj.Lattitude                =  64.144593;
LocObj.Longitude                = -21.938019;

nFile = numel(datalogPaths);

for iFile = nFile:-1:1
    obj = d12pack.HumanData;
    
    obj.CalibrationPath = calPath;
    obj.RatioMethod     = 'normal';
    obj.Location        = LocObj;
    obj.TimeZoneLaunch	= 'America/New_York';
    obj.TimeZoneDeploy	= 'Atlantic/Reykjavik';
    
    % Import the original data
    obj.log_info = obj.readloginfo(loginfoPaths{iFile});
    obj.data_log = obj.readdatalog(datalogPaths{iFile});
    
    % Read CDF data
    try
    cdfData = daysimeter12.readcdf(cdfPaths{iFile});
    catch err
        display(err)
    end
    
    % Add ID
    obj.ID = cdfData.GlobalAttributes.subjectID;
    
    % Add object to array of objects
    objArray(iFile,1) = obj;
end

% Save converted data to file
save(dbPath,'objArray');

end