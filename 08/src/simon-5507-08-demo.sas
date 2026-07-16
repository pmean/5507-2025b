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


filename ;


* Read tab delimited files;


data ;
run;


* Print the first few rows;


proc print
    data= (obs=10);
    title1 "First ten rows";
    footnote "Steve Simon, 2026-07-16, SAS version 9.4";
run;


* Don't forget to close your PDF file;


ods pdf close;
