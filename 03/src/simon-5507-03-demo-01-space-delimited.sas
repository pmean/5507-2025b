* 5507-03-simon-demo-01-space-delimited.sas
* author: Steve Simon
* creation date: 2019-07-01
* purpose: to import data with spaces as delimiters
* license: public domain;


* Comments on the code: Documentation header

This is my standard for the documentation
header. It specifies the filename, author,
creation date, purpose, and license.;


%let path=q:/5507-2025b/03;

ods pdf file=
    "&path/results/5507-03-simon-demo-01-space-delimited.pdf";

libname perm
    "&path/data";

filename raw_data
    "&path/data/text-space-delimited.txt";


* Comments on the code: File locations

Since all three file locations (ods, 
libname, and filename) use the same
path, a macro variable can simplify 
things. The %let command creates the
macro variable path, and anywhere
that SAS sees an &path, it replaces 
it with the proper file location.;


data perm.space_delimited;
  infile raw_data;
  input x y z;
run;

proc print
    data=perm.space_delimited(obs=2);
  title1 "First two rows of data";
run;

ods pdf close;


* Comments on the code: Read space-delimited file

Files with one or more blanks between 
each data value are easy to read in
SAS and require no special code;
