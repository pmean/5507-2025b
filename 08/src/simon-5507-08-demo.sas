* Documentation header


    simon-5507-08-demo.sas
    author: Steve Simon
    date created: 2026-07-16
    purpose: to illustrate date manipulations
    license: public domain;


* File locations;


%let path=q:/5507-2025b/08;

ods pdf 
    file= "&path/results/simon-5507-08-demo.pdf";

libname storage 
    "&path/data/";


* More file locations;

filename raw_data
  "&path/data/harry-potter-opening-weekend.csv";


* Read tab delimited files;


proc import
    datafile=raw_data 
    dbms=dlm
    out=storage.potter 
    replace;
  delimiter=",";
  getnames=yes;
run;


* Print the first few rows;


proc print
    data=storage.potter;
  title1 "All rows";
  footnote "Steve Simon, 2026-07-16, SAS version 9.4";
run;

proc contents data=storage.potter;
    title1 "Contents of the harry potter opening weekend data";
run;


* Comment on the code: When you are reading in
    dates, you should always check how your dates
    were imported. Did SAS use a string format or
    did they convert to a date format? In this
    case, SAS says that the value of opening_weekend
    is numeric, and is displayed by default as 
    MMDDYY10.;


* Modify the date formats;


proc print
    data=storage.potter;
  format opening_date yymmdd10.;
  title1 "All rows"; 
run;

proc print
    data=storage.potter;
  format opening_date 8.;
  title1 "All rows"; 
run;


* Comment on the code: You can change the display
    of the data using the format statement. The 
    first example shows how you can display dates
    using the ISO 8601 standard. The second 
    example shows how you cn display the
    underlying number, which represents the 
    number of days since January 1, 1960.'


* Check the day of the week;


data qc_check;
  set storage.potter;
  day_of_week=weekday(opening_date);
run;

proc print
    data=qc_check;
  var opening_date day_of_week;
  title1 "Displaying day of week as a quality check";
run;


* Comment on the code: The weekday function 
    computes the day of the week with 1 
    representing Sunday and 7 representing
    Saturday. While I was expecting a 6 for
    Friday (as most movies open on Friday),
    the Sunday value, representing the end 
    of a weekend is fine. It is just
    important to note that the date
    values are consistent: always on a
    Sunday.;


* Compute the start of the opening weekend;


data weekend_range;
  set storage.potter;
  weekend_a=opening_date-2;
  weekend_a=intnx("day", opening_date, -2);
  rename opening_date=weekend_b;
run;

proc print
    data=weekend_range;
  var title weekend_a weekend_b;
  format weekend_a mmddyy10.;
  title1 "Start and end of each weekend";
run;


* Comment on the code: The intnx function will 
    add or subtract a given number of days, 
    weeks, months, or years from a date. For 
    this example, the statement 

    weekend_a=opening_date-2

    would also work. But try to get in the
    habit of using the intnx function because
    it more gracefully handles month and year
    calculations (with the complexities with 
    different days in each month and with
    leap year considerations).;


* Don't forget to close your PDF file;


* Calculate months between openings;


data first_opening;
  set storage.potter (obs=1 keep=opening_date);
  rename opening_date=first_opening;
run;

data merged_files;
  merge storage.potter first_opening;
  months_since_first_opening=
    intck("month", opening_date, first_opening);
run;

proc print
    data=merged_files;
  title1 "Months since first opening";
run;


ods pdf close;
