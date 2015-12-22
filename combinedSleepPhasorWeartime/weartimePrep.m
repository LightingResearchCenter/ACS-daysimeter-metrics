%the folder path will need to be changed to reflect where the files are 
%reset Matlab
close all 
clear
clc

% this is the folder path for the data 
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


%create the tables
[wearTime,unWornTime,percentWorn,percentUnworn,compliantBoutTimes,nonCompliantBoutTimes] = makeWeartimeTable(filePath);

%make date labels 
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
fileName = strcat('\\root\projects\AmericanCancerSociety\daysimeterMetrics\wearTimeMetrics',...
    dateLabel,'_',fileQName);
if ~isempty(filePath)

%write the tables to excel sheets
xlswrite(fileName, wearTime,'Compliance Duration');
xlswrite(fileName, unWornTime,'Non-Compliance Duration');
xlswrite(fileName, percentWorn,'Percent Compliance');
xlswrite(fileName, percentUnworn,'Percent Non-Compliance');
xlswrite(fileName, compliantBoutTimes,'Compliant Bout Bounds');
xlswrite(fileName, nonCompliantBoutTimes,'Non-Compliant Bout Bounds');
end

end
