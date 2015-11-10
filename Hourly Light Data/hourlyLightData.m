
%filePath = 'C:\DaysimeterData\A10207\marked_download\A10207_SEP15_194.cdf';
%[absTime,relTime,epoch,light,activity,masks,subjectID,cdfData] = readAndConvertCdf(filePath);
function [meanOneLineHourlyCla, medianOneLineHourlyCla, meanOneLineHourlyIlluminance,...
    medianOneLineHourlyIlluminance, meanOneLineHourlyCs, medianOneLineHourlyCs,nHours]= hourlyLightData(relTime,light,subjectID,masks,epoch)

claData = light.cs(masks.observation & masks.compliance); 
illuminanceData = light.cs(masks.observation & masks.compliance); 
csData = light.cs(masks.observation & masks.compliance); 

relTime_minutes = relTime.minutes(masks.observation & masks.compliance);

nHours = ceil(numel(relTime_minutes)*epoch.minutes/60); 

hourMarkers = cell((nHours+1),1); 
hourMarkers{1} = 0; 
for iHourMarkers = 1:nHours
    hourMarkers{iHourMarkers+1} = iHourMarkers*(60/epoch.minutes); 
end
hourMarkers{end} = numel(relTime_minutes); 

meanHourlyCla = cell(1,nHours); 
medianHourlyCla = cell(1,nHours);
meanHourlyIlluminance = cell(1,nHours); 
medianHourlyIlluminance = cell(1,nHours);
meanHourlyCs = cell(1,nHours); 
medianHourlyCs = cell(1,nHours);

for iHours = 1:nHours
    hourClaArray = claData(hourMarkers{iHours}+1:hourMarkers{iHours+1});
    meanHourlyCla{1,iHours} = mean(hourClaArray);
    medianHourlyCla{1,iHours} = median(hourClaArray); 
    hourIlluminanceArray = illuminanceData(hourMarkers{iHours}+1:hourMarkers{iHours+1});
    meanHourlyIlluminance{1,iHours} = mean(hourIlluminanceArray);
    medianHourlyIlluminance{1,iHours} = median(hourIlluminanceArray); 
    hourCsArray = csData(hourMarkers{iHours}+1:hourMarkers{iHours+1});
    meanHourlyCs{1,iHours} = mean(hourCsArray);
    medianHourlyCs{1,iHours} = median(hourCsArray); 
end
 
meanOneLineHourlyCla = horzcat(subjectID,meanHourlyCla); 
medianOneLineHourlyCla = horzcat(subjectID,medianHourlyCla);
meanOneLineHourlyIlluminance = horzcat(subjectID,meanHourlyIlluminance); 
medianOneLineHourlyIlluminance = horzcat(subjectID,medianHourlyIlluminance);
meanOneLineHourlyCs = horzcat(subjectID,meanHourlyCs); 
medianOneLineHourlyCs = horzcat(subjectID,medianHourlyCs);

end

