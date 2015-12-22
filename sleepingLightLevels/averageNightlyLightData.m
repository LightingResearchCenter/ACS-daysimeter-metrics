function nightlyData  = averageNightlyLightData(absTime,dataArray,masks,lightsOnOffIdx,varargin)

if nargin == 5 % Optional argument provided
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

lightsOnOffIdx = logical(lightsOnOffIdx);

startTime = find(startIdx); 
endTime = find(endIdx); 

nNights = numel(startTime);

nightlyData = cell(2,nNights);

%gets the mean for each night 
for iNights = 1:nNights
    temp = dataArray(startTime(iNights):endTime(iNights));
    tempIdx = lightsOnOffIdx(startTime(iNights):endTime(iNights));
    temp(tempIdx) = [];
    startDate = datestr(absTime.localDateNum(startTime(iNights))); 
    endDate = datestr(absTime.localDateNum(endTime(iNights)));
    seperator = ' to ';
    dateLabel = horzcat(startDate,seperator,endDate);  
    nightlyData{1,iNights} = dateLabel; 
    nightlyData{2,iNights} = operativeFunc(temp); 
    
end
