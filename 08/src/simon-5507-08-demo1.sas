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

libname storage 
    "&path/data/";

filename raw_data
  "&path/data/two-digit-years.csv";


* Read date as a string;


data sw1;
  infile rawdata;
  input star_wars_day $;
run;

proc print
    data=sw1;
  title1 "Listing of 100 Star Wars date values in string format";
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
    manipulations.
    
This dataset and the next are intended just to
    illustrate features of SAS dates and do not
    need to be saved in permanent storage.;


* Read date as a date;


data sw2;
  infile rawdata;
  input star_wars_day mmddyy10.;
run;

proc print
    data=sw2;
  title1 "Listing of 100 Star Wars date values in mmddyy10. format";
run;

proc contents
    data=sw1;
  title1 "Description of sw2 dataset";
run;


* Comments on the code: Dates like 5-4 are 
    ambiguous because they would be read in as
    May 4 using the US standard and as April 5
    using the European standard. Specifying the
    mmddyy10. format in the input statement
    insures that the dates will all be read in
    as May 4.;


* Don't forget to close your PDF file;


ods pdf close;
