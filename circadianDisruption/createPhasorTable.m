%clears Matlab workspace and command window
close all 
clear
clc
%this is the folder path for the data 
folderPath = '\\root\projects\AmericanCancerSociety\DaysimeterData';

%gets a list of file paths 
filePath = getFilePath(folderPath);

%litss the number of files
nPath = numel(filePath);

%preallocate for the data from the for loop
subject_ID = cell(nPath,1);
phasor_angle_hours = nan(nPath,1);
phasor_magnitude = nan(nPath,1);

%goes through each file and pulls the data from it and stores it in the
%preallocations
for iPath = 1:nPath
    [subject_ID{iPath},phasor_angle_hours(iPath),phasor_magnitude(iPath)] = phasorTableMaker(filePath{iPath});
end
%creates a table and adds the subject ID to the table
masterPhasorAngleTable = table(subject_ID,phasor_angle_hours);
masterPhasorMagnitudeTable = table(subject_ID,phasor_magnitude);

%exports the tables to excel 
writetable(masterPhasorAngleTable,'phasor.xlsx','sheet',1);
writetable(masterPhasorMagnitudeTable,'phasor.xlsx','sheet',2);

%opens the spreadsheet
winopen('phasor.xlsx')