function [lightsOnOffIdx] = onOffIdx(dataArray,masks)
%Takes the data array and creates an array of which values are above or
%below a static value. Data array has to be illumance 
bedArray = masks.bed(masks.observation & masks.compliance);
dataArray = dataArray(masks.observation & masks.compliance);

nPoints = numel(dataArray); 
%lights on or off array 
lightsOnOffIdx = NaN(nPoints,1); 
%eliminates day values from the data array
for iPoints = 1:nPoints

    if bedArray(iPoints) == 0
        dataArray(iPoints) = 0;
    end

    if dataArray(iPoints) > 3 
        lightsOnOffIdx(iPoints) = 1; 
    else 
        lightsOnOffIdx(iPoints) = 0; 
    end

end

