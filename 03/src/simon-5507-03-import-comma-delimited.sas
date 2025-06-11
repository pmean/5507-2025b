* 5507-03-simon-import-comma-delimited.sas
* author: Steve Simon
* creation date: 2019-07-01
* purpose: to import comma delimited files
* license: public domain;


%let path=q:/introduction-to-sas;

ods pdf file=
    "&path/results/5507-03-simon-import-comma-delimited.pdf";

libname perm
    "&path/data";

filename raw_data
    "&path/data/comma-delimited.csv";

options papersize=(8in 4in) nonumber nodate;


* Comments on the code: Key file locations

I find myself switching often between SAS On
Demand for Academics and SAS on Remote Labs.
One thing to simplify the code is to create a
macro variable. A macro variable is a value
that you specify once, typically right at the
start of your program code, and then use 
repeatedly later in your code. In this
program, I specified a variable path which
is either q:/introduction-to-sas or
/home/mail129/ depending on which system I 
use.

The %let command defines a macro variable. In this case, 




data perm.comma_delimited;
  infile raw_data delimiter=",";
  input x y z;
run;

proc print
    data=perm.comma_delimited(obs=2);
  title1 "First two rows of data";
run;
ods pdf close;
