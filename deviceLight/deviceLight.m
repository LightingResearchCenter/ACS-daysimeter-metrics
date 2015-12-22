function deviceLightRow  = deviceLight(absTime,dataArray,cct,masks)

bedArray = masks.bed(masks.observation & masks.compliance);
dataArray = dataArray(masks.observation & masks.compliance); 
cctArray = light.cct(masks.observation & masks.compliance); 
timeDup = absTime; 
timeArray = timeDup.localCdfEpoch(masks.observation & masks.compliance); 


compDiff = diff(bedArray);
% compDiff = -1 = start of sleep
startIdx = compDiff == 1;
startTime = find(startIdx); 
nNights = numel(startTime); 
hrB4Idx = NaN(nNights,1); 

for iNights = 1:nNights
    hrB4Idx(iNights,1) = startTime(iNights)-(60/epoch.minutes);
    lightData = dataArray(hrB4Idx(iNights):startTime(iNights));
    hrB4cct = cctArray(hrB4Idx(iNights): startTime(iNights)); 
    hrB4Start = 
    lightDataCount = numel(lightData); 
    hrB4LightCct = NaN(nNights);
    for iLightDataCount = 1:lightDataCount
        if lightData(iLightDataCount) >= (mode(lightData)); 
            hrB4LightCct(iLightDataCount) = hrB4cct(iLightDataCount); 
        end
    end
    
         
            
end







