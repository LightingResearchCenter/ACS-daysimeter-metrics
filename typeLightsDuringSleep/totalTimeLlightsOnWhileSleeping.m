close all 
clear
clc
folderPath = '\\root\projects\AmericanCancerSociety\DaysimeterData'; 

filePath = getFilePath(folderPath);

nSubjects = numel(filePath); 



for iSubjects = 1:nSubjects 
    currentFilePath = filePath{iSubjects};
    [absTime,relTime,epoch,light,activity,masks,subjectID,cdfData] = readAndConvertCdf(currentFilePath);
%% open CDF
%filePath = 'C:\Users\runef_000\Documents\GitHub\cdfPractice\A11633\cdf\7;00 - 9;00\A11637_SEP15_191.cdf';
%[absTime,relTime,epoch,light,activity,masks,subjectID,cdfData] = readAndConvertCdf(filePath);
%% crop Data 
bedArray = masks.bed(masks.observation & masks.compliance);
dataArray = light.illuminance(masks.observation & masks.compliance); 
%% find beginning and end of sleep 
compDiff = diff(bedArray);
% compDiff = -1 = start of sleep
startIdx = compDiff == 1;
% compDiff = 1 = end of noncompliance bouts
endIdx = compDiff == -1;

startTime = find(startIdx); 
endTime = find(endIdx); 

nNights = numel(startTime);
%nightlyData = cell(2,nNights);


%% set threshold presets
filterOne = 70; 
sigDigs = 3; 
%% create multiple threshold multipliers
threshMult = 1:.05:2.5;
nThresh = numel(threshMult);
%% storage for data on different thresholds 
nightlyData = cell(nThresh+1,nNights);  
dateLabelTrue = 0;
lightsOnIdx = NaN(numel(dataArray),1); 

%% calculate threshold 
finalThreshold = calcThreshold(dataArray,filterOne,sigDigs);
%% different thresholds 
for iThresh = 1:nThresh

customThresh = finalThreshold*threshMult(iThresh);
display(customThresh)

for iNights = 1:nNights
    nightData = dataArray(startTime(iNights):endTime(iNights));
    nightlyLightsOnIdx = lightsOnIdx(startTime(iNights):endTime(iNights));
    for iElements = 1:numel(nightData)
        if nightData(iElements) > customThresh
            nightlyLightsOnIdx(iElements) = 1; 
        else
            nightlyLightsOnIdx(iElements) = 0; 
        end
    end
    lightsOnTime = sum(nightlyLightsOnIdx);
    lightsOnMinutes = lightsOnTime*epoch.minutes;
    
    startDate = datestr(absTime.localDateNum(startTime(iNights)));
    endDate = datestr(absTime.localDateNum(endTime(iNights)));
    seperator = ' to ';
    dateLabel = horzcat(startDate,seperator,endDate);
    if dateLabelTrue <= 4
        nightlyData{1,iNights} = dateLabel;
        dateLabelTrue = dateLabelTrue+1; 
    end
    nightlyData{iThresh+1,iNights} = lightsOnMinutes;
end
end
threshMultLabel = threshMult.';
threshMultLabel = num2cell(threshMultLabel); 
threshLabel = {'threshold Multiplier'}; 
threshMultLabel = vertcat(threshLabel,threshMultLabel); 
labeledData = horzcat(threshMultLabel,nightlyData);

xlswrite('thresholdMultiplierTest.xlsx', labeledData,subjectID);

end

