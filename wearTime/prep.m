%the folder path will need to be changed to reflect where the files are 
%reset Matlab
close all 
clear
clc
%create the tables
[wearTime,unWornTime,percentWorn,percentUnworn,compliantBoutTimes,nonCompliantBoutTimes] = makeWeartimeTable();
%write the tables to excel sheets
xlswrite('wearTimeMetrics.xlsx', wearTime,'Compliance Duration'); 
xlswrite('wearTimeMetrics.xlsx', unWornTime,'Non-Compliance Duration'); 
xlswrite('wearTimeMetrics.xlsx', percentWorn,'Percent Compliance'); 
xlswrite('wearTimeMetrics.xlsx', percentUnworn,'Percent Non-Compliance'); 
xlswrite('wearTimeMetrics.xlsx', compliantBoutTimes,'Compliant Bout Bounds'); 
xlswrite('wearTimeMetrics.xlsx', nonCompliantBoutTimes,'Non-Compliant Bout Bounds'); 