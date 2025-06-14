* 5507-03-simon-demo-02-comma-delimited.sas
* author: Steve Simon
* creation date: 2019-07-01
* purpose: to import comma delimited files
* license: public domain;


* Comments on the code: Documentation header

This is my standard for the documentation
header. It specifies the filename, author,
creation date, purpose, and license.;


%let path=q:/5507-2025b/03;

ods pdf file=
    "&path/results/5507-03-simon-demo-02-comma-delimited.pdf";

libname perm
    "&path/data";

filename raw_data
    "&path/data/text-comma-delimited.csv";


* Comments on the code: File locations

This code shows where to print output,
where to store data, and where to find
data.;


data perm.comma_delimited;
  infile raw_data delimiter=",";
  input x y z;
run;

proc print
    data=perm.comma_delimited(obs=2);
  title1 "First two rows of data";
run;

ods pdf close;


* Comments on the code: Specifying a comma delimiter

Adding the delimiter keyword to the infile
statement informs SAS that individual data
values in a row of text are separated or
delimited by a specific character. In this
code, the delimiter is a comma.;
