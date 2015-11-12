folderPath = '\\root\projects\AmericanCancerSociety\DaysimeterData'; 

filePath = getFilePath(folderPath);

nSubjects = numel(filePath); 



for iSubjects = 1:nSubjects 
    currentFilePath = filePath{iSubjects};
    [absTime,relTime,epoch,light,activity,masks,subjectID,cdfData] = readAndConvertCdf(currentFilePath);
    %crop the data and time array 
    claData = light.cs(masks.observation & masks.compliance); 
    illuminanceData = light.cs(masks.observation & masks.compliance); 
    csData = light.cs(masks.observation & masks.compliance); 
    absTime.localCdfEpoch = absTime.localCdfEpoch(masks.observation & masks.compliance);
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
    
    xlswrite('meanIlluminance.xlsx', meanIllumTable,subjectID); 
    xlswrite('medianIlluminance.xlsx', medianIllumTable,subjectID); 
    xlswrite('meanCla.xlsx', meanClaTable,subjectID); 
    xlswrite('medianCla.xlsx', medianClaTable,subjectID); 
    xlswrite('meanCs.xlsx', meanCsTable,subjectID); 
       
end
