*Class-Examples-5507-08-file-manipulation.sas
	author: Reagan Todd
	date created: 2025-09-25
	purpose: to understand how to manipulate dates using multiple datasets.
	license: public domain;

ods pdf file= "/home/u63903237/5507/results/todd-5507-08-date-manipulation.pdf";

libname storage "/home/u63903237/5507/data";

*Download the file transplant0.txtL from my github site. 
Refer to the data dictionary, if needed.;
options validvarname=v7; 

proc import datafile="/home/u63903237/5507/data/transplant0.txt"
    out=storage.transplant0
    dbms=dlm
    replace;
    delimiter='09'x;
    getnames=yes;
    guessingrows=MAX;
run;

proc contents data=storage.transplant0;
title1 "Proc contents of the transplant data to find original variable types.";
run;

*1. Read in the data and convert all of the dates from string format to date format.;
*All dates coded as numeric except for tx_date;
data storage.transplant0;
    set storage.transplant0;
    tx_date_formatted = .;
    if upcase(tx_date) = "NA" then tx_date_formatted =.;
    else tx_date_formatted = input(tx_date, mmddyy10.);
    format tx_date_formatted mmddyy10.;
run;

proc contents data=storage.transplant0;
title1 "Proc contents of the transplant data where all dates are numeric.";
run;

proc print data=storage.transplant0 (obs=5);
title1 "Showing the first 5 rows of data where all dates are now numeric.";

*2. Calculate the number of years between birth.dt and accept.dt. Round this number down.;
data storage.transplant0;
    set storage.transplant0;
    age_at_acceptance = int((accept_dt - birth_dt)/365.25);
run;

proc print data=storage.transplant0 (obs=10);
title1 "First 10 rows of data showing the age at acceptance.";
run;

*3. Calculate the number of days between accept.dt and tx.date, removing any rows where 
tx.date is missing.;
data storage.transplant;
    set storage.transplant0;
    if tx_date_formatted ne . then do;
        days_to_tx = tx_date_formatted - accept_dt;
    end;
    else delete;
run;

proc print data=storage.transplant0 (obs=10);
title1 "First 10 rows showing the amount of time between transplant";
title2 "acceptance and the transplant date if applicable.";
run; 

*4. Draw a graph showing patient number sorted by accept.dt. 
Use different symbols to display accept.dt, tx.date (if not missing), and fu.date.;
*first sorting by accept date;
proc sort data=storage.transplant0;
    by accept_dt;
run;

*next creating patient numbers;
data storage.transplant0;
    set storage.transplant0;
    by accept_dt;
    patient_id = _N_;
run;

*making the data long so that its easier to plot;
data storage.transplant0;
    set storage.transplant0;
	    date_type = "Accept Date";
	    date_val = accept_dt;
	    format date_val mmddyy10.; 
	    output;
	    if tx_date_formatted ne . then do;
	        date_type = "Transplant Date";
	        date_val = tx_date_formatted;
	        format date_val mmddyy10.; 
	        output;
    	end;
	    if fu_date ne . then do;
	        date_type = "Follow-up Date";
	        date_val = fu_date;
	        format date_val mmddyy10.; 
	        output;
    	end;
run;

*creating scatterplot;
proc sgplot data=storage.transplant0;
    scatter x=patient_id y=date_val / group=date_type 
        markerattrs=(symbol=circle size=4) transparency=0.2;
    yaxis label="Date";
    xaxis label="Patient Number";
    title1 "Scatterplot showing the years in which patients have a date recorded.";
    title2 "These dates include acceptance of transplant, a follow up, or the transplant.";
    footnote "Reagan Todd, 2025-09-25, SAS Version 9.4";
run;





*Do something more or less similar for the file, whas500.txt 
Refer to the data dictionary, if needed. 
There is no birthdate, but you can manipulate admitdate, disdate, and foldate. 
See if there is a way to recalculate los as a quality check.;
data storage.whas500;
    infile "/home/u63903237/5507/data/whas500.txt" dlm=' ';
    input id age gender hr sysbp diasbp bmi cvd afb sho chf av3 miord 
    mitype year
    admitdate: mmddyy10. 
    disdate: mmddyy10. 
    fdate: mmddyy10. 
    los dstat lenfol fstat;
