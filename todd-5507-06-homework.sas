* 

*5. Discuss how some statistics and/or graphs are easier to compute with
the tall format and other statistics and/or graphs with the wide
format.;
*Tall is good for aggregating statistics, analyzing the repeated measures
and visualizing trends over time. Wide is best for comparing different measurements
and simple descriptive statistics. Grouped bar charts are simple with tall
format.;
*6. Write a SAS program that reads in cholesterol-after-heart-attack and
displays the first ten rows.;
proc import datafile="/home/u63903237/5507/data/cholesterol-after-heart-attack.csv"
out=storage.cholesterol
dbms=csv
replace;
getnames=yes;
run;
proc print data=storage.cholesterol (obs=10);
title1 "First ten rows of the cholesterol after heart attack data.";
footnote "Reagan Todd, 2025-09-10, SAS Version 9.4";
run;
*7. Calculate descriptive statistics on group, day, and cholest.;
proc means data=storage.cholesterol;
var cholest;
title1 "Descriptive statistics for cholesterol.";
footnote "Reagan Todd, 2025-09-10, SAS Version 9.4";
run;
*frequency for patient and day;
proc freq data=storage.cholesterol;
tables patient*day / norow nocol nopercent;
title1 "Frequency count for patients and day.";
*to show the inconsistency with day 14 for some patients.;
footnote "Reagan Todd, 2025-09-10, SAS Version 9.4";
run;
*8. Draw a scatterplot of day on the x-axis and cholest on the y-axis.;
proc sgplot data=storage.cholesterol;
scatter x=day y=cholest;
xaxis label="Day" values=(1 to 15 by 1);
yaxis label="Cholesterol" min=115 max=361;
title "Scatterplot of Cholesterol by Day";
footnote "Reagan Todd, 2025-09-09, SAS Version 9.4";
run;
*9. Create three smaller files from this data: one for day equals 2,
one for day equals 4, and one for day eqauls 14. Ignore the data for
day is NA.;
data cholesterol_day2;
set storage.cholesterol;
if day = 2;
run;
data cholesterol_day4;
set storage.cholesterol;
if day = 4;
run;
data cholesterol_day14;
set storage.cholesterol;
if day = 14;
run;
*10. Merge the three files you created into one file with data in the wide
format. Calculate the correlation between cholest_2, cholest_4, and
cholest_14.;
*Will look into proc transpose;
*renaming cholesterols by the day;
data day2;
set cholesterol_day2;
rename cholest = cholest_2;
drop day;
run;
data day4;
set cholesterol_day4;
rename cholest = cholest_4;
drop day;
run;
data day14;
set cholesterol_day14;
rename cholest = cholest_14;
drop day;
run;
*Sort by patient;
proc sort data=day2;
by Patient;
run;
proc sort data=day4;
by Patient;
run;
proc sort data=day14;
by Patient;
run;
*merge;
data cholesterol_wide;
merge day2 day4 day14;
by Patient;
run;
proc print data=cholesterol_wide (obs=10);
title1 "First ten observations of the Cholesterol Wide merged data.";
footnote "Reagan Todd, 2025-09-10, SAS Version 9.4";
run;
*correlation between the days;
proc corr data=cholesterol_wide;
var cholest_2 cholest_4 cholest_14;
title1 "Those with high cholesterol at day 2 tend to have high cholesterol at day 4.";
title2 "Those with high cholesterol at day 4 tend to have high cholesterol at day 14.";
title3 "There is no significant relationship between day 2 and day 14.";
footnote "Reagan Todd, 2025-09-10, SAS Version 9.4";
run;
