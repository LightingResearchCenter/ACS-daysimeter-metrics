%this script outputs the sleep metrics, weartime metrics, and phasor metrics
    %to one workbook with a metric per sheet 
%reset Matlab
close all 
clear
clc

[parentDir,~,~] = fileparts(pwd);
[githubDir,~,~] = fileparts(parentDir);
circadianDir = fullfile(githubDir,'circadian');
acsDir = fullfile(githubDir,'ACS');
addpath(parentDir, circadianDir, acsDir);

%**************************************************************************
%Create date Label 
dateLabel = datestr(now,'yyyy-mm-dd_HHMM');

%**************************************************************************
%Takes the master Path and outputs lists of quarter files and diaries. 
masterPath = '\\root\projects\AmericanCancerSociety\DaysimeterData\';
[q1FilePaths,q2FilePaths,q3FilePaths,q4FilePaths,q1DiaryPaths,q2DiaryPaths,...
    q3DiaryPaths,q4DiaryPaths] = quarterFilePaths(masterPath);

%**************************************************************************
%for each quarter the whole loop runs and outputs a seperate workbook
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
    %establish fileName for the rest of the script
    fileName = strcat('\\root\projects\AmericanCancerSociety\daysimeterMetrics\combinedMetrics',...
        dateLabel,'_',fileQName);
    % lists the number of files
    nPath = numel(filePath);
    
%**************************************************************************
    %All the preallocation 
    %PHASOR 
    subjectIDArray = cell(nPath,1);
    phasor_angle_hours = cell(nPath,1);
    phasor_magnitude = cell(nPath,1);
    %WEARTIME
    nSubjects = numel(filePath); 
    templateCell = cell(nSubjects,2);
    wearTime = templateCell;
    unWornTime = templateCell;
    percentWorn = templateCell;
    percentUnworn = templateCell;
    compliantBoutTimes = cell(nSubjects,31); 
    nonCompliantBoutTimes = cell(nSubjects,31); 
    %MEAN WAKING CS
    meanWakingCS = templateCell; 
    %SLEEP
    maxCount = 7;
    nSubjects = nPath;
    heading = {'subjectID ', 'night 1 ', 'night 2 ', 'night 3 ', 'night 4 ', 'night 5 ', 'night 6 ', 'night 7 '};
    cellTemplate = cell(nSubjects+1,maxCount+1);
    assumedSleepTime = cellTemplate;
        %assumedSleepTime(2:nSubjects+1,1) = subject_ID(); 
    assumedSleepTime(1,:) = heading;
    actualSleepPercent = cellTemplate;
        %reportedSleepTime(2:nSubjects+1,1) = subject_ID(); 
    actualSleepPercent(1,:) = heading;
    sleepOnsetLatency = cellTemplate;
        %reportedSleepTime(2:nSubjects+1,1) = subject_ID(); 
    sleepOnsetLatency(1,:) = heading;
       
    reportedSleepTime = cellTemplate;
        %reportedSleepTime(2:nSubjects+1,1) = subject_ID(); 
    reportedSleepTime(1,:) = heading;
    sleepEfficiency = cellTemplate; 
        %sleepEfficiency(2:nSubjects+1,1) = subject_ID(); 
    sleepEfficiency(1,:) = heading; 
    timesWokeWhileSleeping = cellTemplate; 
        %timesWokeWhileSleeping(2:nSubjects+1,1) = subject_ID(); 
    timesWokeWhileSleeping(1,:) = heading; 
    param = struct('timeInBed',              {'NaN'},...
                   'sleepStart',             {'NaN'},...
                   'sleepEnd',               {'NaN'},...
                   'assumedSleepTime',       {'NaN'},...
                   'threshold',              {'NaN'},...
                   'actualSleepTime',        {'NaN'},...
                   'actualSleepPercent',     {'NaN'},...
                   'actualWakeTime',         {'NaN'},...
                   'actualWakePercent',      {'NaN'},...
                   'sleepEfficiency',        {'NaN'},...
                   'sleepLatency',           {'NaN'},...
                   'sleepBouts',             {'NaN'},...
                   'wakeBouts',              {'NaN'},...
                   'meanSleepBoutTime',      {'NaN'},...
                   'meanWakeBoutTime',       {'NaN'},...
                   'immobileTime',           {'NaN'},...
                   'immobilePercent',        {'NaN'},...
                   'mobileTime',             {'NaN'},...
                   'mobilePercent',          {'NaN'},...
                   'immobileBouts',          {'NaN'},...
                   'mobileBouts',            {'NaN'},...
                   'meanImmobileBoutTime',   {'NaN'},...
                   'meanMobileBoutTime',     {'NaN'},...
                   'immobile1MinBouts',      {'NaN'},...
                   'immobile1MinPercent',    {'NaN'},...
                   'totalActivityScore',     {'NaN'},...
                   'meanActivityScore',      {'NaN'},...
                   'meanScoreActivePeriods', {'NaN'},...
                   'moveAndFragIndex',       {'NaN'});
 