format admitdate disdate fdate mmddyy10.; 
run;

proc contents data=storage.whas500;
title1 "Contents of WHAS500 dataset";
run;

proc print data=storage.whas500 (obs=10);
title1 "First 10 rows of the whas500 dataset.";
run;

*quality check on LOS;
data storage.whas500;
    set storage.whas500;
    calc_LOS = int(disdate - admitdate);
run;

proc print data=storage.whas500 (obs=10);
title1 "First 10 rows of data showing the calculated LOS.";
title2 "Quality check shows both LOS are the same.";
run;

*barchart for average LOS per cohort year;
proc format;
    value yearfmt
        1 = 'Cohort Year 1'
        2 = 'Cohort Year 2'
        3 = 'Cohort Year 3';
run;
data storage.whas500;
    set storage.whas500;
    format year yearfmt.; 
run;
proc sgplot data=storage.whas500;
    vbar year / response=los stat=mean;
    yaxis label="Average LOS (days)";
    xaxis label="Cohort Year";
    title1 "Average Length of Stay by Cohort Year";
    title2 "Cohort 1 had the longest average LOS of 6.3 days.";
    title3 "Cohorts 2 and 3 had similar average LOS of 5.8 days.";
    footnote "Reagan Todd, 2025-10-02, SAS version 9.4";
run;

*checking to see how the length of stay is calculated;
*FU-LOS;
data storage.whas500;
    set storage.whas500;
    calc_FU_length1 = int(fdate - disdate);
run;
proc print data=storage.whas500 (obs=10);
title1 "This does not match the dataset lenfol variable";
run;

*taking LOS into account;
data storage.whas500;
    set storage.whas500;
    calc_FU_length1 = int(fdate - admitdate);
run;
proc print data=storage.whas500 (obs=10);
title1 "This does match the dataset lenfol variable";
title2 "This suggests that the length to follow up is based upon admit day.";
run;





*Download the files cpi.csv and harry-potter.csv
These files may move to the data repository, but first they need data dictionaries.;
*importing cpi dataset;
filename cpi
	"/home/u63903237/5507/data/cpi.csv";
proc import datafile=cpi
	out=storage.cpi
	dbms=csv
	replace;
	getnames=yes;
run;
proc contents data=storage.cpi;
title1 "Proc contents from the CPI.csv file";
run;

*importing harry-potter dataset;
filename hp
	"/home/u63903237/5507/data/harry-potter.csv";
proc import datafile=hp
	out=storage.hp
	dbms=csv
	replace;
	getnames=yes;
run;
proc contents data=storage.hp;
title1 "Proc contents of the Harry Potter.csv file.";
run;

*1. Calculate two numeric variables, a four digit year and a one or two digit month 
for both datasets.;

*creating this for cpi;
*making period into a month variable;
	*inconsistencies with M01/S01;
data storage.cpi;
	set storage.cpi;
	month = input(substr(period, 2), 2.);
run;

*creating this for hp;
data storage.hp;
	set storage.hp;
	year= year(opening_date);
	month= month (opening_date);
run; 

*2. Merge the two datasets together.;
*first sorting both by year and month;
proc sort data=storage.cpi;
	by year month;
run; 

proc sort data=storage.hp;
	by year month;
run; 

data merged_hp;
    merge storage.cpi (in=a)
          storage.hp (in=b);
    by year month;
    if a and b;
run;

proc print data=merged_hp (obs=10);
title1 "The rows of the merged harry potter movie data.";
run;

*3. Calculate an inflation adjusted open weekend revenues 
(divide the opening week revenues by the cpi value) and list the Harry Potter films 
in order based on this variable.; 
*calculating inflation adjusted open weekend revenues;
data merged_hp;
    set merged_hp;
    adj_opening = weekend_gross / value;
run;

*sorting by revenue;
proc sort data=merged_hp;
    by descending adj_opening;
run;

proc print data=merged_hp noobs;
    var title weekend_gross value adj_opening opening_date;
    title1 "Harry Potter Films Sorted by Inflation-Adjusted Opening Weekend Revenue";
    title2 "Adjusting for this, the highest gross came from 2010, and least came from 2005";
    footnote "Reagan Todd, 2025-10-01, SAS version 9.4";   
run;
ods pdf close;



