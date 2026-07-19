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


* Calculate months since first Potter movie;


data elapsed_time;
  set storage.potter;
  first_opening=input("11-18-2001", mmddyy10.);
  months_since_first_movie =
    intck("month", first_opening, opening_date, "cont");
run;

proc print
    data=elapsed_time;
  format first_opening mmddyy10.;
  title1 "Waiting times";
run;


* Comment on the code: There are two things going
    on here. First, you need to add the first 
    opening date to every row of the dataset. You
    specify the first opening date as a string and
    use the input function to covert it from a 
    string into a date. Then you use the intck 
    function to calculate the number of months 
    between the opening date for each movie and
    the first opening date. There are two ways to
    calculate months, continuous and discrete. 

    The discrete approach would count 12 months 
    between Sorceror's Stone and Chamber of 
    Secrets because you flipped the calendar twelve
    times to get from 11-18-2001 to 11-17-2002.
    The continuous approach would not count the
    last month until you had gone at least 18 days
    into the last month. In most research settings,
    you will probably want the continuous approach.

    Both the discrete and continuous approaches
    produce a whole number. To get a fractional
    number of months, calculate the number of days
    between the dates and divide by 365.25 to get
    a fractional number of years and then multiply
    by 12 to get a fractional number of months.

    This might look something like

    (intck("day", first_opening, opening_date, "cont")/365.25)*12

    An odd quirk of SAS is that proc print will
    often display a date value as the number of
    days since January 1, 1960. Use the format
    statement to prevent this.;


* Don't forget to close your PDF file;


ods pdf close;
