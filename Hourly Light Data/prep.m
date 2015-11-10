%reset Matlab
close all 
clear
clc
%create the tables
[meanHourlyCla,medianHourlyCla,meanHourlyIlluminance,medianHourlyIlluminance,meanHourlyCs,medianHourlyCs] = makeHourlyLightTable();
%write the tables to excel sheets
xlswrite('hourlyLight.xlsx', meanHourlyCla,'Mean Hourly CLA'); 
xlswrite('hourlyLight.xlsx', medianHourlyCla,'Median Hourly CLA'); 
xlswrite('hourlyLight.xlsx', meanHourlyIlluminance,'Mean Hourly Illuminance'); 
xlswrite('hourlyLight.xlsx', medianHourlyIlluminance,'Median Hourly Illuminance'); 
xlswrite('hourlyLight.xlsx', meanHourlyCs,'Mean Hourly Cs'); 
xlswrite('hourlyLight.xlsx', medianHourlyCs,'Median Hourly Cs'); 