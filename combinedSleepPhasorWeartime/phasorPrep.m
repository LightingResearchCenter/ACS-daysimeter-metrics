%% clears Matlab workspace and command window
close all 
clear
clc
%% this is the folder path for the data 
masterPath = '\\root\projects\AmericanCancerSociety\DaysimeterData\';
[q1FilePaths,q2FilePaths,q3FilePaths,q4FilePaths,...
    q1DiaryPaths,q2DiaryPaths,q3DiaryPaths,q4DiaryPaths] = quarterFilePaths(masterPath);

for iQuarter = 1:4
    
    if iQuarter == 1
        filePath = q1FilePaths; 
        diaryPath = q1DiaryPaths; 
        fileQName = 'Q1.xlsx';
    end
    
    if iQuarter == 2
        filePath = q2FilePaths; 
        diaryPath = q2DiaryPaths; 
        fileQName = 'Q2.xlsx';
    end
    
    if iQuarter == 3
        filePath = q3FilePaths; 
        diaryPath = q3DiaryPaths; 
        fileQName = 'Q3.xlsx';
    end
    
    if iQuarter == 4
        filePath = q4FilePaths; 
        diaryPath = q4DiaryPaths; 
        fileQName = 'Q4.xlsx';
    end


%% lists the number of files
nPath = numel(filePath);

%% preallocate for the data from the for loop
subject_ID = cell(nPath,1);
phasor_angle_hours = cell(nPath,1);
phasor_magnitude = cell(nPath,1);

%% goes through each file and pulls the data from it and stores it in
%preallocations
for iPath = 1:nPath
    [subject_ID{iPath},phasor_angle_hours{iPath},phasor_magnitude{iPath}] = phasorTableMaker(filePath{iPath});
end
%% creates a table and adds the subject ID to the table
masterPhasorAngleTable = horzcat(subject_ID,phasor_angle_hours); 
masterPhasorMagnitudeTable = horzcat(subject_ID,phasor_magnitude); 

%% exports the tables to excel 
nowDV = datevec(datestr(now)); 
year = num2str(nowDV(1));
month = num2str(nowDV(2)); 
date = num2str(nowDV(3));
hour = num2str(nowDV(4)); 
minute = num2str(nowDV(5)); 
if numel(minute) <= 1
    minute = strcat('0',minute); 
end

dateLabel = strcat(year,'-',month,'-',date,'_',hour,minute); 
fileName = strcat('\\root\projects\AmericanCancerSociety\daysimeterMetrics\phasor',...
    dateLabel,'_',fileQName);
if ~isempty(filePath)

xlswrite(fileName, masterPhasorAngleTable,'Phasor Angle Hours');
xlswrite(fileName, masterPhasorMagnitudeTable,'Phasor Magnitude');
end


end
