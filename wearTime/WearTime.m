
folderPath = 'C:\DaysimeterData'; 

filePath = getFilePath(folderPath);


nSubjects = numel(filePath); 

templateCell = cell(nSubjects,2);

wearTime = templateCell; 
unWornTime = templateCell; 
percentWorn = templateCell; 
percentUnworn = templateCell; 

for iSubjects = 1:nSubjects 
    currentFilePath = filePath{iSubjects};
    [absTime,relTime,epoch,light,activity,masks,subjectID,cdfData] = readAndConvertCdf(currentFilePath);
    [useTime,nonuseTime,usePrcnt,nonusePrcnt] = deviceUseMinutes(masks,epoch);
    wearTime{iSubjects,1} = subjectID;
    unWornTime{iSubjects,1} = subjectID; 
    percentWorn{iSubjects,1} = subjectID; 
    percentUnworn{iSubjects,1} = subjectID;
    
    wearTime{iSubjects,2} = useTime;
    unWornTime{iSubjects,2} = nonuseTime; 
    percentWorn{iSubjects,2} = usePrcnt; 
    percentUnworn{iSubjects,2} = nonusePrcnt; 
    
    end

wearTimeHeading = {'subjectID' 'Wear Time'}; 
unWornTimeHeading = {'subjectID' 'unWorn Time'}; 
percentWornHeading = {'subjectID' 'Percent Worn'}; 
percentUnwornHeading = {'subjectID' 'Percent Unworn'}; 

wearTime = vertcat(wearTimeHeading,wearTime); 
unWornTime = vertcat(unWornTimeHeading,unWornTime); 
percentWorn = vertcat(percentWornHeading,percentWorn); 
percentUnworn = vertcat(percentUnwornHeading,percentUnworn); 
   
    