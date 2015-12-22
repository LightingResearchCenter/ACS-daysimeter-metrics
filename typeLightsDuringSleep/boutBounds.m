%absTime a
function [nBouts,boutBounds,totalTime] = lightBouts(timeArray,dataArray,epoch)

baseLine = mode(dataArray); 
nPoints = numel(dataArray); 
if nPoints ~= numel(timeArray)
    error('dimensions for time and data do not match'); 
end
lightsOnIdx = logical(nPoints); 
for iPoints = 1:nPoints
    if dataArray(iPoints) > baseLine
        lightsOnIdx(iPoints) = 1; 
    else
        lightsOnIdx(iPoints) = 0; 
    end
end

findBoutBounds = diff(lightsOnIdx);
findLightTime = sum(findBoutBounds); 
totalTime = findLightTime*epoch.minutes; 

% compDiff = -1 = start of sleep
startIdx = findBoutBounds == 1;
% compDiff = 1 = end of noncompliance bouts
endIdx = findBoutBounds == -1;

startTime = find(startIdx); 
endTime = find(endIdx); 
nBouts = numel(startTime); 
boutBounds = cell(1,nBouts); 

for iBouts = 1:nBouts
    startDate = datestr(timeArray(startTime(iBouts))); 
    endDate = datestr(timeArray(endTime(iBouts)));
    seperator = ' to ';
    dateLabel = horzcat(startDate,seperator,endDate);  
    boutBounds(1,iBouts) = dateLabel; 
    
