%reset Matlab
close all 
clear
clc

%establish master path 
folderPath = '\\root\projects\AmericanCancerSociety\DaysimeterData'; 
%get file paths in an array 
filePath = getFilePath(folderPath);
%get the number of subjects
nSubjects = numel(filePath); 
%preallocate for the cell array 
    cellTemplate = cell(2,7);
    meanCla = cellTemplate;
    medianCla = cellTemplate;
    meanCs = cellTemplate;
    meanIllum = cellTemplate;
    medianIllum = cellTemplate;



for iSubjects = 1:nSubjects 
    %get CDF Data 
    currentFilePath = filePath{iSubjects};
    [absTime,relTime,epoch,light,activity,masks,subjectID,cdfData] = readAndConvertCdf(currentFilePath);
    
    %calculate required values 
    meanCla = averageNightlyLightData(absTime,light.cla,masks,'mean');
    medianCla = averageNightlyLightData(absTime,light.cla,masks,'median');
    meanCs = averageNightlyLightData(absTime,light.cs,masks,'mean');
    meanIllum = averageNightlyLightData(absTime,light.illuminance,masks,'mean');
    medianIllum = averageNightlyLightData(absTime,light.illuminance,masks,'median');
    
    %create labels for the values       
    meanClaLabel = {'Sleeping Hours'; 'Mean Cla'}; 
    medianClaLabel = {'Sleeping Hours'; 'Median Cla'}; 
    meanCsLabel = {'Sleeping Hours'; 'Mean Cs'}; 
    meanIllumLabel = {'Sleeping Hours'; 'Mean Illuminance'}; 
    medianIllumLabel = {'Sleeping Hours'; 'Median Illuminance'};
    %add the labels to the data 
    meanCla = horzcat(meanClaLabel,meanCla); 
    medianCla = horzcat(medianClaLabel,medianCla); 
    meanCs = horzcat( meanCsLabel, meanCs); 
    meanIllum = horzcat( meanIllumLabel, meanIllum); 
    medianIllum = horzcat(medianIllumLabel,medianIllum); 
    %write the data to a spreadsheet with the subject ID as the name 
    xlswrite('meanCla.xlsx', meanCla,subjectID); 
    xlswrite('medianCla.xlsx', medianCla,subjectID); 
    xlswrite('meanCs.xlsx', meanCs,subjectID); 
    xlswrite('meanIlluminance.xlsx', meanIllum,subjectID); 
    xlswrite('medianIlluminance.xlsx', medianIllum,subjectID); 
       
end