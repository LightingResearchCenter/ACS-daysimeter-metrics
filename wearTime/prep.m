close all 
clear
clc

[wearTime,unWornTime,percentWorn,percentUnworn] = makeWeartimeTable();

xlswrite('wearTimeMetrics.xlsx', wearTime,'Wear Time'); 
xlswrite('wearTimeMetrics.xlsx', unWornTime,'Unworn Time'); 
xlswrite('wearTimeMetrics.xlsx', percentWorn,'Percent Worn'); 
xlswrite('wearTimeMetrics.xlsx', percentUnworn,'Percent Unworn'); 