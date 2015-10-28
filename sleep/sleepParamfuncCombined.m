function [assumedSleepTime,reportedSleepTime,sleepEfficiency,timesWokeWhileSleeping ] = sleepParamfuncCombined()

%gets the paths for both of the diary and cdfs in two columns 
filePaths = getDiaryPath(); 
%gets the number of files 
pathSize = size(filePaths); 
%trying to figure out what to preallocate so that the data from the for
%loop will be saved outside of the for loop.
maxCount = 7; 
nSubjects = pathSize(1); 

heading = {'subjectID ', 'night 1 ', 'night 2 ', 'night 3 ', 'night 4 ', 'night 5 ', 'night 6 ', 'night 7 '};
cellTemplate = cell(nSubjects+1,maxCount+1);
assumedSleepTime = cellTemplate; 
%assumedSleepTime(2:nSubjects+1,1) = subject_ID(); 
assumedSleepTime(1,:) = heading; 

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


subjectSleepData = cell(pathSize(1),1);
subject_ID = cell(pathSize(1),1);
totalEle = cell(pathSize(1),1);
for iPath = 1:pathSize
    %this opens and converts the cdf
    [absTime,relTime,epoch,light,activity,masks,subjectID] = readAndConvertCdf(filePaths{iPath,1});
    %reads the diary and outputs the arrays and offset 
    [bedTimeArray,riseTimeArray,offset] = readDiary(filePaths{iPath,2});
    %creates the start time and end time array 
    analysisStartTime = bedTimeArray  - 20/(60*24);
    analysisEndTime   = riseTimeArray + 20/(60*24);
    %calcuates the number of nights in the set 
    nNight = numel(bedTimeArray);
    %preallocate so that the data can be saved outside of the nested for
    %loop 
    dailySleep = cell(nNight,1);
    assumedSleepTime{iPath+1} = subjectID;
    reportedSleepTime{iPath+1} = subjectID;
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
        reportedSleepTime{iPath+1,iNights+1} = [dailySleep{iNights,1}.actualSleepTime]; 
        sleepEfficiency{iPath+1,iNights+1} =  [dailySleep{iNights,1}.sleepEfficiency]; 
        timesWokeWhileSleeping{iPath+1,iNights+1} =  [dailySleep{iNights,1}.wakeBouts]; 
    end
     %func = @(s) isfield(s,'sleepEfficiency');
     %idx = cellfun(func,dailySleep);
     %dailySleepStruct = [dailySleep{idx}];
     %subjectSleepData{iPath,1} = dailySleepStruct;
     %totalEle{iPath,1} = numel(dailySleepStruct);
end

xlswrite('sleepMetrics.xlsx',assumedSleepTime,'assumedSleepTime'); 
xlswrite('sleepMetrics.xlsx',reportedSleepTime,'reportedSleepTime'); 
xlswrite('sleepMetrics.xlsx',sleepEfficiency,'sleepEfficiency'); 
xlswrite('sleepMetrics.xlsx',timesWokeWhileSleeping,'timesWokenWhileSleeping'); 
%winopen('sleepmetrics.xlsx')
