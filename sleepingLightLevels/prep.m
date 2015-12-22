%reset Matlab
close all 
clear
clc
warning ('off','all')

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
%display total number of subjects
display(nSubjects)

for iSubjects = 1:nSubjects 
    %get CDF Data 
    currentFilePath = filePath{iSubjects};
    [absTime,relTime,epoch,light,activity,masks,subjectID,cdfData] = readAndConvertCdf(currentFilePath);
    
    %probe to display the current subject
    display(iSubjects)    

    %get the idx for lights on/off using illumance 
    [lightsOnOffIdx] = onOffIdx(light.illuminance,masks);
    
    
    %calculate required values 
    meanCla = averageNightlyLightData(absTime,light.cla,masks,lightsOnOffIdx,'mean');
    medianCla = averageNightlyLightData(absTime,light.cla,masks,lightsOnOffIdx,'median');
    meanCs = averageNightlyLightData(absTime,light.cs,masks,lightsOnOffIdx,'mean');
    meanIllum = averageNightlyLightData(absTime,light.illuminance,masks,lightsOnOffIdx,'mean');
    medianIllum = averageNightlyLightData(absTime,light.illuminance,masks,lightsOnOffIdx,'median');
    
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
    xlswrite('meanNightlyCla.xlsx', meanCla,subjectID); 
    xlswrite('medianNightlyCla.xlsx', medianCla,subjectID); 
    xlswrite('meanNightlyCs.xlsx', meanCs,subjectID); 
    xlswrite('meanNightlyIlluminance.xlsx', meanIllum,subjectID); 
    xlswrite('medianNightlyIlluminance.xlsx', medianIllum,subjectID); 

end

warning ('on','all')