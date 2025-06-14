* 5507-03-simon-import-tilde-delimited.sas
* author: Steve Simon
* creation date: 2019-07-01
* purpose: to import comma delimited files
* license: public domain;


* Comments on the code: Documentation header

This is my standard for the documentation
header. It specifies the filename, author,
creation date, purpose, and license.;


%let path=q:/introduction-to-sas;

ods pdf file=
  "&path/results/5507-03-simon-import-tilde-delimited.pdf";

libname perm
  "&path/data";

filename raw_data
  "&path/data/tilde-delimited.txt";
  

* Comments on the code: File locations

This code shows where to print output,
where to store data, and where to find
data.;


data perm.tilde_delimited;
  infile raw_data delimiter="~";
  input x y z;
run;

proc print
    data=perm.tilde_delimited(obs=2);
  title1 "First two rows of data";
run;

ods pdf close;


* Comments on the code: Specifying a tilde delimiter

Anything, including the tilde symbol (~)
can be a delimiter.;