%**************************************************************************
%DATA COMPUTATION
    for iPath = 1:nPath 
        [absTime,relTime,epoch,light,activity,masks,subjectID,cdfData] = readAndConvertCdf(filePath{iPath});
    if sum(masks.observation(masks.compliance)) > 0
%Phasor output
        [subjectIDArray{iPath},phasor_angle_hours{iPath},phasor_magnitude{iPath}] = phasorTableMaker(absTime,relTime,epoch,light,activity,masks,subjectID,cdfData);
%Weartime
        wearTime{iPath,1} = subjectID;
        unWornTime{iPath,1} = subjectID; 
        percentWorn{iPath,1} = subjectID;
        percentUnworn{iPath,1} = subjectID;
        compliantBoutTimes{iPath,1} = subjectID;
        nonCompliantBoutTimes{iPath,1} = subjectID;
        [wearTime{iPath,2},unWornTime{iPath,2},percentWorn{iPath,2},percentUnworn{iPath,2},oneLine,nonCompliantOneLine] = makeWeartimeTable(absTime,relTime,epoch,light,activity,masks,subjectID,cdfData);
        compliantBoutTimes(iPath,2:numel(oneLine) + 1) = oneLine(1:numel(oneLine));
        nonCompliantBoutTimes(iPath,2:numel(nonCompliantOneLine) + 1) = nonCompliantOneLine(1:numel(nonCompliantOneLine));

        %mean Waking CS 
        meanWakingCS{iPath,1} = subjectID;
        dailyCS = light.cs(masks.compliance & masks.observation & ~masks.bed);
        meanWakingCS{iPath,2} = mean(dailyCS);
        
%Sleep
    %reads the diary and outputs the arrays and offset 
    [bedTimeArray,riseTimeArray,offset] = readDiary(diaryPath{iPath,1});
    %creates the start time and end time array 
    analysisStartTime = bedTimeArray  - 20/(60*24);
    analysisEndTime = riseTimeArray + 20/(60*24);
    %calcuates the number of nights in the set 
    nNight = numel(bedTimeArray);
    %preallocate so that the data can be saved outside of the nested for
    %loop 
    dailySleep = cell(nNight,1);
    assumedSleepTime{iPath+1} = subjectID;
    reportedSleepTime{iPath+1} = subjectID;
    actualSleepPercent{iPath+1} = subjectID;
    sleepOnsetLatency{iPath+1} = subjectID;
    sleepEfficiency{iPath+1} = subjectID;
    timesWokeWhileSleeping{iPath+1} = subjectID;
        for iNights = 1:nNight
            %matlab doesnt like the dailySleep(iNights,1) can you not store a
            %struct in a cell? 
            dailySleep{iNights,1} = sleep.sleep(absTime.localDateNum,activity,epoch,...
            analysisStartTime(iNights),analysisEndTime(iNights),bedTimeArray(iNights),...
            riseTimeArray(iNights),'auto');
        if isempty((dailySleep{iNights,1}.sleepEfficiency) | dailySleep{iNights,1}.sleepEfficiency == 0)
                dailySleep{iNights,1} = param; 
        end
        assumedSleepTime{iPath+1,iNights+1} = [dailySleep{iNights,1}.assumedSleepTime]; 
        actualSleepPercent{iPath+1,iNights+1} = [dailySleep{iNights,1}.actualSleepPercent];
        sleepOnsetLatency{iPath+1,iNights + 1} = [dailySleep{iNights,1}.sleepLatency];
        reportedSleepTime{iPath+1,iNights+1} = [dailySleep{iNights,1}.actualSleepTime]; 
        sleepEfficiency{iPath+1,iNights+1} =  [dailySleep{iNights,1}.sleepEfficiency]; 
        timesWokeWhileSleeping{iPath+1,iNights+1} =  [dailySleep{iNights,1}.wakeBouts]; 
         end
    end
    end
