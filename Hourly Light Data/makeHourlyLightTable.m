function [meanHourlyCla,medianHourlyCla,meanHourlyIlluminance,...
    medianHourlyIlluminance,meanHourlyCs,medianHourlyCs] = makeHourlyLightTable()
folderPath = '\\root\projects\AmericanCancerSociety\DaysimeterData'; 

filePath = getFilePath(folderPath);

nSubjects = numel(filePath); 

%preallocate for subject data

templateCell = cell(nSubjects,250);

meanHourlyCla = templateCell; 
medianHourlyCla = templateCell; 
meanHourlyIlluminance = templateCell; 
medianHourlyIlluminance = templateCell; 
meanHourlyCs = templateCell; 
medianHourlyCs = templateCell; 

for iSubjects = 1:nSubjects 
    currentFilePath = filePath{iSubjects};
    [absTime,relTime,epoch,light,activity,masks,subjectID,cdfData] = readAndConvertCdf(currentFilePath);
    [meanOneLineHourlyCla, medianOneLineHourlyCla, meanOneLineHourlyIlluminance,...
    medianOneLineHourlyIlluminance, meanOneLineHourlyCs, medianOneLineHourlyCs,nHours]= hourlyLightData(relTime,light,subjectID,masks,epoch); 
    
    range = 1:nHours+1;

    meanHourlyCla(iSubjects,range) = meanOneLineHourlyCla(1:end); 
    medianHourlyCla(iSubjects,range) = medianOneLineHourlyCla(1:end); 
    meanHourlyIlluminance(iSubjects,range) = meanOneLineHourlyIlluminance(1:end); 
    medianHourlyIlluminance(iSubjects,range) = medianOneLineHourlyIlluminance(1:end); 
    meanHourlyCs(iSubjects,range) = meanOneLineHourlyCs(1:end); 
    medianHourlyCs(iSubjects,range) = medianOneLineHourlyCs(1:end); 
end
