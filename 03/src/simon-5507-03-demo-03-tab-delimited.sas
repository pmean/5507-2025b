* 5507-03-simon-import-tab-delimited.sas
* author: Steve Simon
* creation date: 2019-07-01
* purpose: to import a comma delimited file into SAS
* license: public domain;


* Comments on the code: Documentation header

This is my standard for the documentation
header. It specifies the filename, author,
creation date, purpose, and license.;


%let path=q:/introduction-to-sas;

ods pdf file=
    "&path/results/5507-03-simon-import-tab-delimited.pdf";

libname perm
    "&path/data";

filename raw_data
  "&path/data/tab-delimited.txt";


* Comments on the code: File locations

This code shows where to print output,
where to store data, and where to find
data.;


data perm.tab_delimited;
  infile raw_data delimiter="09"X;
  input x y z;
run;

proc print
    data=perm.tab_delimited(obs=2);
  title1 "First two rows of data";
run;

ods pdf close;


* Comments on the code: Specifying a tab delimiter

The code "09"X designates a tab as the
delimiter.;
