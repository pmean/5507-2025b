*Programming_Assignment-5507-08-file-manipulation.sas
	author: Reagan Todd
	date created: 2025-09-25
	purpose: to understand how to manipulate dates using the acupuncture dataset.
	license: public domain;

ods pdf file= "/home/u63903237/5507/results/todd-5507-08-date-manipulation.pdf";

libname storage "/home/u63903237/5507/data";

*1. Read in the data treating date_randomized as a string. 
Then use a SAS function to convert the string format to a date.;

*data imported treating date_randomized as a string;
filename acudata 
	 "/home/u63903237/5507/data/acupuncture1.csv";
data storage.acupuncture;
	infile acudata delimiter="," firstobs= 2;
	input	
	id
	age
	sex
	migraine
	chronicity
	acupuncturist
	date_randomized: $10.;
run;

proc print data=storage.acupuncture (obs=15);
	title1 "Here are the first 15 rows of the acupuncture data";
run;

*using input statement to convert strings to dates for date_randomized;
data storage.F_acupuncture;
	set storage.acupuncture;
		day = scan(date_randomized, 1, '/');
    	month   = scan(date_randomized, 2, '/');
    	year  = scan(date_randomized, 3, '/');

	if length(year) = 2 then do;
        if input(year, 2.) < 30 then year = cats('20', year);
        else year = cats('19', year);
    end;
    
   	month = put(input(month, best.), z2.);
	day   = put(input(day, best.), z2.);
    
	num_date = mdy(input(month, best.), input(day, best.), input(year, best.));
    format num_date mmddyy10.;
run; 
proc print data=storage.F_acupuncture (obs=15);
	title1 "Here are the first 15 rows of the acupuncture data, where 
	the date_randomized is numeric";
run;

proc contents data=storage.F_acupuncture;
run;

*3. Create a year variable as a four digit number.;
data storage.F_acupuncture;
    set storage.F_acupuncture;
    year_num  = input(year, best.);
    format year_num  4.;
run;

proc print data=storage.F_acupuncture (obs=5);
title1 "First 5 rows showing a new year variable.";
run;


*4. Create a month variable as a number.;
data storage.F_acupuncture;
	set storage.F_acupuncture;
	month_num = input(month, best.);
	format month_num z2.;
run;

proc print data=storage.F_acupuncture (obs=5);
title1 "First 5 rows showing a new month variable.";
run;

proc contents data=storage.F_acupuncture;
title1 "Proc contents with month and year as numeric.";
run;


*5. Create a crosstabulation of month (rows) and year (columns) with only counts 
and no percentages.;
proc freq data=storage.F_acupuncture;
	tables month_num*year_num / nocol norow nopercent;
	title1 "Randomization began in January of 2000 and concluded in February 2001.";
	title2 "376 participants were randomized in 2000 and only 25 in 2001.";
	footnote "Reagan Todd, 2025-09-25, SAS version 9.4";
run;

*6. Graph the counts versus time as a scatterplot. 
Recode month and year into a value which is 1 for January 2000, 2 for February 2000, etc. 
Label the axes with the words "January", "February" etc.;

*recoding month and year into a value;
data storage.F_acupuncture;
    set storage.F_acupuncture;
    time_index = (year_num - 2000) * 12 + month_num;
run;


*making month label;
data storage.F_acupuncture;
    set storage.F_acupuncture;
    length month_label $9;
    select (month_num);
        when (1)  month_label = "January";
        when (2)  month_label = "February";
        when (3)  month_label = "March";
        when (4)  month_label = "April";
        when (5)  month_label = "May";
        when (6)  month_label = "June";
        when (7)  month_label = "July";
        when (8)  month_label = "August";
        when (9)  month_label = "September";
        when (10) month_label = "October";
        when (11) month_label = "November";
        when (12) month_label = "December";
        otherwise month_label = "Unknown";
    end;
run;

proc print data=storage.F_acupuncture (obs=5);
title1 "First 5 observations showing the month labels.";
run;

*creating a table to show counts per time
stay away from proc sql, use proc freq;
proc freq data=storage.F_acupuncture noprint;
    tables time_index*month_label*year_num / out=counts_time;
run;

proc print data=counts_time(obs=15);
    title1 "Showing the number of counts that each month of randomization had.";
run;

*creating axis labels;
proc format;
    value monthfmt
        1 = "Jan 2000"
        2 = "Feb 2000"
        3 = "Mar 2000"
        4 = "Apr 2000"
        5 = "May 2000"
        6 = "Jun 2000"
        7 = "Jul 2000"
        8 = "Aug 2000"
        9 = "Sep 2000"
        10 = "Oct 2000"
        11 = "Nov 2000"
        12 = "Dec 2000"
        13 = "Jan 2001"
        14 = "Feb 2001"
        15 = "Mar 2001"
        16 = "Apr 2001"
        17 = "May 2001"
        18 = "Jun 2001"
        19 = "Jul 2001"
        20 = "Aug 2001"
        21 = "Sep 2001";
run;

*creating the scatterplot;
proc sgplot data=counts_time;
    scatter x=time_index y=count / markerattrs=(symbol=CircleFilled color=blue);
    xaxis min=1 max=14 values=(1 to 16 by 2) valuesformat=monthfmt. label="Month";
    yaxis label="Count";
    title1 "This scatterplot shows the counts per month over the course of 14 months";
    footnote "Reagan Todd, 2025-09-25, SAS Version 9.4";
run;

ods pdf close;



