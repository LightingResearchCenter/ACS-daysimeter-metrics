function nightlyData  = averageNightlyLightData(absTime,dataArray,masks,varargin)

if nargin == 4 % Optional argument provided
    operation = varargin{1}; % Use provided average type
else
    operation = 'mean';
end

operativeFunc = str2func(operation);

bedArray = masks.bed(masks.observation & masks.compliance);
dataArray = dataArray(masks.observation & masks.compliance); 

compDiff = diff(bedArray);
% compDiff = -1 = start of sleep
startIdx = compDiff == 1;
% compDiff = 1 = end of noncompliance bouts
endIdx = compDiff == -1;

nPoints = numel(bedArray);

bedValues = dataArray; 
bedValues(~bedArray) = []; 
darkValue = mode(bedValues); 

darkIdx = nan(nPoints,1); 

for iPoints = 1:nPoints
    if dataArray(iPoints) > darkValue
        darkIdx(iPoints) = 1; 
    else
        darkIdx(iPoints) = 0; 
    end
end

darkIdx = logical(darkIdx);

startTime = find(startIdx); 
endTime = find(endIdx); 

nNights = numel(startTime);

nightlyData = cell(2,nNights);

%gets the mean for each night 
for iNights = 1:nNights
    temp = dataArray(startTime(iNights):endTime(iNights));
    tempIdx = darkIdx(startTime(iNights):endTime(iNights));
    temp(tempIdx) = []; 
    startDate = datestr(absTime.localDateNum(startTime(iNights))); 
    endDate = datestr(absTime.localDateNum(endTime(iNights)));
    seperator = ' to ';
    dateLabel = horzcat(startDate,seperator,endDate);  
    nightlyData{1,iNights} = dateLabel; 
    nightlyData{2,iNights} = operativeFunc(temp); 
    
end