%**************************************************************************  
    %all of the output manipulation
    %PHASOR 
    masterPhasorAngleTable = horzcat(subjectIDArray,phasor_angle_hours); 
    masterPhasorMagnitudeTable = horzcat(subjectIDArray,phasor_magnitude); 
    angleHeading = {'subject ID' 'Phasor Angle Hours'};
    magnitudeHeading = {'subjec ID' 'Phasor Magnitude'};
    masterPhasorAngleTable = vertcat(angleHeading,masterPhasorAngleTable); 
    masterPhasorMagnitudeTable = vertcat(magnitudeHeading,masterPhasorMagnitudeTable); 
    %MEAN DAILY CS
    meanWakingCSHeading = {'subjectID' 'Mean Waking CS'}; 
    %WEARTIME
    %create the headings for the columns
    wearTimeHeading = {'subjectID' 'Compliance Duration (minutes)'}; 
    unWornTimeHeading = {'subjectID' 'Non-Compliance Duration (minutes)'}; 
    percentWornHeading = {'subjectID' 'Percent Compliance'}; 
    percentUnwornHeading = {'subjectID' 'Percent Non-Compliance'}; 
    compliantBoutHeading = {'subjectID'... 
        'Compliant Bout Interval Start' 'Compliant Bout Interval End'...
        'Compliant Bout Interval Start' 'Compliant Bout Interval End'...
        'Compliant Bout Interval Start' 'Compliant Bout Interval End'...
        'Compliant Bout Interval Start' 'Compliant Bout Interval End'...
        'Compliant Bout Interval Start' 'Compliant Bout Interval End'...
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

    nonCompliantBoutHeading = {'subjectID' ...
        'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
        'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
        'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
        'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
        'nonCompliant Bout Interval Start' 'nonCompliant Bout Interval End'...
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
    emptyCNightsIdx = ~all(cellfun(@isempty,compliantBoutTimes),1); 
    emptyNcNightsIdx = ~all(cellfun(@isempty,nonCompliantBoutTimes),1); 
    wearTime = vertcat(wearTimeHeading,wearTime); 
    unWornTime = vertcat(unWornTimeHeading,unWornTime); 
    percentWorn = vertcat(percentWornHeading,percentWorn); 
    percentUnworn = vertcat(percentUnwornHeading,percentUnworn);
    compliantBoutTimes = vertcat(compliantBoutHeading,compliantBoutTimes);
    nonCompliantBoutTimes = vertcat(nonCompliantBoutHeading,nonCompliantBoutTimes);
    compliantBoutTimesCropped = compliantBoutTimes(:,emptyCNightsIdx); 
    nonCompliantBoutTimesCropped = nonCompliantBoutTimes(:,emptyNcNightsIdx); 
    meanWakingCS = vertcat(meanWakingCSHeading,meanWakingCS); 
%**************************************************************************
    %XLSWRITES
    if ~isempty(filePath)
        %PHASOR
        xlswrite(fileName, masterPhasorAngleTable,'Phasor Angle Hours');
        xlswrite(fileName, masterPhasorMagnitudeTable,'Phasor Magnitude');
        %WEARTIME
        xlswrite(fileName, wearTime,'Compliance Duration');
        xlswrite(fileName, unWornTime,'Non-Compliance Duration');
        xlswrite(fileName, percentWorn,'Percent Compliance');
        xlswrite(fileName, percentUnworn,'Percent Non-Compliance');
        xlswrite(fileName, compliantBoutTimesCropped,'Compliant Bout Bounds');
        xlswrite(fileName, nonCompliantBoutTimesCropped,'Non-Compliant Bout Bounds');
        %SLEEP 
        xlswrite(fileName,assumedSleepTime,'assumedSleepTime');
        xlswrite(fileName,actualSleepPercent,'actualSleepPercent');
        xlswrite(fileName,sleepOnsetLatency,'sleepOnsetLatency');
        xlswrite(fileName,meanWakingCS,'meanWakingCS');
        xlswrite(fileName,reportedSleepTime,'reportedSleepTime');
        xlswrite(fileName,sleepEfficiency,'sleepEfficiency');
        xlswrite(fileName,timesWokeWhileSleeping,'timesWokenWhileSleeping');
    end
   
    
end

