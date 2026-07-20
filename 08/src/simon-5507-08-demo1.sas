* Documentation header


    simon-5507-08-demo1.sas
    author: Steve Simon
    date created: 2026-07-20
    purpose: to illustrate date manipulations
    license: public domain;


* File locations;


%let path=q:/5507-2025b/08;

ods pdf 
    file= "&path/results/simon-5507-08-demo1.pdf";

filename raw_data
  "&path/data/two-digit-years.csv";
  
  
* Comments on the code: In this program, there is
    no libname statement. The file that is read
    exists only to illustrate a few date 
    calculations and does not need permanent
    storage.;


* Read dates as a string;


data storage.sw1;
  infile raw_data;
  input star_wars_day $;
run;

proc print
    data=storage.sw1(obs=10);
  title1 "Listing of Star Wars dates read using string format";
run;

proc contents
    data=storage.sw1;
  title1 "Description of sw1 dataset";
run;


* Commments on the code: Using the dollar sign
    in the input statement will tell SAS to read
    the date in as a string. This is a simple
    and reasonable approach, especially if you
    do not plan to do any calculations or 
    manipulations.;


* Read dates using a date format;

options yearcutoff=1977;

data sw2;
  infile raw_data;
  input star_wars_day mmddyy6.;
run;

proc print
    data=sw2(obs=10);
  title1 "Listing of Star Wars dates read using MMDDYY8. format";
run;

proc contents
    data=sw2;
  title1 "Description of sw2 dataset";
run;


* Comments on the code: Dates like 5-4 are 
    ambiguous because they would be read in as
    May 4 using the US standard and as April 5
    using the European standard. Specifying the
    mmddyy10. format in the input statement
    insures that the dates will all be read in
    as May 4. 

Notice how SAS displays dates using the numeric
    value that is in the internal storage rather
    than a display that is easier to interpret. 
    You have to include a specific date format
    for a nicer display.

Since the first Star Wars was released in 1977, 
    it makes no sense for having a Star Wars
    Day in 1976 or earlier. The yearcutoff
    keyword in the options statement assures
    that any two digit year from 76 and 
    earlier has to be placed in the current
    century.;


* Displaying the dates with nicer formats;


proc sort
    data=sw2;
  by star_wars_day;
run;

proc print
    data=sw2(obs=10);
  format star_wars_day yymmdd10.;
  title1 "Listing of dates using yymmdd10. format";
run;

proc print
    data=sw2(obs=10);
  format star_wars_day weekdate.;
  title1 "Listing of dates using weekdate. format";
run;


* Comments on the code: There are a wide range of
    date formats in SAS. I recommend the yymmdd10.
    format which follows the ISO 8601 standard. If
    you want day of the week and the month spellled
    out, you can use the weeddate. format.;


* Don't forget to close your PDF file;


ods pdf close;
