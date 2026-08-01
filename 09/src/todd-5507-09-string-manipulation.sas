*todd-5507-09-string-manipulation.sas
	author: Reagan Todd
	date created: 2025-10-22
	purpose: to understand how to manipulate strings in SAS.
	license: public domain;

ods pdf file= "/home/u63903237/5507/results/todd-5507-09-string-manipulation.pdf";

libname storage "/home/u63903237/5507/data";

filename titanic
	"/home/u63903237/5507/data/titanic.csv";
proc import datafile=titanic
	out=storage.titanic
	dbms=csv
	replace;
	getnames=yes;
run;
proc print 
	data=storage.titanic (obs=15);
	title1 "first 15 rows of Titanic data";
	footnote "Reagan Todd, 2025-10-22, SAS version 9.4";
run;

*1. Take the passenger names and remove any characters at or beyond the first comma (,.*). ;
*Option 1 with scan();
data scan_titanic;
    set storage.titanic;
    scan_titanic = scan(name, 1, ',');
run;
proc freq data=scan_titanic noprint;
    tables scan_titanic / out=scan_freq;
run;
data scan_freq(drop=percent);
    set scan_freq;
run;
data scan_repeats;
    set scan_freq;
    where count > 1;
run;
proc print data=scan_repeats;
    title1 "Scanned last names appearing more than once";
    title2 "There are 235 names that appeared more than once.";
    footnote "Reagan Todd, 2025-10-22, SAS Version 9.4";
run;

*Option 2 with regexp parse;
data parse_titanic;
    set storage.titanic;
    parse_titanic = prxchange('s/,.*//', -1, name);
run;
proc freq data=parse_titanic noprint;
    tables parse_titanic / nopercent out=parse_freq;
run;
data parse_freq(drop=percent);
    set parse_freq;
run;
data parse_repeats;
    set parse_freq;
    where count > 1;
run;
proc print data=parse_repeats;
    title1 "Parse last names appearing more than once";
    title2 "There are 235 names that appeared more than once.";
    footnote "Reagan Todd, 2025-10-22, SAS Version 9.4";
run;


*2. Crosstab of Mr/Mrs and sex.;
data title_categories;
    set storage.titanic;
    if index(name, 'Mrs') > 0 then title_cat = 2;
    else if index(name, 'Miss') > 0 
    	or index(name, 'Ms') > 0 
    	or index(name, 'Madame' ) > 0 
    	or index(name, 'Lady') > 0 then title_cat = 3;
    else if index(name, 'Mr') > 0 
    	or index(name, 'Master') > 0 
    	or index(name, 'Col') > 0 
    	or index(name, ' Colonel') > 0 
    	or index(name, 'Captain') > 0 
    	or index(name, 'Rev') > 0
    	or index(name, 'Major') > 0 
    	or index(name, 'Sir') > 0 then title_cat = 1;
    else title_cat = 9;
    
    format title_cat titlefmt.;
run;
proc format;
    value titlefmt
        1 = 'Mr'
        2 = 'Mrs'
        3 = 'Miss/Ms'
        9 = 'None';
run;
proc freq data=title_categories;
    tables title_cat * sex / norow nocol nopercent;
    title1 "Crosstabulation of title category by sex";
    footnote "Reagan Todd, 2025-10-22, SAS version 9.4";
run;

proc print data=title_categories;
    where title_cat = 9;
    title1 "Passengers with no title";
    title2 "There are 31 passengers with no title. 8 of which are doctors.";
    footnote "Reagan Todd, 2025-10-22, SAS 9.4";
run;

*Seperating name then ensuring frequency;
data titanic_parsed;
    set storage.titanic;
    length LastName Title FirstName MiddleName $50;

    retain re;
   	 if _N_ = 1 then re = prxparse('/^\s*([^,]+),\s*(\S+)\s+(\S+)(.*)$/');

   	 if prxmatch(re, name) then do;
        call prxposn(re, 1, pos1, len1); LastName = substr(name, pos1, len1);
        call prxposn(re, 2, pos2, len2); Title    = substr(name, pos2, len2);
        call prxposn(re, 3, pos3, len3); FirstName = substr(name, pos3, len3);
        call prxposn(re, 4, pos4, len4); MiddleName = strip(substr(name, pos4, len4));
   	 end;
 	drop pos1 pos2 pos3 pos4 len1 len2 len3 len4 re;

run;

proc print data=titanic_parsed (obs=15);
    title1 "First 15 rows of passenger names seperated";
    footnote "Reagan Todd, 2025-10-22, SAS 9.4";
run;

proc freq data=titanic_parsed noprint;
	tables LastName/ out=parsed_LastName;
run;
data parsed_LastName(drop=percent);
    set parsed_LastName;
run;
data parsedLN_repeats;
    set parsed_LastName;
    where count > 1;
run;
proc print data=parsedLN_repeats;
    title1 "Parsed last names appearing more than once";
    title2 "There are 235 names that appeared more than once.";
    footnote "Reagan Todd, 2025-10-22, SAS Version 9.4";
run;

ods pdf close;



