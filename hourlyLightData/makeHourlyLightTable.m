%reset Matlab
close all 
clear
clc
masterPath = '\\root\projects\AmericanCancerSociety\DaysimeterData\';
[q1FilePaths,q2FilePaths,q3FilePaths,q4FilePaths,...
    q1DiaryPaths,q2DiaryPaths,q3DiaryPaths,q4DiaryPaths] = quarterFilePaths(masterPath);

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
        


nSubjects = numel(filePath); 



for iSubjects = 1:nSubjects 
    currentFilePath = filePath{iSubjects};
    [absTime,relTime,epoch,light,activity,masks,subjectID,cdfData] = readAndConvertCdf(currentFilePath);
    %crop the data and time array 
    display(subjectID)
    claData = light.cla(masks.observation & masks.compliance); 
    illuminanceData = light.illuminance(masks.observation & masks.compliance); 
    csData = light.cs(masks.observation & masks.compliance); 
    absTime.localCdfEpoch = absTime.localCdfEpoch(masks.observation & masks.compliance);
    if ~isempty(claData)
    %generate Dates and Data
    [dateLabels,hourLabels,condMeanIllum] = condenseData(absTime,illuminanceData,'mean');
    [~,~,condMedianIllum] = condenseData(absTime,illuminanceData,'median');
    [~,~,condMeanCla] = condenseData(absTime,claData,'mean');
    [~,~,condMedianCla] = condenseData(absTime,claData,'median');
    [~,~,condMeanCs] = condenseData(absTime,csData,'mean');
    %format Dates 
    dateHeadings = unique(dateLabels); 
    nDays = numel(dateHeadings); 
    %generate output tables
    tableCellTemplate = cell(25,nDays);
    meanIllumTable = tableCellTemplate; 
    medianIllumTable = tableCellTemplate;
    meanClaTable = tableCellTemplate;
    medianClaTable = tableCellTemplate;
    meanCsTable = tableCellTemplate;
    for iDays = 1:nDays
        %makes the heading for the 
        dateHeadingVar = dateHeadings{iDays};
        meanIllumTable{1,iDays} = dateHeadingVar; 
        medianIllumTable{1,iDays} = dateHeadingVar;
        meanClaTable{1,iDays} = dateHeadingVar;
        medianClaTable{1,iDays} = dateHeadingVar;
        meanCsTable{1,iDays} = dateHeadingVar;
        %forms index for the files 
        idx = strcmp(dateHeadings(iDays),dateLabels);
        %creates array with the data from the time range in it 
        oneDayMeanIllum = condMeanIllum(idx); 
        oneDayMedianIllum = condMedianIllum(idx);
        oneDayMeanCla = condMeanCla(idx);
        oneDayMedianCla = condMedianCla(idx);
        oneDayMeanCs = condMeanCs(idx);
        for iHours = 2:25
            meanIllumTable{iHours,iDays} = oneDayMeanIllum(iHours-1);
            medianIllumTable{iHours,iDays} = oneDayMedianIllum(iHours-1);
            meanClaTable{iHours,iDays} = oneDayMeanCla(iHours-1);
            medianClaTable{iHours,iDays} = oneDayMedianCla(iHours-1);
            meanCsTable{iHours,iDays} = oneDayMeanCs(iHours-1);
        end
 
    end
        hourLabels = unique(hourLabels);
        hourLabelHeading = 'Hours'; 
        hourLabels = vertcat(hourLabelHeading,hourLabels); 
        meanIllumTable = horzcat(hourLabels,meanIllumTable); 
        medianIllumTable = horzcat(hourLabels,medianIllumTable); 
        meanClaTable = horzcat(hourLabels,meanClaTable); 
        medianClaTable = horzcat(hourLabels,medianClaTable); 
        meanCsTable = horzcat(hourLabels,meanCsTable); 

    meanIllumFileName = strcat('\\root\projects\AmericanCancerSociety\daysimeterMetrics\meanHourlyIlluminance',...
    dateLabel,'_',fileQName);
    medianIllumFileName = strcat('\\root\projects\AmericanCancerSociety\daysimeterMetrics\medianHourlyIluminance',...
    dateLabel,'_',fileQName);
    meanClaFileName = strcat('\\root\projects\AmericanCancerSociety\daysimeterMetrics\meanHourlyCla',...
    dateLabel,'_',fileQName);
    medianClaFileName = strcat('\\root\projects\AmericanCancerSociety\daysimeterMetrics\medianHourlyCla',...
    dateLabel,'_',fileQName);
    meanCSFileName = strcat('\\root\projects\AmericanCancerSociety\daysimeterMetrics\meanHourlyCs',...
    dateLabel,'_',fileQName);

if ~isempty(filePath)
    xlswrite(meanIllumFileName, meanIllumTable,subjectID); 
    xlswrite(medianIllumFileName, medianIllumTable,subjectID); 
    xlswrite(meanClaFileName, meanClaTable,subjectID); 
    xlswrite(medianClaFileName, medianClaTable,subjectID); 
    xlswrite(meanCSFileName, meanCsTable,subjectID); 
end      
    end
end

       
    

end

