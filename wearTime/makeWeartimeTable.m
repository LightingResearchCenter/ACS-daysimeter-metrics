function [wearTime,unWornTime,percentWorn,percentUnworn,compliantBoutTimes,nonCompliantBoutTimes] = makeWeartimeTable()
folderPath = '\\root\projects\AmericanCancerSociety\DaysimeterData'; 

filePath = getFilePath(folderPath);

nSubjects = numel(filePath); 

%preallocate for subject data

templateCell = cell(nSubjects,2);

wearTime = templateCell; 
unWornTime = templateCell; 
percentWorn = templateCell; 
percentUnworn = templateCell; 
compliantBoutTimes = cell(nSubjects,21); 
nonCompliantBoutTimes = cell(nSubjects,21); 


%generate data for a subject and then store it in the preallocated cells
for iSubjects = 1:nSubjects 
    currentFilePath = filePath{iSubjects};
    [absTime,relTime,epoch,light,activity,masks,subjectID,cdfData] = readAndConvertCdf(currentFilePath);
    [useTime,nonuseTime,usePrcnt,nonusePrcnt] = deviceUseMinutes(masks,epoch);
    [oneLine,nonCompliantOneLine] = weartimeIntervals(masks,absTime);
    
    wearTime{iSubjects,1} = subjectID;
    unWornTime{iSubjects,1} = subjectID; 
    percentWorn{iSubjects,1} = subjectID;
    percentUnworn{iSubjects,1} = subjectID;
    compliantBoutTimes{iSubjects,1} = subjectID;
    nonCompliantBoutTimes{iSubjects,1} = subjectID;
        
    wearTime{iSubjects,2} = useTime;
    unWornTime{iSubjects,2} = nonuseTime; 
    percentWorn{iSubjects,2} = usePrcnt; 
    percentUnworn{iSubjects,2} = nonusePrcnt; 
    compliantBoutTimes(iSubjects,2:numel(oneLine)+1) = oneLine(1:numel(oneLine));
    nonCompliantBoutTimes(iSubjects,2:numel(oneLine)+1) = oneLine(1:numel(oneLine));
end

%create the headings for the columns
wearTimeHeading = {'subjectID' 'Compliance Duration (minutes)'}; 
unWornTimeHeading = {'subjectID' 'Non-Compliance Duration (minutes)'}; 
percentWornHeading = {'subjectID' 'Percent Compliance'}; 
percentUnwornHeading = {'subjectID' 'Percent Non-Compliance'}; 
compliantBoutHeading = {'subjectID' 'Compliant Bout Interval Start' 'compliantBout Interval End'...
    'Compliant Bout Interval Start' 'Compliant Bout Interval End'...
    'Compliant Bout Interval Start' 'Compliant Bout Interval End'...
    'Compliant Bout Interval Start' 'Compliant Bout Interval End'...
    'Compliant Bout Interval Start' 'Compliant Bout Interval End'...
    'Compliant Bout Interval Start' 'Compliant Bout Interval End'...
    'Compliant Bout Interval Start' 'Compliant Bout Interval End'...   
    'Compliant Bout Interval Start' 'Compliant Bout Interval End'...
    'Compliant Bout Interval Start' 'Compliant Bout Interval End'...
    'Compliant Bout Interval Start' 'Compliant Bout Interval End'...
    'Compliant Bout Interval Start' 'Compliant Bout Interval End'};

nonCompliantBoutHeading = {'subjectID' 'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
    'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
    'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
    'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
    'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
    'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
    'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
    'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
    'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
    'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
    'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'};

%attach the headings to the data 
wearTime = vertcat(wearTimeHeading,wearTime); 
unWornTime = vertcat(unWornTimeHeading,unWornTime); 
percentWorn = vertcat(percentWornHeading,percentWorn); 
percentUnworn = vertcat(percentUnwornHeading,percentUnworn);
compliantBoutTimes = vertcat(compliantBoutHeading,compliantBoutTimes);
nonCompliantBoutTimes = vertcat(nonCompliantBoutHeading,nonCompliantBoutTimes);

end




